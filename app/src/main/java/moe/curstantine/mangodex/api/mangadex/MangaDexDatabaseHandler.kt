package moe.curstantine.mangodex.api.mangadex

import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.mangodex.api.database.MangoDatabase
import moe.curstantine.mangodex.api.mangadex.models.*
import moe.curstantine.mangodex.api.mangodex.models.MangoAuthor
import moe.curstantine.mangodex.api.mangodex.models.MangoCover

class MangaDexDatabaseHandler(private val database: MangoDatabase) {

    suspend fun insertManga(manga: DexMangaData) = coroutineScope {
        val authors = mutableListOf<MangoAuthor>()
        var cover: MangoCover? = null

        for (relationship in manga.relationships) {
            when (relationship.type) {
                DexEntityType.Artist,
                DexEntityType.Author -> authors.add((relationship as DexRelatedAuthor).toMangoAuthor())
                DexEntityType.CoverArt -> cover = (relationship as DexRelatedCover).toMangoCover()
                else -> {}
            }
        }

        launch { database.manga().insert(manga.toMangoManga()) }
        launch { database.author().insert(authors) }
        cover?.let { launch { database.cover().insert(cover) } }
    }

    suspend fun insertMDList(list: DexMDListData) = coroutineScope {
        launch { database.list().insert(list.toMangoList()) }
    }

    suspend fun insertCover(cover: DexCoverData) = coroutineScope {
        launch { database.cover().insert(cover.toMangoCover()) }
    }

}