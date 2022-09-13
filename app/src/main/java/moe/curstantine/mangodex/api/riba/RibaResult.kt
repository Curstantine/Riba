package moe.curstantine.mangodex.api.riba

sealed class RibaResult<out R> {
    data class Success<out T>(val data: T) : RibaResult<T>()
    data class Error(val error: RibaError) : RibaResult<Nothing>()

    fun unwrap(): R? = when (this) {
        is Success -> data
        is Error -> null
    }
}