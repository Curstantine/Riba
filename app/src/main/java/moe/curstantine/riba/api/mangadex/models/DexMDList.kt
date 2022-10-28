package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaMangaList

typealias DexMDList = DexResponse<DexMDListAttributes>
typealias DexMDListData = DexResponseData<DexMDListAttributes>

@JsonClass(generateAdapter = true)
data class DexMDListAttributes(
	val name: String,
	val visibility: DexListVisibility,
	val version: Int,
)

fun DexMDListData.toRibaMangaList() = RibaMangaList(
	id = id,
	name = attributes.name,
	visibility = attributes.visibility,
	titles = relationships.filter { it.type == DexEntityType.Manga }.map { it.id },
	userId = relationships.first { it.type == DexEntityType.User }.id,
	version = attributes.version,
)