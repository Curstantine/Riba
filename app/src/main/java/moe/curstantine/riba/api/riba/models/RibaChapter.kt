package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexLocale
import java.time.LocalDateTime

/**
 * Generalized Chapter object that's used by the app,
 * external APIs should transform to this data class.
 */
@Entity(tableName = "chapters")
data class RibaChapter(
    @PrimaryKey val id: String,

    /**
     * ID of the manga this chapter is related to.
     */
    @ColumnInfo val manga: String,

    /**
     * UUIDs of the scanlators of this chapter.
     */
    @ColumnInfo val groups: List<String>,

    /**
     * UUID of the user that uploaded this chapter.
     */
    @ColumnInfo val uploader: String,

    /**
     * Volume can contain alphanumeric characters.
     *
     * For an example, all of these are valid volume numbers:
     * - 1
     * - 1a
     * - 1.5a
     */
    @ColumnInfo val volume: String?,

    /**
     * Chapters can contain alphanumeric characters.
     */
    @ColumnInfo val chapter: String?,

    /**
     * Title of this chapter, usually in the language of the manga.
     */
    @ColumnInfo val title: String?,

    /**
     * Language used in this chapter.
     */
    @ColumnInfo val language: DexLocale,

    /**
     * Full URL to the chapter if it's hosted on a third-party website.
     */
    @ColumnInfo val externalUrl: String?,

    /**
     * The date this chapter will be published on.
     *
     * This can be used to find when the chapter will be available when the content is restricted
     * to the uploader site.
     */
    @ColumnInfo val publishAt: LocalDateTime,

    /**
     * The timestamp this chapter will be readable even when only [externalUrl] is available.
     *
     * Useful for finding chapters that are locked till a certain date.
     *
     * - If [publishAt] is in future and has [externalUrl], then [readableAt] is equal to the [createdAt] date
     * - Otherwise readableAt is equals publishAt date
     */
    @ColumnInfo val readableAt: LocalDateTime,

    /**
     * The timestamp this chapter was created.
     */
    @ColumnInfo val createdAt: LocalDateTime,

    /**
     * The timestamp this chapter was created.
     */
    @ColumnInfo val updatedAt: LocalDateTime,
    @ColumnInfo val version: Int,
) {
    companion object {
        fun getDefault() = RibaChapter(
            id = "d3b3a942-6cf4-4fa4-a9f4-627d8b361f8f",
            manga = "9c33607-9180-4ba6-b85c-e4b5faee7192",
            groups = listOf("9c33607-9180-4ba6-b85c-e4b5faee7192"),
            uploader = "9c33607-9180-4ba6-b85c-e4b5faee7192",
            volume = "1",
            chapter = "2.4a",
            title = "Chapter 2",
            language = DexLocale.English,
            externalUrl = null,
            publishAt = LocalDateTime.now(),
            readableAt = LocalDateTime.now(),
            createdAt = LocalDateTime.now(),
            updatedAt = LocalDateTime.now(),
            version = 0
        )
    }
}

