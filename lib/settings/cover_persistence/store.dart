import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/repositories/local/models/cover_art.dart";

part "store.g.dart";

@CopyWith()
@Collection(accessor: "coverPersistenceSettings")
class CoverPersistenceSettingsStore {
	final Id id = 1;

	final bool enabled;

	@Enumerated(EnumType.ordinal)
	final CoverSize previewSize;

	@Enumerated(EnumType.ordinal)
	final CoverSize fullSize;

	CoverPersistenceSettingsStore({
		required this.enabled,
		required this.previewSize,
		required this.fullSize,
	});

	static final defaultSettings = CoverPersistenceSettingsStore(
		enabled: true,
		previewSize: CoverSize.medium,
		fullSize: CoverSize.original,
	);
}

