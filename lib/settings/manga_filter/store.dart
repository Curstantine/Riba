import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

part "store.g.dart";

@CopyWith()
@Collection(accessor: "mangaFilterSettings")
class MangaFilterSettingsStore {
	/// The manga id
	final String id;
	Id get isarId => fastHash(id);

	final List<String> excludedGroupIds;

	const MangaFilterSettingsStore({
		required this.id,
		required this.excludedGroupIds,
	});

	bool get isDefault => excludedGroupIds.isEmpty;

	static MangaFilterSettingsStore defaultSettings(String id) => MangaFilterSettingsStore(
		id: id,
		excludedGroupIds: [],
	);
}

extension MangaFilterDefaults on MangaFilterSettingsStore? {
	MangaFilterSettingsStore orDefault(String id) {
		return this ?? MangaFilterSettingsStore(id: id, excludedGroupIds: []);
	}
}
