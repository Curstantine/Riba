package moe.curstantine.riba.api.riba.models

import moe.curstantine.riba.api.riba.RibaResult

/**
 * [RibaManga] with relationships wrapped in [RibaResult]
 */
class RibaResultManga(
    val manga: RibaResult<RibaManga>,
    val cover: RibaResult<RibaCover?>?,
    val authors: RibaResult<List<RibaAuthor>>?,
    val artists: RibaResult<List<RibaAuthor>>?,
    val tags: RibaResult<List<RibaTag>>?,
    val statistic: RibaResult<RibaStatistic>?,
) {
    companion object {
        /**
         * Usage is discouraged, use this only when you need to eagerly pass an error
         */
        fun fromNullables(
            manga: RibaResult<RibaManga>,
            cover: RibaResult<RibaCover?>? = null,
            authors: RibaResult<List<RibaAuthor>>? = null,
            artists: RibaResult<List<RibaAuthor>>? = null,
            tags: RibaResult<List<RibaTag>>? = null,
            statistic: RibaResult<RibaStatistic>? = null,
        ): RibaResultManga {
            return RibaResultManga(
                manga,
                cover,
                authors,
                artists,
                tags,
                statistic,
            )
        }

        fun getDefault(): RibaResultManga = RibaResultManga(
            RibaResult.Success(RibaManga.getDefault()),
            RibaResult.Success(RibaCover.getDefault()),
            RibaResult.Success(listOf(RibaAuthor.getDefault())),
            RibaResult.Success(listOf(RibaAuthor.getDefault())),
            RibaResult.Success(listOf(RibaTag.getDefault(), RibaTag.getDefault())),
            RibaResult.Success(RibaStatistic.getDefault()),
        )
    }
}

/**
 * [RibaManga] with fulfilled nullable relationships.
 */
class RibaFulFilledManga(
    val manga: RibaManga,
    val cover: RibaCover?,
    val authors: List<RibaAuthor>?,
    val artists: List<RibaAuthor>?,
    val tags: List<RibaTag>?,
    val statistic: RibaStatistic?,
) {
    companion object {
        fun getDefault(): RibaFulFilledManga = RibaFulFilledManga(
            RibaManga.getDefault(),
            RibaCover.getDefault(),
            listOf(RibaAuthor.getDefault()),
            listOf(RibaAuthor.getDefault()),
            listOf(RibaTag.getDefault()),
            RibaStatistic.getDefault(),
        )
    }
}