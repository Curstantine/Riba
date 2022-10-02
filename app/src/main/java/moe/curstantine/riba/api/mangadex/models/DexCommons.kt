package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.mangadex.DexUtils

@Suppress("unused")
enum class DexResult {
    @field:Json(name = "ok")
    Ok,

    @field:Json(name = "error")
    Error
}

@Suppress("unused")
enum class DexResponseType {
    @field:Json(name = "entity")
    Entity,

    @field:Json(name = "collection")
    Collection
}

@Suppress("unused")
enum class DexEntityType {
    @field:Json(name = "author")
    Author,

    @field:Json(name = "artist")
    Artist,

    @field:Json(name = "chapter")
    Chapter,

    @field:Json(name = "custom_list")
    CustomList,

    @field:Json(name = "cover_art")
    CoverArt,

    @field:Json(name = "user")
    User,

    @field:Json(name = "tag")
    Tag,

    @field:Json(name = "manga")
    Manga,

    @field:Json(name = "scanlation_group")
    ScanlationGroup;

    override fun toString(): String = DexUtils.toNormalizedString(name)
    fun toTitleCase(): String = DexUtils.toTitleCase(name)
}

@JsonClass(generateAdapter = true)
data class DexLocaleObject(
    @field:Json(name = "en")
    val english: String?,

    @field:Json(name = "ja")
    val japanese: String?,

    @field:Json(name = "ja-ro")
    val japaneseRomanized: String?,
)


@JsonClass(generateAdapter = true)
data class DexResponse<T>(
    val result: DexResult,
    val response: DexResponseType,
    val data: DexResponseData<T>,
)

@JsonClass(generateAdapter = true)
data class DexCollectionResponse<T>(
    val result: DexResult,
    val response: DexResponseType,
    val data: List<DexResponseData<T>>,
    val limit: Int,
    val offset: Int,
    val total: Int,
)

@JsonClass(generateAdapter = true)
data class DexResponseData<T>(
    val id: String,
    val type: DexEntityType,
    val attributes: T,
    val relationships: List<DexRelationship>
)