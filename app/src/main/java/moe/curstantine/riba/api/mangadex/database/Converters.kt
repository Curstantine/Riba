package moe.curstantine.riba.api.mangadex.database

import androidx.room.TypeConverter
import moe.curstantine.riba.api.mangadex.models.DexContentRating
import moe.curstantine.riba.api.mangadex.models.DexListVisibility
import moe.curstantine.riba.api.mangadex.models.DexMangaTagGroup

class Converters {
    @TypeConverter
    fun listToString(list: List<String>): String = list.joinToString(",")

    @TypeConverter
    fun stringToList(string: String): List<String> = string.split(",")

    @TypeConverter
    fun dexVisibilityToStr(visibility: DexListVisibility): String = visibility.toString()

    @TypeConverter
    fun strToDexVisibility(visibility: String) = DexListVisibility.fromString(visibility)

    @TypeConverter
    fun dexRatingToStr(rating: DexContentRating): String = rating.toString()

    @TypeConverter
    fun strToDexRating(rating: String) = DexContentRating.fromString(rating)

    @TypeConverter
    fun dexTagGroupToString(group: DexMangaTagGroup): String = group.toString()

    @TypeConverter
    fun stringToDexTagGroup(group: String): DexMangaTagGroup = DexMangaTagGroup.fromString(group)
}
