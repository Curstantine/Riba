import "package:copy_with_extension/copy_with_extension.dart";
import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "settings.dart";

part "manga_filter.g.dart";

@CopyWith()
@Collection(accessor: "mangaFilterSettings")
class MangaFilterSettings {
	static final ref = Settings.instance.mangaFilterSettings;

	/// The manga id
	final String id;
	Id get isarId => fastHash(id);

	final List<String> excludedGroupIds;

	bool get isDefault => excludedGroupIds.isEmpty;

	MangaFilterSettings({
		required this.id,
		required this.excludedGroupIds,
	});
}

extension MangaFilterDefaults on MangaFilterSettings? {
	MangaFilterSettings orDefault(String id) {
		return this ?? MangaFilterSettings(id: id, excludedGroupIds: []);
	}
}
