package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangodex.InternalError

enum class DexInternalError(
    override val humanString: String,
    override val additionalInfo: String? = null,
) : InternalError {
    Unknown("Oof, came across an unknown error while trying to reach MangaDex!"),
    HTTP503("MangaDex servers are down for maintenance!", "Status Code: 503");

    companion object {
        fun fromHTTP(code: Int): DexInternalError {
            return when (code) {
                503 -> DexInternalError.HTTP503
                else -> DexInternalError.Unknown
            }
        }
    }
}

