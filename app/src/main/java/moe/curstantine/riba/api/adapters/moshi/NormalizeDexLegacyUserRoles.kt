package moe.curstantine.riba.api.adapters.moshi

import com.squareup.moshi.JsonAdapter
import com.squareup.moshi.JsonReader
import com.squareup.moshi.JsonWriter
import com.squareup.moshi.Moshi
import moe.curstantine.riba.api.mangadex.models.DexUserRole
import java.lang.reflect.Type

class NormalizeDexLegacyUserRoles internal constructor(
	private val delegate: JsonAdapter<DexUserRole>
) : JsonAdapter<DexUserRole>() {
	override fun fromJson(reader: JsonReader): DexUserRole {
		val peeked = reader.peekJson()

		return when (val value = peeked.readJsonValue().toString()) {
			"ROLE_USER" -> DexUserRole.Member
			else -> DexUserRole.fromDexEnum(value)
		}.also {
			peeked.close()
			reader.skipValue()
		}
	}

	override fun toJson(writer: JsonWriter, value: DexUserRole?) {
		delegate.toJson(writer, value)
	}

	companion object {
		fun new() = object : Factory {
			override fun create(
				type: Type,
				annotations: MutableSet<out Annotation>,
				moshi: Moshi
			): JsonAdapter<*>? {
				if (type != DexUserRole::class.java) return null
				val delegate = moshi.nextAdapter<DexUserRole>(this, type, annotations)
				return NormalizeDexLegacyUserRoles(delegate)
			}
		}
	}
}