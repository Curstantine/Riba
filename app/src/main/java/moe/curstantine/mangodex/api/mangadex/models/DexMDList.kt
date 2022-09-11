package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass

typealias DexMDList = DexResponse<DexMDListAttributes>

@JsonClass(generateAdapter = true)
data class DexMDListAttributes(
    val name: String,
    val visibility: DexMDListVisibility,
)

enum class DexMDListVisibility {
    @Json(name = "public")
    Public,
}