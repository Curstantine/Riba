import "package:isar/isar.dart";

import "appearance/controller.dart";
import "content_filter/controller.dart";
import "cover_persistence/controller.dart";
import "manga_filter/controller.dart";

class Settings {
	static late final Settings instance;
	Settings._internal({required this.isar});

	final Isar isar;

	late final appearance = AppearanceSettingsController(isar: isar);
	late final contentFilter = ContentFilterSettingsController(isar: isar);
	late final coverPersistence = CoverPersistenceSettingsController(isar: isar);
	late final mangaFilter = MangaFilterSettingsController(isar: isar);

	static Future<void> init(Isar isar) async {
		instance = Settings._internal(isar: isar);
		
		await Future.wait([
			instance.appearance.load(),
			instance.contentFilter.load(),
			instance.coverPersistence.load(),
		]);
	}
}

/// Base controller to extend for settings that are unique per collection.
abstract class CollectionSettingsController<T> {
	final Isar isar;
	/// The store that contains all the settings.
	/// This variable should be updated along with the other state variables derived from it.
	late T store;

	CollectionSettingsController({required this.isar});

	Future<void> load();
	Future<void> reset();
	Stream<T> watch({bool fireImmediately = false});
	Stream<void> watchLazily({bool fireImmediately = false});
}

/// Base controller to extend for settings that are unique per entity.
abstract class EntitySettingsController<T> {
	final Isar isar;
	EntitySettingsController({required this.isar});
	
	Future<T> get(String id);
	Future<void> reset(String id);
	Stream<T> watch(String id, {bool fireImmediately = false});
	Future<void> update(T settings, {bool silent = false});
}