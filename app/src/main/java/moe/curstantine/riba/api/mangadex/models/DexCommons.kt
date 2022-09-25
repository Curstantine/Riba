package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

enum class DexResult {
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

enum class DexContentRating {
    @field:Json(name = "safe")
    Safe,

    @field:Json(name = "suggestive")
    Suggestive,

    @field:Json(name = "erotica")
    Erotica,

    @field:Json(name = "pornographic")
    Pornographic;

    override fun toString(): String {
        return when (this) {
            Safe -> "safe"
            Suggestive -> "suggestive"
            Erotica -> "erotica"
            Pornographic -> "pornographic"
        }
    }

    fun toHumanString(): String {
        return when (this) {
            Safe -> "Safe"
            Suggestive -> "Suggestive"
            Erotica -> "Erotica"
            Pornographic -> "Pornographic"
        }
    }

    companion object {
        fun fromString(string: String): DexContentRating {
            return when (string) {
                "safe" -> Safe
                "suggestive" -> Suggestive
                "erotica" -> Erotica
                "pornographic" -> Pornographic
                else -> throw IllegalArgumentException("Unknown content rating: $string")
            }
        }
    }
}

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

    override fun toString(): String {
        return when (this) {
            Author -> "author"
            Artist -> "artist"
            Chapter -> "chapter"
            CustomList -> "custom_list"
            CoverArt -> "cover_art"
            User -> "user"
            Tag -> "tag"
            Manga -> "manga"
            ScanlationGroup -> "scanlation_group"
        }
    }
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

interface DexRelationship {
    val id: String
    val type: DexEntityType
}

@JsonClass(generateAdapter = true)
data class DexRelationshipImpl(
    override val id: String,
    override val type: DexEntityType
) : DexRelationship


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