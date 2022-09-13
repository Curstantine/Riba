package moe.curstantine.riba.api.mangadex.models

import moe.curstantine.riba.api.EnumValue

enum class DexQueryOrderValue {
    @EnumValue("asc")
    Ascending,

    @EnumValue("desc")
    Descending
}

enum class DexQueryOrderProperty(val propStr: String) {
    CreatedAt("order[createdAt]")
}