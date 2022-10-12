package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "users")
data class RibaUser(
    @PrimaryKey val id: String,
    @ColumnInfo val username: String,
    @ColumnInfo val avatar: String?,
)
