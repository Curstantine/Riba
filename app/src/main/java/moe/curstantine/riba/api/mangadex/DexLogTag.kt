package moe.curstantine.riba.api.mangadex

import moe.curstantine.riba.api.riba.RibaError

/**
 * Logger tags used to quickly locate the source of error from logcat.
 */
enum class DexLogTag(override val tag: String) : RibaError.Companion.LogTag {
    MISSING("DexMissingContent"),
    RESTRICTED("DexRestrictedContent"),
    DEBUG("DexDebug"),
    REQUEST("DexRequest");

    override fun toString(): String = tag
}

