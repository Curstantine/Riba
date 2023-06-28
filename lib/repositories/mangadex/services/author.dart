// ignore_for_file: public_member_api_docs, sort_constructors_first

import "dart:convert";
import "dart:io";

import "package:copy_with_extension/copy_with_extension.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/local/models/author.dart";
import "package:riba/repositories/mangadex/models/author.dart";
import "package:riba/repositories/mangadex/utils/service.dart";
import "package:riba/repositories/runtime/collection.dart";
import "package:riba/repositories/utils/rate_limiter.dart";
import "package:riba/repositories/utils/url.dart";

part "author.g.dart";

class MangaDexAuthorService extends MangaDexService<
	AuthorAttributes, Author, Author, Author,
	MangaDexGenericQueryFilter,
	MangaDexGenericQueryFilter,
	MangaDexAuthorWithFilterQueryFilter
> {
	MangaDexAuthorService({
		required super.client,
		required super.rateLimiter,
		required super.database,
		required super.rootUrl,
	});
	
	@override
	final logger = Logger("MangaDexAuthorService");

	@override
	final Map<String, Rate> rates = {
		"/author:GET": const Rate(4, Duration(seconds: 1)),
	};

	@override
	Directory get cacheDir => throw UnimplementedError();

	@override
	Directory get dataDir => throw UnimplementedError();

	@override
	late final baseUrl = rootUrl.copyWith(pathSegments: ["author"]);

	@override
	final defaultFilters = const MangaDexGenericQueryFilter(
		includes: [],
		limit: 100,
	);

	@override
	Future<Author> get(String id, {bool checkDB = true}) {
		// TODO: implement get
		throw UnimplementedError();
	}

	@override
	@Deprecated(
		"Will not be implemented, used as a stub for the interface. Use getManyAsSingle instead.")
	Future<Map<String, Author>> getMany({required overrides, checkDB = true}) {
		throw UnimplementedError();
	}

	@override
	Future<CollectionData<Author>> withFilters({required overrides}) async {
		logger.info("withFilters(${overrides.toString()})");

		await rateLimiter.wait("/author:GET");
		final reqUrl = baseUrl.clone().addFilters(defaultFilters).addFilters(overrides);
		final request = await client.get(reqUrl.toUri());
		final response = AuthorCollection.fromMap(jsonDecode(request.body), url: reqUrl);

		final data = response.data.map((e) => e.toAuthor()).toList();
		await database.isar.writeTxn(() => Future.wait(data.map(insertMeta)));

		return CollectionData(
			data: data,
			limit: response.limit,
			offset: response.offset,
			total: response.total,
		);
	}

	@override
	Future<void> insertMeta(Author data) async {
		await Future.wait([
			database.isar.authors.put(data),
		]);
	}

	@override
	Future<Author> collectMeta(Author single) async {
		throw UnimplementedError();
	}
}

@CopyWith()
class MangaDexAuthorWithFilterQueryFilter implements MangaDexQueryFilter {
	final int limit;
	final int offset;

	final String? name;
	final bool orderByNameDesc;

	const MangaDexAuthorWithFilterQueryFilter({
		this.limit = 100,
		this.offset = 0,
		this.name,
		this.orderByNameDesc = true, 
	});

	@override
	URL addFiltersToUrl(URL sourceUrl) {
		if (name != null) sourceUrl.setParameter("name", name);
		if (orderByNameDesc) sourceUrl.setParameter("order[name]", "desc");

		return MangaDexGenericQueryFilter(limit: limit, offset: offset).addFiltersToUrl(sourceUrl);
	}

	@override
	String toString() {
		return "MangaDexAuthorWithFilterQueryFilter(limit: $limit, offset: $offset, name: $name, orderByNameDesc: $orderByNameDesc)";
	}
}
