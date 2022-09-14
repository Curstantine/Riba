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
)

/**
 * [RibaManga] with fulfilled nullable relationships.
 */
class RibaFulFilledManga(
    val manga: RibaManga,
    val cover: RibaCover?,
    val authors: List<RibaAuthor>?,
    val artists: List<RibaAuthor>?,
)