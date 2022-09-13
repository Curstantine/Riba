package moe.curstantine.mangodex.api.mangadex

import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.mangodex.api.database.RibaDatabase
import moe.curstantine.mangodex.api.mangadex.models.*
import moe.curstantine.mangodex.api.riba.models.RibaAuthor
import moe.curstantine.mangodex.api.riba.models.RibaCover

class DexDatabaseHandler(private val database: RibaDatabase) {

    suspend fun insertAuthor(artist: DexAuthorData) = coroutineScope {
        launch { database.author().insert(artist.toMangoAuthor()) }
    }

    suspend fun insertCover(cover: DexCoverData) = coroutineScope {
        launch { database.cover().insert(cover.toMangoCover()) }
    }

    suspend fun insertManga(manga: DexMangaData) = coroutineScope {
        val authors = mutableListOf<RibaAuthor>()
        var cover: RibaCover? = null

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

}