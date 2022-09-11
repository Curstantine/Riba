package moe.curstantine.mangodex.api.database

import androidx.room.TypeConverter
import moe.curstantine.mangodex.api.mangadex.models.DexMDListVisibility

class Converters {
    @TypeConverter
    fun listToString(list: List<String>): String = list.joinToString(",")

    @TypeConverter
    fun stringToList(string: String): List<String> = string.split(",")

    @TypeConverter
    fun dexMDListVisibilityToString(visibility: DexMDListVisibility): String = visibility.toString()

    @TypeConverter
    fun stringToDexMDListVisibility(visibility: String) = when (visibility) {
        "public" -> DexMDListVisibility.Public
        "private" -> DexMDListVisibility.Private
        else -> Exception("Unknown visibility: $visibility")
    }
}
