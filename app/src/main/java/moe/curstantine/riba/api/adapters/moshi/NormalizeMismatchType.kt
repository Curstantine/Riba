package moe.curstantine.riba.api.adapters.moshi

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonDataException
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.Moshi
import java.lang.reflect.Type

class NormalizeMismatchType<T>(
    private val delegate: JsonAdapter<T>,
    private val default: T
) : JsonAdapter<T>() {
    override fun fromJson(reader: JsonReader): T? {
        val peeked = reader.peekJson()

        return try {
            delegate.fromJson(peeked)
        } catch (e: JsonDataException) {
            default
        } finally {
            peeked.close()
            reader.skipValue()
        }
    }


    override fun toJson(writer: JsonWriter, value: T?) {
        delegate.toJson(writer, value)
    }

    companion object {
         fun <T> new(requestedType: Type, defaultValue: T): Factory {
            return object : Factory {
                override fun create(
                    type: Type,
                    annotations: MutableSet<out Annotation>,
                    moshi: Moshi
                ): JsonAdapter<*>? {
                    if (requestedType != type) return null
                    val delegate = moshi.nextAdapter<T>(this, type, annotations)
                    return NormalizeMismatchType(delegate, defaultValue)
                }
            }
        }
    }
}