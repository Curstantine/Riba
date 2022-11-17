package moe.curstantine.riba.api.mangadex

import moe.curstantine.riba.api.riba.RibaLogTag

/**
 * MangaDex implementation of [RibaLogTag] for easy logging.
 */
sealed class DexLogTag(override val tagName: String) : RibaLogTag(tagName) {
	object DEBUG : DexLogTag("DexDebug")
	object MISSING : DexLogTag("DexMissingContent")
	object RESTRICTED : DexLogTag("DexRestrictedContent")
	object REQUEST : DexLogTag("DexRequest")
}

