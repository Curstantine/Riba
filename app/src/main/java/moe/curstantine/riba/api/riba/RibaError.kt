package moe.curstantine.riba.api.riba

import moe.curstantine.riba.api.mangadex.DexError
import android.util.Log

/**
 * [Throwable] implementation for general errors bubbled in the app.
 *
 * Use [DexError] if the error is bubbled from anything that has to do with MangaDex.
 *
 * @param message Human-readable error message.
 * @param _additional Additional information about the error.
 * @param cause Original error.
 */
open class RibaError(
	override val message: String,
	protected open var _additional: String? = null,
	override var cause: Throwable? = null,
) : Throwable() {
	override fun getStackTrace(): Array<StackTraceElement> = cause?.stackTrace ?: super.getStackTrace()
	override fun printStackTrace() = cause?.printStackTrace() ?: super.printStackTrace()

	fun getAdditional(): String? = _additional
	fun setAdditional(additional: String?) = apply { this._additional = additional }

	fun setCause(cause: Throwable, followAdditional: Boolean = false) = apply {
		this.cause = cause
		if (followAdditional) _additional = cause.message
	}

	fun log(tag: RibaLogTag = RibaLogTag.DEBUG, priority: Int = Log.DEBUG) {
		val messageContent = "$message ${if (_additional != null) "($_additional)" else ""}".let {
			if (cause != null) "\n$it: $stackTrace" else it
		}

		Log.println(priority, tag.tagName, messageContent)
	}
}