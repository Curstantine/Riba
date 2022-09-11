package moe.curstantine.mangodex.api.mangadex.models

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class DexErrorResponse(
    val result: DexResult,
    val errors: List<DexError>
)

@JsonClass(generateAdapter = true)
data class DexError(
    val id: String,
    val status: Int,
    val title: String,
    val detail: String,
)