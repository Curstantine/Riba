package moe.curstantine.mangodex.api.mangodex

sealed class Result<out R> {
    data class Success<out T>(val data: T) : Result<T>()
    data class Error(val error: InternalError) : Result<Nothing>()
}