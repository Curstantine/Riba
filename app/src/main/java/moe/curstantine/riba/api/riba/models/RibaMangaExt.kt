package moe.curstantine.riba.api.riba.models

/**
 * [RibaManga] with relationships wrapped in [Result]
 */
class RibaResultManga(
	val manga: Result<RibaManga>,
	val cover: Result<RibaCover?>?,
	val authors: Result<List<RibaAuthor>>?,
	val artists: Result<List<RibaAuthor>>?,
	val tags: Result<List<RibaTag>>?,
	val statistic: Result<RibaStatistic>?,
	val chapters: Result<List<RibaFulfilledChapter>>?,
	val isFollowing: Result<Boolean>?,
) {
	companion object {
		/**
		 * Usage is discouraged, use this only when you need to eagerly pass an error
		 */
		fun fromNullables(
			manga: Result<RibaManga>,
			cover: Result<RibaCover?>? = null,
			authors: Result<List<RibaAuthor>>? = null,
			artists: Result<List<RibaAuthor>>? = null,
			tags: Result<List<RibaTag>>? = null,
			statistic: Result<RibaStatistic>? = null,
			chapters: Result<List<RibaFulfilledChapter>>? = null,
			isFollowing: Result<Boolean>? = null,
		): RibaResultManga {
			return RibaResultManga(
				manga,
				cover,
				authors,
				artists,
				tags,
				statistic,
				chapters,
				isFollowing
			)
		}

		fun getDefault(): RibaResultManga = RibaResultManga(
			Result.success(RibaManga.getDefault()),
			Result.success(RibaCover.getDefault()),
			Result.success(listOf(RibaAuthor.getDefault())),
			Result.success(listOf(RibaAuthor.getDefault(), RibaAuthor.getDefault(), RibaAuthor.getDefault())),
			Result.success(listOf(RibaTag.getDefault(), RibaTag.getDefault())),
			Result.success(RibaStatistic.getDefault()),
			Result.success(
				listOf(
					RibaFulfilledChapter.getDefault(),
					RibaFulfilledChapter.getDefault(),
					RibaFulfilledChapter.getDefault(),
					RibaFulfilledChapter.getDefault()
				)
			),
			Result.success(true)
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
	val chapters: List<RibaChapter>?,
) {
	companion object {
		fun fromNullables(
			manga: RibaManga,
			cover: RibaCover? = null,
			authors: List<RibaAuthor>? = null,
			artists: List<RibaAuthor>? = null,
			tags: List<RibaTag>? = null,
			statistic: RibaStatistic? = null,
			chapters: List<RibaChapter>? = null,
		): RibaFulFilledManga {
			return RibaFulFilledManga(
				manga,
				cover,
				authors,
				artists,
				tags,
				statistic,
				chapters,
			)
		}

		fun getDefault(): RibaFulFilledManga = RibaFulFilledManga(
			RibaManga.getDefault(),
			RibaCover.getDefault(),
			listOf(RibaAuthor.getDefault()),
			listOf(RibaAuthor.getDefault()),
			listOf(RibaTag.getDefault(), RibaTag.getDefault()),
			RibaStatistic.getDefault(),
			listOf(RibaChapter.getDefault(), RibaChapter.getDefault()),
		)
	}
}