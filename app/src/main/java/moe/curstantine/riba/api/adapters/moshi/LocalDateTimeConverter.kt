package moe.curstantine.riba.api.adapters.moshi

import com.squareup.moshi.FromJson
import com.squareup.moshi.ToJson
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

class LocalDateTimeConverter {
    @FromJson
    fun fromJson(json: String): LocalDateTime = LocalDateTime.parse(json)

    @ToJson
    fun toJson(value: LocalDateTime): String = value.format(DateTimeFormatter.ISO_DATE_TIME)
}