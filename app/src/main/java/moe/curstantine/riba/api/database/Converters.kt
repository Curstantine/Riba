package moe.curstantine.riba.api.database

import androidx.room.TypeConverter
import moe.curstantine.riba.api.mangadex.models.DexContentRating
import moe.curstantine.riba.api.mangadex.models.DexListVisibility

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
}
