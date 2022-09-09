package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.Json

typealias DexMDList = DexResponse<DexMDListAttributes>

data class DexMDListAttributes(
    val name: String,
    val visibility: DexMDListVisibility,
)

enum class DexMDListVisibility {
    @Json(name = "public")
    Public,
}