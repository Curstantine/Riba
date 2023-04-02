import "package:riba/repositories/mangadex/group.dart";
import "package:riba/repositories/mangadex/models/author.dart";
import "package:riba/repositories/mangadex/models/chapter.dart";
import "package:riba/repositories/mangadex/models/cover_art.dart";
import "package:riba/repositories/mangadex/models/custom_list.dart";
import "package:riba/repositories/mangadex/models/general.dart";
import "package:riba/repositories/mangadex/models/manga.dart";
import "package:riba/repositories/mangadex/models/tag.dart";
import "package:riba/repositories/mangadex/models/user.dart";

T transformToEntity<T>(Map<String, dynamic> map, EntityType type) {
  late T attributes;

  switch (type) {
    case EntityType.manga:
      attributes = MangaAttributes.fromMap(map) as T;
      break;

    case EntityType.chapter:
      attributes = ChapterAttributes.fromMap(map) as T;
      break;

    case EntityType.customList:
      attributes = CustomListAttributes.fromMap(map) as T;
      break;

    case EntityType.author:
    case EntityType.artist:
      attributes = AuthorAttributes.fromMap(map) as T;
      break;

    case EntityType.tag:
      attributes = TagAttributes.fromMap(map) as T;
      break;

    case EntityType.coverArt:
      attributes = CoverArtAttributes.fromMap(map) as T;
      break;

    case EntityType.user:
    case EntityType.leader:
    case EntityType.member:
      attributes = UserAttributes.fromMap(map) as T;
      break;

    case EntityType.scanlationGroup:
      attributes = GroupAttributes.fromMap(map) as T;
      break;

    default:
      throw UnimplementedError("Entity: $type, on T: $T is not implemented yet.");
  }

  return attributes;
}
