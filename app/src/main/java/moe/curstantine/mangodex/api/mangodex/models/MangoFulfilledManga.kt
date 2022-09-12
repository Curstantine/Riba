package moe.curstantine.mangodex.api.mangodex.models

/**
 * Fulfilled [MangoManga] with their own fulfilled relationships.
 */
class MangoFulfilledManga(
    val manga: MangoManga,
    val cover: MangoCover?,
    val authors: List<MangoAuthor>?,
    val artists: List<MangoArtist>?,
)