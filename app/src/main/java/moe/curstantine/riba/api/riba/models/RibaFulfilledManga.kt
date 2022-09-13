package moe.curstantine.riba.api.riba.models

/**
 * Fulfilled [RibaManga] with their own fulfilled relationships.
 */
class RibaFulfilledManga(
    val manga: RibaManga,
    val cover: RibaCover?,
    val authors: List<RibaAuthor>?,
    val artists: List<RibaAuthor>?,
)