package moe.curstantine.riba.api.mangadex.database

import androidx.room.TypeConverter
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.*
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class Converters {
	@TypeConverter
	fun fromListString(list: List<String>): String = MangaDexService.Serde.Adapters.stringListAdapter.toJson(list)

	@TypeConverter
	fun toListString(string: String): List<String> = MangaDexService.Serde.Adapters.stringListAdapter.fromJson(string)!!

	@TypeConverter
	fun toLocalDateTime(time: String): LocalDateTime = LocalDateTime.parse(time)

	@TypeConverter
	fun fromLocalDateTime(time: LocalDateTime): String =
		time.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)

	@TypeConverter
	fun toDexVisibility(v: String) =
		MangaDexService.Serde.Adapters.visibilityAdapter.fromJson(v)!!

	@TypeConverter
	fun fromDexVisibility(v: DexListVisibility): String =
		MangaDexService.Serde.Adapters.visibilityAdapter.toJson(v)

	@TypeConverter
	fun toDexRating(r: String) =
		MangaDexService.Serde.Adapters.ratingAdapter.fromJson(r)!!

	@TypeConverter
	fun fromDexRating(r: DexContentRating): String =
		MangaDexService.Serde.Adapters.ratingAdapter.toJson(r)

	@TypeConverter
	fun toDexMangaTagGroup(g: String): DexMangaTagGroup =
		MangaDexService.Serde.Adapters.mangaTagGroupAdapter.fromJson(g)!!

	@TypeConverter
	fun fromMangaTagGroup(g: DexMangaTagGroup): String =
		MangaDexService.Serde.Adapters.mangaTagGroupAdapter.toJson(g)

	@TypeConverter
	fun toDexLocale(l: String): DexLocale =
		MangaDexService.Serde.Adapters.localeAdapter.fromJson(l)!!

	@TypeConverter
	fun fromDexLocale(l: DexLocale): String =
		MangaDexService.Serde.Adapters.localeAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleList(string: String): List<DexLocale> =
		MangaDexService.Serde.Adapters.localeListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleList(l: List<DexLocale>): String =
		MangaDexService.Serde.Adapters.localeListAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleObject(locale: String): DexLocaleObject =
		MangaDexService.Serde.Adapters.localeObjectAdapter.fromJson(locale)!!

	@TypeConverter
	fun fromDexLocaleObject(locale: DexLocaleObject): String =
		MangaDexService.Serde.Adapters.localeObjectAdapter.toJson(locale)

	@TypeConverter
	fun toDexLocaleObjectList(string: String): List<DexLocaleObject> =
		MangaDexService.Serde.Adapters.localeObjectListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleObjectList(list: List<DexLocaleObject>): String =
		MangaDexService.Serde.Adapters.localeObjectListAdapter.toJson(list)

	@TypeConverter
	fun toDexUserRoleList(string: String): List<DexUserRole> =
		MangaDexService.Serde.Adapters.userRoleListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexUserRoleList(list: List<DexUserRole>): String =
		MangaDexService.Serde.Adapters.userRoleListAdapter.toJson(list)
}
