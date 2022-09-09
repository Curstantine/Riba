package moe.curstantine.mangodex.api.mangadex

import moe.curstantine.mangodex.api.mangodex.Error

enum class DexError(
    override val humanString: String,
    override val additionalInfo: String? = null,
) : Error {
    Unknown("Oof, came across an unknown error while trying to reach MangaDex!"),
    HTTP503("MangaDex servers are down for maintenance!", "Status Code: 503");

    companion object {
        fun fromHTTP(code: Int): DexError {
            return when (code) {
                503 -> DexError.HTTP503
                else -> DexError.Unknown
            }
        }
    }
}

