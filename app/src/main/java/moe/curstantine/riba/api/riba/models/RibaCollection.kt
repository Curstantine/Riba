package moe.curstantine.riba.api.riba.models

/**
 * Collection that matches with MangaDex's collection responses to provide,
 * [total], [limit] and [offset] while wrapping with a generic [data] field.
 *
 * @property total Total number items available in the server (not the [List.size] of this collection)
 *
 * @property limit Limit per response provided to the server.
 *
 * @property offset Offset of the response provided to the server.
 */
data class RibaCollection<T>(
    val total: Int,
    val limit: Int,
    val offset: Int,
    val data: T
)
