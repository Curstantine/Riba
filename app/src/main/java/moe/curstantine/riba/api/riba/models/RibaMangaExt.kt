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
) {
    companion object {
        fun getDefault(): RibaResultManga = RibaResultManga(
            RibaResult.Success(RibaManga.getDefault()),
            RibaResult.Success(RibaCover.getDefault()),
            RibaResult.Success(listOf(RibaAuthor.getDefault())),
            RibaResult.Success(listOf(RibaAuthor.getDefault())),
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
) {
    companion object {
        fun getDefault(): RibaFulFilledManga = RibaFulFilledManga(
            RibaManga.getDefault(),
            RibaCover.getDefault(),
            listOf(RibaAuthor.getDefault()),
            listOf(RibaAuthor.getDefault()),
        )
    }
}