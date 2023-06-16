// ignore_for_file: public_member_api_docs, sort_constructors_first
import "dart:convert";
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/cover_art.dart";
import "package:riba/repositories/local/models/localization.dart";
import "package:riba/repositories/local/models/user.dart";
import "package:riba/repositories/mangadex/models/cover_art.dart";
import "package:riba/repositories/mangadex/models/error.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/runtime/cover_art.dart";
import "package:riba/repositories/utils/enumerate.dart";
import "package:riba/repositories/utils/exception.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";
import "package:riba/utils/hash.dart";

part "cover_art.g.dart";

class MangaDexCoverService extends MangaDexService<
	CoverArtAttributes, CoverArt, CoverArtData, CoverArtData,
	MangaDexGenericQueryFilter,
	MangaDexCoverGetManyQueryFilter,
	MangaDexGenericQueryFilter
> {
	@override
	final Directory dataDir;

	@override
	final Directory cacheDir;

	MangaDexCoverService({
		required super.client,
		required super.rateLimiter,
		required super.database,
		required super.rootUrl,
		required this.dataDir,
		required this.cacheDir,
	});

	@override
	final logger = Logger("MangaDexCoverService");

	@override
	final rates = {
		"/cover:GET": const Rate(4, Duration(seconds: 1)),
		"/cover/image:GET": const Rate(4, Duration(seconds: 1)),
	};

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["cover"]);
	final cdnUrl = URL(hostname: "uploads.mangadex.org", pathSegments: ["covers"]);

	@override
	final defaultFilters = const MangaDexGenericQueryFilter(
		includes: [
			EntityType.user,
		],
		limit: 100,
	);

	@override
	Future<CoverArtData> get(String id, {bool checkDB = true}) async {
		logger.info("get($id, $checkDB)");

		if (checkDB) {
			final inDB = await database.get(fastHash(id));
			if (inDB != null) return collectMeta(inDB);
		}

		await rateLimiter.wait("/cover:GET");

		final reqUrl = baseUrl.clone().addPathSegment(id).addFilters(defaultFilters);
		final request = await client.get(reqUrl.toUri());
		final response = CoverArtEntity.fromMap(jsonDecode(request.body));

		final coverData = response.data.asCoverArtData();
		await database.isar.writeTxn(() => insertMeta(coverData));

		return coverData;
	}

	@override
	Future<Map<String, CoverArtData>> getMany({required overrides, checkDB = true}) async {
		logger.info("getMany(${overrides.toString()}, $checkDB)");

		final mapped = <String, CoverArtData?>{for (final e in overrides.ids) e: null};

		if (checkDB) {
			final locales = overrides.locales ?? const [];
			final inDB = await database
				.where()
				.anyOf(overrides.ids, (q, e) => q.isarIdEqualTo(fastHash(e)))
				.filter()
				.locale((q) => q.allOf(locales, (q, e) => q.languageEqualTo(e.language).and().romanizedEqualTo(e.romanized)))
				.optional(overrides.orderByVolumeDesc, (q) => q.sortByMangaId().thenByVolumeDesc())
				.findAll();

			final allMeta = database.isar.txn(() => Future.wait(inDB.map((e) => collectMeta(e))));
			for (final meta in await allMeta) {
				mapped[meta.cover.id] = meta;
			}
		}

		final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
		if (missing.isEmpty) return mapped.cast<String, CoverArtData>();

		final hoistedUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);

		final block = Enumerate<String, CoverArtData>(
			items: missing,
			perStep: defaultFilters.limit!,
			onStep: (resolved) async {
				await rateLimiter.wait("/cover:GET");

				final reqUrl = hoistedUrl.setParameter("ids[]", resolved.keys.toList());
				final request = await client.get(reqUrl.toUri());
				final response = CoverArtCollection.fromMap(jsonDecode(request.body));

				for (final cover in response.data) {
					final coverData = cover.asCoverArtData();
					resolved[cover.id] = coverData;
				}
			},
			onMismatch: (missedIds) {
				logger.warning("Some entries were not in the response, ignoring them: $missedIds");
				for (final id in missedIds) {
					mapped.remove(id);
				}
			},
		);

		final res = await block.run();
		await database.isar.writeTxn(() => Future.wait(res.values.map(insertMeta)));
		return mapped.cast<String, CoverArtData>()..addAll(res);
	}

	/// Returns all the [CoverArtData] related to a manga.
	///
	/// This method internally handles pagination.
	Future<List<CoverArtData>> getManyByMangaId({
		required MangaDexCoverGetManyByMangaIdQueryFilter overrides,
		bool checkDB = true,
	}) async {
		logger.info("getManyByMangaId(${overrides.toString()}, $checkDB)");

		if (checkDB) {
			final locales = overrides.locales ?? const [];
			final inDB = await database
				.where()
				.mangaIdEqualTo(overrides.mangaId)
				.filter()
				.locale((q) => q.anyOf(locales, (q, e) => q.languageEqualTo(e.language).romanizedEqualTo(e.romanized)))
				.optional(overrides.orderByVolumeDesc, (q) => q.sortByVolumeDesc())
				.findAll();

			if (overrides.orderByVolumeDesc) inDB.sortInDesc();
			if (inDB.isNotEmpty) {
				return await Future.wait(inDB.map(collectMeta));
			}
		}

		int offset = 0;
		final covers = <CoverArtData>[];

		final hoistedUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);

		while (true) {
			await rateLimiter.wait("/cover:GET");
			
			final reqUrl = hoistedUrl.setParameter("offset", offset);
			final request = await client.get(reqUrl.toUri());
			final response = CoverArtCollection.fromMap(jsonDecode(request.body));

			for (final cover in response.data) {
				try {
					final coverData = cover.asCoverArtData();
					covers.add(coverData);
				} on LanguageNotSupportedException catch (e) {
					logger.warning(e.toString());
				}
			}

			if ((response.offset + response.limit) >= response.total) break;
			offset += response.limit;
		}

		await database.isar.writeTxn(() => Future.wait(covers.map(insertMeta)));
		return covers;
	}

	@override
	@Deprecated("Will not be implemented, used as a stub for the interface.")
	Future<CollectionData<CoverArtData>> withFilters({required overrides}) {
		throw UnimplementedError();
	}

	@override
	Future<void> insertMeta(CoverArtData data) async {
		await Future.wait([
			database.put(data.cover),
			if (data.user != null) database.isar.users.put(data.user!),
		]);
	}

	@override
	Future<CoverArtData> collectMeta(CoverArt single) async {
		return CoverArtData(
			cover: single,
			user: single.userId == null ? null : await database.isar.users.get(fastHash(single.userId!)),
		);
	}

	/// Downloads a cover art based on the passed [mangaId], [coverArt] and [size].
	///
	/// When [cache] is true, the cover art will be stored in [persistentCoverDir],
	/// else the cover art will be stored in [temporaryCoverDir].
	///
	/// Returns the handle to the downloaded cover art.
	Future<File> getImage(
		String mangaId,
		CoverArt coverArt, {
		CoverSize size = CoverSize.original,
		bool cache = true,
	}) async {
		logger.info("getImage($mangaId, ${coverArt.id}, $size, $cache)");

		final file = getFile(mangaId, coverArt.fileId, coverArt.fileType, size, cache);
		if (await file.exists()) return file;

		await rateLimiter.wait("/cover/image:GET");
		final fileName = getFileName(coverArt.fileId, size, coverArt.fileType);
		final reqUrl = cdnUrl.clone().addPathSegments([mangaId, fileName]);

		final response = await client.get(reqUrl.toUri());
		final contentType = response.headers["content-type"];

		if (response.statusCode != 200 || contentType == null) {
			throw MDException(
				MDError(status: response.statusCode, title: "Failed to retrieve the cover art"),
				url: reqUrl,
			);
		}

		await file.create(recursive: true);
		return await file.writeAsBytes(response.bodyBytes);
	}

	/// Returns the local file name for the given [fileId], [type] and [size].
	///
	/// If [size] is anything other than [CoverSize.original], the file type will
	/// always be [ImageFileType.jpeg]. Reason being that the server only serves
	/// JPEG images for smaller sizes.
	///
	/// e.g.:
	/// ```
	///   CoverSize.original, ImageFileType.png -> "filename.png"
	///   CoverSize.medium, ImageFileType.png -> "filename.png.256.jpg"
	///   CoverSize.small, ImageFileType.png -> "filename.png.256.jpg"
	/// ```
	///
	/// ### How and why does this differ from the usual way?
	///
	/// Since we need to store the file type in the database,
	/// we derive the `fileName` (e.g. `be86d5f4-8bbf-43eb-9d7b-bce8a2f09926.jpg`) into two parts:
	/// 1. `fileId`
	/// 2. `fileType`
	///
	/// Which we then append together to get both local and server file names.
	String getFileName(String fileId, CoverSize size, ImageFileType type) {
		final sizeSuffix = size.size != null ? ".${size.size}" : "";
		final typeSuffix = size.size != null ? ".jpg" : "";

		return "$fileId.${type.getExtension()}$sizeSuffix$typeSuffix";
	}

	/// Returns the file for the given [mangaId], [fileId], [type], [size] and persistence type.
	///
	/// This method does not check whether the file exists or not.
	///
	/// If [size] is anything other than [CoverSize.original], the file type will
	/// always be [ImageFileType.jpeg]. Check [getFileName] for more info.
	File getFile(String mangaId, String fileId, ImageFileType type, CoverSize size, bool persist) {
		final name = getFileName(fileId, size, type);
		final base = persist ? dataDir : cacheDir;

		return File("${base.path}/$mangaId/$name");
	}

	/// Deletes the [persistentCoverDir] directory that contains all the persistent cover art files.
	Future<void> deleteAllPersistent() async {
		if (await dataDir.exists()) await dataDir.delete(recursive: true);
	}

	/// Deletes the [temporaryCoverDir] directory that contains all the temporary cover art files.
	Future<void> deleteAllTemp() async {
		if (await cacheDir.exists()) await cacheDir.delete(recursive: true);
	}
}

