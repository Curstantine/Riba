import "dart:convert";

import "package:http/http.dart";
import "package:isar/isar.dart";
import "package:logging/logging.dart";
import "package:riba/repositories/enumerate.dart";
import "package:riba/repositories/local/chapter.dart";
import "package:riba/repositories/local/group.dart";
import "package:riba/repositories/local/localization.dart";
import "package:riba/repositories/local/user.dart";
import "package:riba/repositories/mangadex/general.dart";
import "package:riba/repositories/mangadex/group.dart";
import "package:riba/repositories/mangadex/relationship.dart";
import "package:riba/repositories/mangadex/user.dart";
import "package:riba/repositories/rate_limiter.dart";
import "package:riba/repositories/runtime/chapter.dart";
import "package:riba/repositories/url.dart";
import "package:riba/utils/hash.dart";

import "error.dart";
import "mangadex.dart";

typedef MDChapterCollection = MDCollectionResponse<ChapterAttributes>;

class MDChapterRepo {
  final Client client;
  final RateLimiter rateLimiter;
  final Isar database;
  final logger = Logger("MDChapterRepo");

  MDChapterRepo(this.client, this.rateLimiter, this.database) {
    rateLimiter.rates["/chapter:GET"] = const Rate(4, Duration(seconds: 1));
  }

  final url = MangaDex.url.copyWith(pathSegments: ["chapter"]);

  final includes = [
    EntityType.user.toJsonValue(),
    EntityType.scanlationGroup.toJsonValue(),
  ];

  Future<Map<String, ChapterData>> getMany(List<String> ids, {bool checkDB = true}) async {
    logger.info("getMany($ids, $checkDB)");

    final Map<String, ChapterData?> mapped = {for (var e in ids) e: null};

    if (checkDB) {
      final inDB = await database.chapters.getAll(ids.map((e) => fastHash(e)).toList());
      for (final manga in inDB) {
        if (manga == null) continue;
        mapped[manga.id] = await _collectMeta(manga);
      }
    }

    final missing = mapped.entries.where((e) => e.value == null).map((e) => e.key).toList();
    if (missing.isEmpty) return mapped.cast();

    final block = Enumerate<String, ChapterData>(
      perStep: 100,
      items: missing,
      onStep: (resolved) async {
        await rateLimiter.wait("/chapter:GET");
        final reqUrl = url
            .copy()
            .setParameter("ids[]", resolved.keys.toList())
            .setParameter("includes[]", includes)
            .setParameter("limit", 100);
        final request = await client.get(reqUrl.toUri());
        final response = MDChapterCollection.fromMap(jsonDecode(request.body), url: reqUrl);

        for (final data in response.data) {
          final chapter = data.toChapterData();
          _insertMeta(chapter);
          resolved[data.id] = chapter;
        }
      },
      onMismatch: (missedIds) {
        logger.warning("Some entries were not in the response, ignoring them: $missedIds");
      },
    );

    mapped.addAll(await block.run());
    return mapped.cast();
  }

  Future<void> _insertMeta(ChapterData chapterData) async {
    await database.writeTxn(() async {
      await Future.wait([
        database.chapters.put(chapterData.chapter),
        database.groups.putAll(chapterData.groups),
        database.users.put(chapterData.uploader),
      ]);
    });
  }

  Future<ChapterData> _collectMeta(Chapter chapter) async {
    final data = await Future.wait([
      database.groups.getAll(chapter.groupIds.map((e) => fastHash(e)).toList()),
      database.users.get(fastHash(chapter.uploaderId)),
    ]);

    return ChapterData(
      chapter: chapter,
      groups: (data[0] as List<Group?>).cast(),
      uploader: data[1] as User,
    );
  }
}

class ChapterAttributes {
  final String? title;
  final String? volume;
  final String? chapter;
  final int pages;
  final String translatedLanguage;
  final String uploader;
  final String? externalUrl;
  final int version;

  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime publishAt;
  final DateTime readableAt;

