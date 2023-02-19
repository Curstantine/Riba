import "package:hive/hive.dart";
import "package:isar/isar.dart";
import "package:riba/utils/constants.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "cover_art.g.dart";

/// CoverArt model to be stored in the local database.
///
/// ### Note
/// This model doesn't implement an eq operator, as it is impossible to do that
/// without losing performance. Instead, use the [isLooselyEqual] method.
@Collection(accessor: "covers")
class CoverArt {
  late String id;
  Id get isarId => fastHash(id);

  late String? volume;
  late String fileId;
  late String? description;
  late Locale? locale;
  late DateTime createdAt;
  late DateTime updatedAt;
  late int version;

  late String manga;
  late String? user;

  @Enumerated(EnumType.ordinal)
  late ImageFileType fileType;

  CoverArt({
    required this.id,
    required this.volume,
    required this.fileId,
    required this.fileType,
    required this.description,
    required this.locale,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
    required this.manga,
    this.user,
  });

  /// Checks if the given [CoverArt] has the same [id], [fileId], [version] as this.
  bool isLooselyEqual(CoverArt other) {
    return id == other.id && fileType == other.fileType && version == other.version;
  }

  @override
  // ignore: hash_and_equals
  operator ==(Object other) {
    throw UnimplementedError();
  }
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum ImageFileType {
  jpeg,
  png,
  gif;

  String get extension {
    switch (this) {
      case ImageFileType.jpeg:
        return "jpg";
      case ImageFileType.png:
        return "png";
      case ImageFileType.gif:
        return "gif";
    }
  }

  static ImageFileType fromExtension(String value) {
    switch (value) {
      case "jpg":
        return ImageFileType.jpeg;
      case "png":
        return ImageFileType.png;
      case "gif":
        return ImageFileType.gif;
      default:
        throw Exception("Unknown image file type: $value");
    }
  }

  static ImageFileType fromContentType(String value) {
    switch (value) {
      case "image/jpeg":
        return ImageFileType.jpeg;
      case "image/png":
        return ImageFileType.png;
      case "image/gif":
        return ImageFileType.gif;
      default:
        throw Exception("Unknown image file type: $value");
    }
  }
}

@HiveType(typeId: TypeAdapterIds.coverSizeAdapter)
enum CoverSize {
  @HiveField(0)
  original(null),

  @HiveField(1)
  medium(512),

  @HiveField(2)
  small(256);

  final int? size;
  const CoverSize(this.size);

  String get human => name.substring(0, 1).toUpperCase() + name.substring(1);
}
