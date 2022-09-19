package moe.curstantine.riba.api.mangadex

import kotlinx.coroutines.coroutineScope
import kotlinx.coroutines.launch
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.models.DexAuthorData
import moe.curstantine.riba.api.mangadex.models.DexCoverData
import moe.curstantine.riba.api.mangadex.models.DexEntityType
import moe.curstantine.riba.api.mangadex.models.DexMDListData
import moe.curstantine.riba.api.mangadex.models.DexMangaData
import moe.curstantine.riba.api.mangadex.models.DexRelatedAuthor
import moe.curstantine.riba.api.mangadex.models.DexRelatedCover
import moe.curstantine.riba.api.mangadex.models.toMangoAuthor
import moe.curstantine.riba.api.mangadex.models.toMangoCover
import moe.curstantine.riba.api.mangadex.models.toMangoList
import moe.curstantine.riba.api.mangadex.models.toMangoManga
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover

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
                DexEntityType.Artist, DexEntityType.Author -> {
                    authors.add((relationship as DexRelatedAuthor).toMangoAuthor())
                }
                DexEntityType.CoverArt -> {
                    cover = (relationship as DexRelatedCover).toMangoCover(manga.id)
                }
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