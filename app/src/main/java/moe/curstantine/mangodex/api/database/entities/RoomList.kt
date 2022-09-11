package moe.curstantine.mangodex.api.database.entities

import androidx.room.Entity
import androidx.room.PrimaryKey
import moe.curstantine.mangodex.api.mangadex.models.DexEntityType
import moe.curstantine.mangodex.api.mangadex.models.DexMDListData
import moe.curstantine.mangodex.api.mangadex.models.DexMDListVisibility

@Entity(tableName = "md_lists")
data class RoomList(
    @PrimaryKey val id: String,
    val name: String,
    val visibility: DexMDListVisibility,
    val titles: List<String>,
)

fun RoomList.fromDexMDList(list: DexMDListData) = RoomList(
    id = list.id,
    name = list.attributes.name,
    visibility = list.attributes.visibility,
    titles = list.relationships.filter { it.type == DexEntityType.Manga }.map { it.id },
)
