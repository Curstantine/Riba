package moe.curstantine.riba.api.mangadex.services

import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import moe.curstantine.riba.api.mangadex.DexError
import moe.curstantine.riba.api.riba.RibaResult
import kotlin.coroutines.CoroutineContext

suspend fun <T> contextualInvoke(
    context: CoroutineContext = Dispatchers.IO,
    call: suspend (it: CoroutineScope) -> T,
): RibaResult<T> {
    return withContext(context) {
        try {
            RibaResult.Success(call.invoke(this))
        } catch (e: Throwable) {
            RibaResult.Error(DexError.tryHandle(e))
        }
    }
}