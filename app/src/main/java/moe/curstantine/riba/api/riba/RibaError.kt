package moe.curstantine.riba.api.riba

interface RibaError {
    val human: String
    val additional: String?

    companion object {
        interface LogTag

        sealed class Impl(
            override val human: String,
            override val additional: String? = null,
        ) : RibaError, Throwable(
            "$human:${additional.orEmpty().let { if (it.isNotEmpty()) "\n$it" else it }}"
        ) {
            object ResultNotError : Impl("Result is not an error.")
            object IsNotThrowable : Impl("Error is not a Throwable.")
        }
    }
}