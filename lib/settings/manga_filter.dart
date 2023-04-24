import "package:isar/isar.dart";
import "package:riba/utils/hash.dart";

import "settings.dart";

part "manga_filter.g.dart";

@Collection(accessor: "mangaFilterSettings")
class MangaFilterSettings {
	static final ref = Settings.instance.mangaFilterSettings;

	/// The manga id
	final String id;
	Id get isarId => fastHash(id);

	late List<String> excludedGroupIds;

	bool get isDefault => excludedGroupIds.isEmpty;

	MangaFilterSettings({
		required this.id,
		required this.excludedGroupIds,
	});

	MangaFilterSettings copyWith({
		String? id,
		List<String>? excludedGroupIds,
	}) {
		return MangaFilterSettings(
			id: id ?? this.id,
			excludedGroupIds: excludedGroupIds ?? this.excludedGroupIds,
		);
	}
}

extension MangaFilterDefaults on MangaFilterSettings? {
	MangaFilterSettings orDefault(String id) {
		return this ?? MangaFilterSettings(id: id, excludedGroupIds: []);
	}
}
