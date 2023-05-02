import "package:isar/isar.dart";
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

  late String fileId;

  late String? volume;
  late String? description;
  late Locale? locale;

  @Index()
  late String mangaId;
  late String? userId;

  late DateTime createdAt;
  late DateTime updatedAt;
  late int version;

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
    required this.mangaId,
    this.userId,
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

/// NOTE: DO NOT CHANGE THE ORDER OF THE ENUM
enum CoverSize {
  original(null),
  medium(512),
  small(256);

  final int? size;
  const CoverSize(this.size);

  String asHumanReadable() {
    switch (this) {
      case CoverSize.original:
        return "Original";
      case CoverSize.medium:
        return "Medium";
      case CoverSize.small:
        return "Small";
    }
  }
}

extension SortCoverArt on List<CoverArt> {
	void sortInDesc() => sort((a, b) {
		if (a.volume != null && b.volume != null) {
			final aVolume = double.parse(a.volume!);
			final bVolume = double.parse(b.volume!);

			return bVolume.compareTo(aVolume);
		}

		return 0;
	});
}
