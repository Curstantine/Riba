package moe.curstantine.riba.api.riba.models

data class RibaFulfilledChapter(
	val chapter: RibaChapter,
	val groups: List<RibaGroup>,
	val uploader: RibaUser,
) {
	companion object {
		fun getDefault(): RibaFulfilledChapter = RibaFulfilledChapter(
			RibaChapter.getDefault(),
			listOf(RibaGroup.getDefault()),
			RibaUser.getDefault(),
		)
	}
}