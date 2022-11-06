package moe.curstantine.riba.api.mangadex

import com.squareup.moshi.Moshi
import com.squareup.moshi.adapter
import com.squareup.moshi.adapters.PolymorphicJsonAdapterFactory
import moe.curstantine.riba.api.adapters.moshi.LocalDateTimeConverter
import moe.curstantine.riba.api.adapters.moshi.MapMismatchArrayAdapter
import moe.curstantine.riba.api.adapters.moshi.NormalizeDexLegacyUserRoles
import moe.curstantine.riba.api.adapters.moshi.NormalizeMismatchType
import moe.curstantine.riba.api.mangadex.models.*

class DexSerde {
	val moshi: Moshi = Moshi.Builder()
		.add(LocalDateTimeConverter())
		.add(MapMismatchArrayAdapter())
		.add(NormalizeDexLegacyUserRoles.create())
		.add(NormalizeMismatchType.new(DexLocale::class.java, DexLocale.NotImplemented))
		.add(
			PolymorphicJsonAdapterFactory.of(DexRelationship::class.java, "type")
				.withSubtype(DexRelatedManga::class.java, DexEntityType.Manga.toDexEnum())
				.withSubtype(DexRelatedCover::class.java, DexEntityType.CoverArt.toDexEnum())
				.withSubtype(DexRelatedAuthor::class.java, DexEntityType.Author.toDexEnum())
				.withSubtype(DexRelatedAuthor::class.java, DexEntityType.Artist.toDexEnum())
				.withSubtype(DexRelatedUser::class.java, DexEntityType.User.toDexEnum())
				.withSubtype(DexRelatedUser::class.java, DexEntityType.Leader.toDexEnum())
				.withSubtype(DexRelatedUser::class.java, DexEntityType.Member.toDexEnum())
				.withSubtype(DexRelatedGroup::class.java, DexEntityType.ScanlationGroup.toDexEnum())
				.withSubtype(DexRelationshipImpl::class.java, DexEntityType.Chapter.toDexEnum())
				.withSubtype(DexRelationshipImpl::class.java, DexEntityType.Tag.toDexEnum())
				.withSubtype(DexRelationshipImpl::class.java, DexEntityType.CustomList.toDexEnum())
		)
		.build()

	val stringListAdapter = moshi.adapter<List<String>>()
	val visibilityAdapter = moshi.adapter<DexListVisibility>()
	val ratingAdapter = moshi.adapter<DexContentRating>()
	val mangaTagGroupAdapter = moshi.adapter<DexMangaTagGroup>()
	val localeAdapter = moshi.adapter<DexLocale>()
	val localeListAdapter = moshi.adapter<List<DexLocale>>()
	val localeObjectAdapter = moshi.adapter<DexLocaleObject>()
	val localeObjectListAdapter = moshi.adapter<List<DexLocaleObject>>()
	val userRoleListAdapter = moshi.adapter<List<DexUserRole>>()
	val errorResponseAdapter = moshi.adapter<DexErrorResponse>()
}
