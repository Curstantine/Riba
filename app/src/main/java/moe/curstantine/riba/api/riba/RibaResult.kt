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

    fun bubble(): R = when (this) {
        is Success -> value
        is Error -> {
            if (error is Throwable) throw error
            else throw RibaError.Companion.Impl.ResultNotError
        }
    }

    fun asError(): Error = when (this) {
        is Success -> Error(RibaError.Companion.Impl.ResultNotError)
        is Error -> Error(error)
    }

    // function that maps over the value of the result
    inline fun <T> map(f: (R) -> T): RibaResult<T> = when (this) {
        is Success -> Success(f(value))
        is Error -> Error(error)
    }
}

