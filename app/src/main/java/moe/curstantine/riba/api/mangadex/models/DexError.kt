package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class DexErrorResponse(
	val result: DexResult,
	val errors: List<DexErrorAttributes>
)

@JsonClass(generateAdapter = true)
data class DexErrorAttributes(
	val id: String,
	val status: Int,
	val title: String,
	val detail: String?,
)