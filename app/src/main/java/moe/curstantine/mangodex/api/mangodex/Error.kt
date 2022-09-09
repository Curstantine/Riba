package moe.curstantine.mangodex.api.mangodex

interface Error {
    val humanString: String
    val additionalInfo: String?
}