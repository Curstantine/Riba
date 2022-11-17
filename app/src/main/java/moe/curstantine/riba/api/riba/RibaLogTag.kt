package moe.curstantine.riba.api.riba

import moe.curstantine.riba.api.mangadex.DexLogTag

/**
 * Inheritable logger class for easy logging.
 *
 * See [DexLogTag] for the MangaDex implementation.
 */
open class RibaLogTag(open val tagName: String) {
	object DEBUG : RibaLogTag("RibaDebug")
}