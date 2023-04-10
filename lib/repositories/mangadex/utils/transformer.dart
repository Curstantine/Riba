import "package:riba/repositories/mangadex/models/author.dart";
import "package:riba/repositories/mangadex/models/chapter.dart";
import "package:riba/repositories/mangadex/models/cover_art.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/group.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/models/user.dart";

/// Transforms an entity to its corresponding model.
T transformToEntity<T>(Map<String, dynamic> map, EntityType type) {
  switch (type) {
    case EntityType.author:
    case EntityType.artist:
      return AuthorAttributes.fromJson(map) as T;

    case EntityType.chapter:
      return ChapterAttributes.fromJson(map) as T;

    case EntityType.coverArt:
      return CoverArtAttributes.fromJson(map) as T;

    case EntityType.customList:
      return CustomListAttributes.fromJson(map) as T;

    case EntityType.manga:
      return MangaAttributes.fromJson(map) as T;

    case EntityType.scanlationGroup:
      return GroupAttributes.fromJson(map) as T;

    case EntityType.tag:
      return TagAttributes.fromJson(map) as T;

    case EntityType.user:
    case EntityType.leader:
    case EntityType.member:
      return UserAttributes.fromJson(map) as T;

    default:
      throw UnimplementedError("Entity: $type, on T: $T is not implemented yet.");
  }
}
