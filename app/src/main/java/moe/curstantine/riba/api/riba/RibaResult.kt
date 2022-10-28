package moe.curstantine.riba.api.riba

sealed class RibaResult<out R> {
	data class Success<out T>(val value: T) : RibaResult<T>()
	data class Error(val error: RibaError) : RibaResult<Nothing>()

	/**
	 * Tries to unwrap the result while throwing an error if this result is an error.
	 * @throws RibaError if the result is an error.
	 */
	fun unwrap(): R = when (this) {
		is Success -> value
		is Error -> {
			if (error is Throwable) throw error
			else throw RibaError.Companion.Impl.IsNotThrowable
		}
	}

	fun unwrapOrNull(): R? = when (this) {
		is Success -> value
		is Error -> null
	}

	/**
	 * @throws [RibaError.Companion.Impl.ResultNotError] if the result is not an error.
	 */
	fun unwrapError(): RibaError = when (this) {
		is Success -> throw RibaError.Companion.Impl.ResultNotError
		is Error -> error
	}

	fun unwrapErrorOrNull(): RibaError? = when (this) {
		is Success -> null
		is Error -> error
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

