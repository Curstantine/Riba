package moe.curstantine.riba.api.mangadex.database

import androidx.room.TypeConverter
import com.squareup.moshi.adapter
import moe.curstantine.riba.api.mangadex.MangaDexService
import moe.curstantine.riba.api.mangadex.models.DexContentRating
import moe.curstantine.riba.api.mangadex.models.DexListVisibility
import moe.curstantine.riba.api.mangadex.models.DexLocale
import moe.curstantine.riba.api.mangadex.models.DexLocaleObject
import moe.curstantine.riba.api.mangadex.models.DexMangaTagGroup
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class Converters {
	companion object {
		private val stringListAdapter = MangaDexService.dexMoshi.adapter<List<String>>()

		private val dexVisibilityAdapter = MangaDexService.dexMoshi.adapter<DexListVisibility>()
		private val dexRatingAdapter = MangaDexService.dexMoshi.adapter<DexContentRating>()
		private val dexMangaTagGroupAdapter = MangaDexService.dexMoshi.adapter<DexMangaTagGroup>()

		private val dexLocaleAdapter = MangaDexService.dexMoshi.adapter<DexLocale>()
		private val dexLocaleListAdapter = MangaDexService.dexMoshi.adapter<List<DexLocale>>()

		private val dexLocaleObjectAdapter = MangaDexService.dexMoshi.adapter<DexLocaleObject>()
		private val dexLocaleObjectListAdapter =
			MangaDexService.dexMoshi.adapter<List<DexLocaleObject>>()
	}

	@TypeConverter
	fun fromListString(list: List<String>): String = stringListAdapter.toJson(list)

	@TypeConverter
	fun toListString(string: String): List<String> = stringListAdapter.fromJson(string)!!

	@TypeConverter
	fun toLocalDateTime(time: String): LocalDateTime = LocalDateTime.parse(time)

	@TypeConverter
	fun fromLocalDateTime(time: LocalDateTime): String =
		time.format(DateTimeFormatter.ISO_LOCAL_DATE_TIME)

	@TypeConverter
	fun toDexVisibility(v: String) = dexVisibilityAdapter.fromJson(v)!!

	@TypeConverter
	fun fromDexVisibility(v: DexListVisibility): String = dexVisibilityAdapter.toJson(v)

	@TypeConverter
	fun toDexRating(r: String) = dexRatingAdapter.fromJson(r)!!

	@TypeConverter
	fun fromDexRating(r: DexContentRating): String = dexRatingAdapter.toJson(r)

	@TypeConverter
	fun toDexMangaTagGroup(g: String): DexMangaTagGroup = dexMangaTagGroupAdapter.fromJson(g)!!

	@TypeConverter
	fun fromMangaTagGroup(g: DexMangaTagGroup): String = dexMangaTagGroupAdapter.toJson(g)

	@TypeConverter
	fun toDexLocale(l: String): DexLocale = dexLocaleAdapter.fromJson(l)!!

	@TypeConverter
	fun fromDexLocale(l: DexLocale): String = dexLocaleAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleList(string: String): List<DexLocale> = dexLocaleListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleList(l: List<DexLocale>): String = dexLocaleListAdapter.toJson(l)

	@TypeConverter
	fun toDexLocaleObject(locale: String): DexLocaleObject =
		dexLocaleObjectAdapter.fromJson(locale)!!

	@TypeConverter
	fun fromDexLocaleObject(locale: DexLocaleObject): String = dexLocaleObjectAdapter.toJson(locale)

	@TypeConverter
	fun toDexLocaleObjectList(string: String): List<DexLocaleObject> =
		dexLocaleObjectListAdapter.fromJson(string)!!

	@TypeConverter
	fun fromDexLocaleObjectList(list: List<DexLocaleObject>): String =
		dexLocaleObjectListAdapter.toJson(list)
}