  const ChapterAttributes({
    this.title,
    this.volume,
    this.chapter,
    required this.pages,
    required this.translatedLanguage,
    required this.uploader,
    this.externalUrl,
    required this.version,
    required this.createdAt,
    required this.updatedAt,
    required this.publishAt,
    required this.readableAt,
  });

  factory ChapterAttributes.fromMap(Map<String, dynamic> map) {
    return ChapterAttributes(
      title: map["title"] != null ? map["title"] as String : null,
      volume: map["volume"] != null ? map["volume"] as String : null,
      chapter: map["chapter"] != null ? map["chapter"] as String : null,
      pages: map["pages"] as int,
      translatedLanguage: map["translatedLanguage"] as String,
      uploader: map["uploader"] as String,
      externalUrl: map["externalUrl"] != null ? map["externalUrl"] as String : null,
      version: map["version"] as int,
      createdAt: DateTime.parse(map["createdAt"] as String),
      updatedAt: DateTime.parse(map["updatedAt"] as String),
      publishAt: DateTime.parse(map["publishAt"] as String),
      readableAt: DateTime.parse(map["readableAt"] as String),
    );
  }

  factory ChapterAttributes.fromJson(String source) =>
      ChapterAttributes.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Aggregated {
  final Map<String, AggregatedVolume> volumes;
  const Aggregated({required this.volumes});

  factory Aggregated.fromMap(Map<String, dynamic> map, {URL? url}) {
    final result = map["result"] as String;

    if (result == "error") {
      final errors = MDError.fromMap((map["errors"] as List<dynamic>)[0]);
      throw MDException(errors, url: url);
    }

    return Aggregated(
      volumes: (map["volumes"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, AggregatedVolume.fromMap(value as Map<String, dynamic>)),
      ),
    );
  }

  factory Aggregated.fromJson(String source) =>
      Aggregated.fromMap(json.decode(source) as Map<String, dynamic>);
}

class AggregatedVolume {
  final String volume;
  final Map<String, AggregatedChapter> chapters;
  final int count;

  const AggregatedVolume({
    required this.volume,
    required this.chapters,
    required this.count,
  });

  factory AggregatedVolume.fromMap(Map<String, dynamic> map) {
    return AggregatedVolume(
      volume: map["volume"] as String,
      chapters: (map["chapters"] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, AggregatedChapter.fromMap(value as Map<String, dynamic>)),
      ),
      count: map["count"] as int,
    );
  }
}

class AggregatedChapter {
  final String chapter;
  final List<String> others;
  final int count;

  const AggregatedChapter({
    required this.chapter,
    required this.others,
    required this.count,
  });

  factory AggregatedChapter.fromMap(Map<String, dynamic> map) {
    return AggregatedChapter(
      chapter: map["chapter"] as String,
      others: (map["others"] as List<dynamic>).map((e) => e as String).toList(),
      count: map["count"] as int,
    );
  }
}

extension on MDResponseData<ChapterAttributes> {
  Chapter toChapter() {
    return Chapter(
      id: id,
      mangaId: relationships.ofType(EntityType.manga).first.id,
      uploaderId: relationships.ofType(EntityType.user).map((e) => e.id).first,
      groupIds: relationships.ofType(EntityType.scanlationGroup).map((e) => e.id).toList(),
      title: attributes.title,
      volume: attributes.volume,
      chapter: attributes.chapter,
      pages: attributes.pages,
      translatedLanguage: Locale.fromJsonValue(attributes.translatedLanguage),
      externalUrl: attributes.externalUrl,
      createdAt: attributes.createdAt,
      updatedAt: attributes.updatedAt,
      publishAt: attributes.publishAt,
      readableAt: attributes.readableAt,
      version: attributes.version,
    );
  }

  ChapterData toChapterData() {
    return ChapterData(
      chapter: toChapter(),
      uploader: relationships.ofType<UserAttributes>(EntityType.user).first.toUser(),
      groups: relationships
          .ofType<GroupAttributes>(EntityType.scanlationGroup)
          .map((e) => e.toGroup())
          .toList(),
    );
  }
}
