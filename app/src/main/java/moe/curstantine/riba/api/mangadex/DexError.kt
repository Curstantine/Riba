package moe.curstantine.riba.api.mangadex

import moe.curstantine.riba.api.riba.RibaError

open class DexError(humanString: String, additionalInfo: String?) :
    RibaError(humanString, additionalInfo)

sealed class DexErrorFactory {
    object Unknown : DexError(
        "Oof, came across an unknown error while trying to reach MangaDex!", null
    );

    object HTTP503 : DexError(
        "MangaDex servers are down for maintenance!", "Status Code: 503"
    );

    companion object {
        fun fromStatusCode(code: Int): DexError {
            return when (code) {
                503 -> HTTP503
                else -> Unknown
            }
        }
    }
}