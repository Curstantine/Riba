package moe.curstantine.riba.api.adapters.retrofit

import android.util.Log
import com.squareup.moshi.Json
import moe.curstantine.riba.api.mangadex.DexLogTag
import retrofit2.Converter
import retrofit2.Retrofit
import java.lang.reflect.Type


class EnumConverter : Converter.Factory() {
	override fun stringConverter(
		type: Type,
		annotations: Array<Annotation>,
		retrofit: Retrofit
	): Converter<Enum<*>, String>? {
		if (type !is Class<*> || !type.isEnum) return null

		return Converter { enum ->
			try {
				enum.getEnumValue()
			} catch (e: Throwable) {
				Log.e(DexLogTag.MISSING.tagName, "No EnumValue annotation found for $enum", e)
				throw e
			}
		}
	}
}

/**
 * Gets the value of the enum using [Json].
 *
 * @return [Json.name] of this enum.
 *
 * @throws NullPointerException  If the annotation couldn't be found for this enum.
 */
fun Enum<*>.getEnumValue(): String = this.javaClass.getField(this.name).getAnnotation(Json::class.java)?.name
	?: throw NullPointerException("No Json annotation found for $this")
