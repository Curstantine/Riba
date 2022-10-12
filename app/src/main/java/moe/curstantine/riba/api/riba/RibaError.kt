package moe.curstantine.riba.api.riba

interface RibaError {
    val human: String
    var additional: String?

    companion object {
        interface LogTag

        sealed class Impl(
            override val human: String,
            override var additional: String? = null,
        ) : RibaError {
            object ResultNotError : Impl("Result is not an error.")
        }
    }
}