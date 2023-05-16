import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "localization.dart";

part "cover_art.g.dart";

@Collection(accessor: "covers")
class CoverArt {
	final String id;
	Id get isarId => fastHash(id);

	final String fileId;

	final String? volume;
	final String? description;
	final Locale? locale;

	@Index()
	final String mangaId;
	final String? userId;

	final DateTime createdAt;
	final DateTime updatedAt;
	final int version;

	@Enumerated(EnumType.ordinal)
	final ImageFileType fileType;

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
}

// CAUTION: DO NOT CHANGE THE ORDER OF THE ENUM
enum ImageFileType {
	jpeg,
	png,
	gif;

	String getExtension( ) {
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
