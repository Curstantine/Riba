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
import moe.curstantine.riba.api.mangadex.models.DexTagData
import moe.curstantine.riba.api.mangadex.models.toRibaAuthor
import moe.curstantine.riba.api.mangadex.models.toRibaCover
import moe.curstantine.riba.api.mangadex.models.toRibaManga
import moe.curstantine.riba.api.mangadex.models.toRibaMangaList
import moe.curstantine.riba.api.mangadex.models.toRibaTag
import moe.curstantine.riba.api.riba.models.RibaAuthor
import moe.curstantine.riba.api.riba.models.RibaCover
import moe.curstantine.riba.api.riba.models.RibaTag

class DexDatabaseHandler(private val database: RibaDatabase) {

    /**
     * Inserts a [RibaAuthor] into the database.
     *
     * Guards against inserting a author/artist with the same version as in the database,
     * this guard will take place regardless whether the already existing author/artists
     * has higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertAuthor] with [DexAuthorData] signature.
     */
    private suspend fun insertAuthor(author: RibaAuthor, force: Boolean = false) = coroutineScope {
        val oldAuthor = database.author().get(author.id)

        // We don't want to insert authors with the same version.
        if (force.not() && oldAuthor != null && oldAuthor.version >= author.version) {
            return@coroutineScope
        }

        launch { database.author().insert(author) }
    }

    /**
     * Inserts a [DexAuthorData] into the database.
     *
     * Guards against inserting a author/artist with the same version as in the database,
     * this guard will take place regardless whether the already existing author/artists
     * has higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertAuthor] with [RibaAuthor] signature.
     */
    suspend fun insertAuthor(author: DexAuthorData, force: Boolean = false) =
        insertAuthor(author.toRibaAuthor(), force)

    /**
     * Inserts a [RibaCover] into the database.
     *
     * Guards against inserting a cover with the same version as in the database,
     * this guard will take place regardless whether the already existing cover has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertCover] with [DexCoverData] signature.
     */
    private suspend fun insertCover(cover: RibaCover, force: Boolean = false) = coroutineScope {
        val oldCover = database.cover().get(cover.id)

        // We don't want to insert covers with the same version.
        if (force.not() && oldCover != null && oldCover.version >= cover.version) {
            return@coroutineScope
        }

        launch { database.cover().insert(cover) }
    }

    /**
     * Inserts a [DexCoverData] into the database.
     *
     * Guards against inserting a cover with the same version as in the database,
     * this guard will take place regardless whether the already existing cover has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertCover] with [RibaCover] signature.
     */
    suspend fun insertCover(cover: DexCoverData, force: Boolean = false) =
        insertCover(cover.toRibaCover(), force)

    /**
     * Inserts a [RibaTag] into the database.
     *
     * Guards against inserting a tag with the same version as in the database,
     * this guard will take place regardless whether the already existing tag has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertTag] with [DexTagData] signature.
     */
    private suspend fun insertTag(tag: RibaTag, force: Boolean = false) = coroutineScope {
        val oldTag = database.tag().get(tag.id)

        // We don't want to insert tags with the same version.
        if (force.not() && oldTag != null && oldTag.version >= tag.version) {
            return@coroutineScope
        }

        launch { database.tag().insert(tag) }
    }

    /**
     * Inserts a [DexTagData] into the database.
     *
     * Guards against inserting a tag with the same version as in the database,
     * this guard will take place regardless whether the already existing tag has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     *
     * @see [insertTag] with [RibaTag] signature.
     */
    suspend fun insertTag(tag: DexTagData, force: Boolean = false) =
        insertTag(tag.toRibaTag(), force)


    /**
     * Inserts a [DexMangaData] into the database with its [RibaAuthor], [RibaCover] and etc.
     *
     * Guards against inserting a manga with the same version as in the database,
     * this guard will take place regardless whether the already existing manga has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     */
    suspend fun insertManga(manga: DexMangaData, force: Boolean = false) = coroutineScope {
        val oldManga = database.manga().get(manga.id)

        // We don't want to insert titles with the same version.
        if (force.not() && oldManga != null && oldManga.version >= manga.attributes.version) {
            return@coroutineScope
        }

        launch { database.manga().insert(manga.toRibaManga()) }
        launch {
            var cover: RibaCover? = null
            val authors = mutableListOf<RibaAuthor>()

            for (relationship in manga.relationships) {
                when (relationship.type) {
                    DexEntityType.Artist, DexEntityType.Author -> {
                        authors.add((relationship as DexRelatedAuthor).toRibaAuthor())
                    }
                    DexEntityType.CoverArt -> {
                        cover = (relationship as DexRelatedCover).toRibaCover(manga.id)
                    }
                    else -> {}
                }
            }

            cover?.let { insertCover(it) }
            authors.forEach { insertAuthor(it) }
            manga.attributes.tags.forEach { insertTag(it) }
        }
    }

    /**
     * Inserts a [DexMDListData] into the database.
     *
     * Guards against inserting an MDList with the same version as in the database,
     * this guard will take place regardless whether the already existing MDList has
     * higher null values or not.
     *
     * Use [force] to force remove the guard.
     */
    suspend fun insertMDList(list: DexMDListData, force: Boolean = false) = coroutineScope {
        val oldList = database.list().get(list.id)

        // We don't want to insert authors with the same version.
        if (force.not() && oldList != null && oldList.version >= list.attributes.version) {
            return@coroutineScope
        }

        launch { database.list().insert(list.toRibaMangaList()) }
    }
}
