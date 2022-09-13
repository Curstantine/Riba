package moe.curstantine.riba.api.riba

import com.squareup.moshi.JsonDataException
import java.sql.SQLException

open class RibaError(
    val humanString: String,
    val additionalInfo: String?
) {
    companion object {
        fun tryHandle(e: Throwable): RibaError {
            return when (e) {
                is JsonDataException -> RibaError("Invalid JSON response", e.message)
                is SQLException -> RibaError("Database error", e.message)
                else -> RibaError("Unknown error", e.message)
            }
        }
    }
}
