package moe.curstantine.mangodex.api.mangadex.models

import moe.curstantine.mangodex.api.EnumValue

enum class DexQueryOrderValue {
    @EnumValue("asc")
    Ascending,

    @EnumValue("desc")
    Descending
}

enum class DexQueryOrderProperty(val propertyStr: String) {
    CreatedAt("order[createdAt]")
}