package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangodex.InternalError

class DexInternalError(
    override val humanString: String,
    override val additionalInfo: String? = null,
) : InternalError

enum class DexErrorFactory(val error: DexInternalError) {
    Unknown(DexInternalError("Oof, came across an unknown error while trying to reach MangaDex!")),
    HTTP503(DexInternalError("MangaDex servers are down for maintenance!", "Status Code: 503"));

    companion object {
        fun fromStatusCode(code: Int): DexInternalError {
            return when (code) {
                503 -> HTTP503.error
                else -> Unknown.error
            }
        }
    }
}