@CopyWith()
class MangaDexCoverGetManyQueryFilter implements MangaDexQueryFilter {
	final List<String> ids;
	final List<Locale>? locales;
	final bool orderByVolumeDesc;

	const MangaDexCoverGetManyQueryFilter({
		required this.ids,
		this.locales,
		this.orderByVolumeDesc = true,
	});
	
	@override
	URL addFiltersToUrl(URL sourceUrl) {
		sourceUrl.setParameter("ids[]", ids);
		if (locales != null) sourceUrl.setParameter("locales[]", locales!);
		if (orderByVolumeDesc) sourceUrl.setParameter("order[volume]", "desc");

		return sourceUrl;
	}

	@override
	String toString() => "MangaDexCoverGetManyQueryFilter(ids: $ids, locales: $locales, orderByVolumeDesc: $orderByVolumeDesc)";
}

class MangaDexCoverGetManyByMangaIdQueryFilter implements MangaDexQueryFilter {
	final String mangaId;
	final List<Locale>? locales;
	final bool orderByVolumeDesc;

	const MangaDexCoverGetManyByMangaIdQueryFilter({
		required this.mangaId,
		this.locales,
		this.orderByVolumeDesc = true,
	});
	
	@override
	URL addFiltersToUrl(URL sourceUrl) {
		sourceUrl.setParameter("manga[]", mangaId);
		if (locales != null) sourceUrl.setParameter("locales[]", locales!);
		if (orderByVolumeDesc) sourceUrl.setParameter("order[volume]", "desc");

		return sourceUrl;
	}

	@override
	String toString() => "MangaDexCoverGetManyByMangaIdQueryFilter(mangaId: $mangaId, locales: $locales, orderByVolumeDesc: $orderByVolumeDesc)";
}
