package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaMangaList

typealias DexMDList = DexResponse<DexMDListAttributes>
typealias DexMDListData = DexResponseData<DexMDListAttributes>

@JsonClass(generateAdapter = true)
data class DexMDListAttributes(
    val name: String,
    val visibility: DexMDListVisibility,
)

enum class DexMDListVisibility {
    @Json(name = "public")
    Public,

    @Json(name = "private")
    Private;

    override fun toString(): String {
        return when (this) {
            Public -> "public"
            Private -> "private"
        }
    }
}

fun DexMDListData.toMangoList() = RibaMangaList(
    id = id,
    name = attributes.name,
    visibility = attributes.visibility,
    titles = relationships.filter { it.type == DexEntityType.Manga }.map { it.id },
)