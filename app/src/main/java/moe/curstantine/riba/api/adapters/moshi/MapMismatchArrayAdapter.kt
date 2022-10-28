package moe.curstantine.riba.api.adapters.moshi

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.Moshi
import com.squareup.moshi.rawType
import java.lang.reflect.Type

/**
 * A [JsonAdapter.Factory] that normalizes php's empty object being represented as an empty array.
 *
 * Uses [NormalizeMismatchType] under the hood.
 */
class MapMismatchArrayAdapter : JsonAdapter.Factory {
	override fun create(
		type: Type,
		annotations: MutableSet<out Annotation>,
		moshi: Moshi
	): JsonAdapter<*>? {
		if (!type.rawType.isAssignableFrom(Map::class.java)) return null
		val delegate = moshi.nextAdapter<Map<*, *>>(this, type, annotations)

		return NormalizeMismatchType(delegate, emptyMap<Nothing, Nothing>())
	}
}