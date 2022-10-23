package moe.curstantine.riba.api.mangadex.models

import android.util.Log
import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.mangadex.DexLogTag
import moe.curstantine.riba.api.mangadex.DexUtils

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexResult {
    @field:Json(name = "ok")
    Ok,

    @field:Json(name = "error")
    Error
}

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexResponseType {
    @field:Json(name = "entity")
    Entity,

    @field:Json(name = "collection")
    Collection
}

@Suppress("unused")
@JsonClass(generateAdapter = false)
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
    ScanlationGroup,

    /**
     * Member of a group.
     *
     * This is only available in [DexGroup] relationships.
     */
    @field:Json(name = "member")
    Member,

    /**
     * Leader of a group.
     *
     * This is only available in [DexGroup] relationships.
     */
    @field:Json(name = "leader")
    Leader;

    override fun toString(): String = DexUtils.toTitleCase(name)
    fun toDexEnum(): String = DexUtils.toNormalizedString(name)
}

@JsonClass(generateAdapter = false)
enum class DexLocale {
    @field:Json(name = "en")
    English,

    @field:Json(name = "ja")
    Japanese,

    @field:Json(name = "ja-ro")
    JapaneseRomanized,

    @field:Json(name = "zh")
    SimplifiedChinese,

    @field:Json(name = "zh-hk")
    TraditionalChinese,

    @field:Json(name = "zh-ro")
    ChineseRomanized,

    @field:Json(name = "ko")
    Korean,

    @field:Json(name = "ko-ro")
    KoreanRomanized,

    @field:Json(name = "private_not_impl")
    NotImplemented;

    override fun toString(): String = DexUtils.toTitleCase(name)
}

@JsonClass(generateAdapter = false)
enum class DexListVisibility {
    @field:Json(name = "public")
    Public,

    @field:Json(name = "private")
    Private;

    override fun toString(): String = DexUtils.toTitleCase(name)
}

@JsonClass(generateAdapter = false)
enum class DexContentRating {
    @field:Json(name = "safe")
    Safe,

    @field:Json(name = "suggestive")
    Suggestive,

    @field:Json(name = "erotica")
    Erotica,

    @field:Json(name = "pornographic")
    Pornographic;

    override fun toString(): String = DexUtils.toTitleCase(name)
}

typealias DexLocaleObject = Map<DexLocale, String?>

interface DexBaseResponse {
    val result: DexResult
}

@JsonClass(generateAdapter = true)
data class DexBaseResponseImpl(
    override val result: DexResult,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexResponse<T>(
    override val result: DexResult,
    val response: DexResponseType,
    val data: DexResponseData<T>,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexCollectionResponse<T>(
    override val result: DexResult,
    val response: DexResponseType,
    val data: List<DexResponseData<T>>,
    val limit: Int,
    val offset: Int,
    val total: Int,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexResponseData<T>(
    val id: String,
    val type: DexEntityType,
    val attributes: T,
    val relationships: List<DexRelationship>
)