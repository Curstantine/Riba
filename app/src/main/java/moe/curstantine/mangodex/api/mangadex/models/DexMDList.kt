package moe.curstantine.mangodex.api.mangadex.models

typealias DexMDList = DexResponse<DexMDListAttributes>

data class DexMDListAttributes(
    val name: String,
    val visibility: Boolean,
)