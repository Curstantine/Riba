package moe.curstantine.mangodex.api.mangodex

interface InternalError {
    val humanString: String
    val additionalInfo: String?
}