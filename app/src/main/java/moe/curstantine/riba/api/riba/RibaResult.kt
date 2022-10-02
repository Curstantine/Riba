package moe.curstantine.riba.api.riba

import kotlin.contracts.ExperimentalContracts
import kotlin.contracts.InvocationKind
import kotlin.contracts.contract

sealed class RibaResult<out R> {
    data class Success<out T>(val value: T) : RibaResult<T>()
    data class Error(val error: RibaIntlError) : RibaResult<Nothing>()

    fun unwrap(): R? = when (this) {
        is Success -> value
        is Error -> null
    }

    // function that maps over the value of the result
    inline fun <T> map(f: (R) -> T): RibaResult<T> = when (this) {
        is Success -> Success(f(value))
        is Error -> Error(error)
    }
}

