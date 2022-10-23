package moe.curstantine.riba.api.mangadex.database.dao

import androidx.room.Dao
import androidx.room.Delete
import androidx.room.Insert
import androidx.room.OnConflictStrategy
import androidx.room.Query
import moe.curstantine.riba.api.riba.models.RibaChapter

@Dao
interface ChapterDao {
    @Query("SELECT * FROM chapters WHERE id = :id")
    suspend fun get(id: String): RibaChapter?

    @Query("SELECT * FROM chapters WHERE id IN (:ids)")
    suspend fun get(ids: List<String>): List<RibaChapter>

    @Query("SELECT * FROM chapters WHERE manga = :mangaId")
    suspend fun getForManga(mangaId: String): List<RibaChapter>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(list: RibaChapter)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insert(lists: List<RibaChapter>)

    @Delete
    suspend fun delete(list: RibaChapter)
}