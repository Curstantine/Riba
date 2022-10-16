package moe.curstantine.riba.api.riba

sealed class RibaResult<out R> {
    data class Success<out T>(val value: T) : RibaResult<T>()
    data class Error(val error: RibaError) : RibaResult<Nothing>()

    fun unwrap(): R? = when (this) {
        is Success -> value
        is Error -> null
    }

    fun unwrapError(): RibaError? = when (this) {
        is Success -> null
        is Error -> error
    }

    /**
     * Bubbles the error up if there is one.
     */
    fun bubble(): R = when (this) {
        is Success -> value
        is Error -> {
            if (error is Throwable) throw error
            else throw RibaError.Companion.Impl.IsNotThrowable
        }
    }

    fun asError(): Error = when (this) {
        is Success -> Error(RibaError.Companion.Impl.ResultNotError)
        is Error -> Error(error)
    }

    /**
     * Returns the result of [transform] function applied to the value of [Success] or the
     * [RibaError] if this result is [Error].
     *
     * Similar to Rust's [Result::map](https://doc.rust-lang.org/std/result/enum.Result.html#method.map)
     */
    inline fun <T> map(transform: (R) -> T): RibaResult<T> = when (this) {
        is Success -> Success(transform(value))
        is Error -> Error(error)
    }
}

