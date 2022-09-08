package moe.curstantine.mangodex.api.mangadex.models

typealias DexManga = DexResponse<DexResponseData<DexMangaAttributes>>

data class DexMangaAttributes(
    val title: DexLocaleObject,
    val altTitles: List<DexLocaleObject>,
    val description: DexLocaleObject,
)