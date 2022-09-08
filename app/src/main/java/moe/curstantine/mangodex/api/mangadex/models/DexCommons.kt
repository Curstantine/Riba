package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.Json

enum class DexStatus {
    @field:Json(name = "ok")
    Ok,

    @field:Json(name = "error")
    Error
}

enum class DexResponseType {
    @field:Json(name = "entity")
    Entity,

    @field:Json(name = "collection")
    Collection
}

enum class DexEntityType {
    @field:Json(name = "manga")
    Manga,

    @field:Json(name = "custom_list")
    CustomList,

    @field:Json(name = "user")
    User,

    @field:Json(name = "author")
    Author,

    @field:Json(name = "artist")
    Artist,

    @field:Json(name = "cover_art")
    CoverArt,
}

data class DexLocaleObject(
    @field:Json(name = "en")
    val english: String,
)

data class DexRelationship(
    val id: String,
    val type: DexEntityType,
)

data class DexResponse<T>(
    val status: DexStatus,
    val response: DexResponseType,
    val data: DexResponseData<T>,
)

data class DexCollectionResponse<T>(
    val status: DexStatus,
    val response: DexResponseType,
    val data: List<DexResponseData<T>>,
    val limit: Int,
    val offset: Int,
    val total: Int,
)

data class DexResponseData<T>(
    val id: String,
    val type: DexEntityType,
    val attributes: T,
    val relationships: List<DexRelationship>
)