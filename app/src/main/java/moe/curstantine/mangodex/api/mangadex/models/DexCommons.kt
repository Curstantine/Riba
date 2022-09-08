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

}

data class DexLocaleObject(
    @field:Json(name = "en")
    val english: String,
)

data class DexResponse<T>(
    val status: DexStatus,
    val response: DexResponseType,
    val data: T
)

data class DexResponseData<Attributes>(
    val id: String,
    val type: DexEntityType,
    val attributes: Attributes,
)