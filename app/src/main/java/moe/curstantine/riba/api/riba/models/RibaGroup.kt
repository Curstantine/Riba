package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.riba.api.mangadex.models.DexLocale
import java.time.LocalDateTime

@Entity(tableName = "groups")
data class RibaGroup(
    @PrimaryKey val id: String,
    @ColumnInfo val name: String,
    @ColumnInfo val description: String?,
    @ColumnInfo val discord: String?,
    @ColumnInfo val twitter: String?,
    @ColumnInfo val website: String?,
    @ColumnInfo val official: Boolean,
    @ColumnInfo val focusedLanguages: List<DexLocale>,
    @ColumnInfo val createdAt: LocalDateTime,
    @ColumnInfo val version: Int,


    /**
     * UUID of the leader of the group.
     */
    @ColumnInfo val leader: String?,

    /**
     * UUIDs of the users that are part of this group.
     */
    @ColumnInfo val members: List<String>?,
)
