package moe.curstantine.riba.api.mangadex.database

import androidx.room.TypeConverter
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.*
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class Converters {
	@TypeConverter
	fun fromListString(list: List<String>): String = MangaDexService.Serde.stringListAdapter.toJson(list)

	@TypeConverter
	fun toListString(string: String): List<String> = MangaDexService.Serde.stringListAdapter.fromJson(string)!!

	@TypeConverter
	fun toLocalDateTime(time: String): LocalDateTime = LocalDateTime.parse(time)

	@TypeConverter
	fun fromLocalDateTime(time: LocalDateTime): String =
		time.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)

	@TypeConverter
	fun toDexVisibility(v: String) =
		MangaDexService.Serde.visibilityAdapter.fromJson(v)!!

	@TypeConverter
	fun fromDexVisibility(v: DexListVisibility): String =
		MangaDexService.Serde.visibilityAdapter.toJson(v)

	@TypeConverter
	fun toDexRating(r: String) =
		MangaDexService.Serde.ratingAdapter.fromJson(r)!!

	@TypeConverter
	fun fromDexRating(r: DexContentRating): String =
		MangaDexService.Serde.ratingAdapter.toJson(r)

	@TypeConverter
	fun toDexMangaTagGroup(g: String): DexMangaTagGroup =
		MangaDexService.Serde.mangaTagGroupAdapter.fromJson(g)!!

	@TypeConverter
	fun fromMangaTagGroup(g: DexMangaTagGroup): String =
		MangaDexService.Serde.mangaTagGroupAdapter.toJson(g)

	@TypeConverter
	fun toDexLocale(l: String): DexLocale =
		MangaDexService.Serde.localeAdapter.fromJson(l)!!

	@TypeConverter
	fun fromDexLocale(l: DexLocale): String =
		MangaDexService.Serde.localeAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleList(string: String): List<DexLocale> =
		MangaDexService.Serde.localeListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleList(l: List<DexLocale>): String =
		MangaDexService.Serde.localeListAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleObject(locale: String): DexLocaleObject =
		MangaDexService.Serde.localeObjectAdapter.fromJson(locale)!!

	@TypeConverter
	fun fromDexLocaleObject(locale: DexLocaleObject): String =
		MangaDexService.Serde.localeObjectAdapter.toJson(locale)

	@TypeConverter
	fun toDexLocaleObjectList(string: String): List<DexLocaleObject> =
		MangaDexService.Serde.localeObjectListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleObjectList(list: List<DexLocaleObject>): String =
		MangaDexService.Serde.localeObjectListAdapter.toJson(list)

	@TypeConverter
	fun toDexUserRoleList(string: String): List<DexUserRole> =
		MangaDexService.Serde.userRoleListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexUserRoleList(list: List<DexUserRole>): String =
		MangaDexService.Serde.userRoleListAdapter.toJson(list)
}
