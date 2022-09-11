package moe.curstantine.mangodex.api

import com.squareup.moshi.*
import moe.curstantine.mangodex.api.mangadex.models.DexLocaleObject
import java.lang.reflect.Type

class NormalizeMismatchType<T> private constructor(
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
        private fun <T> new(requestedType: Class<T>, defaultValue: T): Factory {
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

        val mismatches: List<Factory> = listOf(
            new(
                DexLocaleObject::class.java,
                DexLocaleObject(null, null, null)
            )
        )
    }

}