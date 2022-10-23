package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaTag

typealias DexTag = DexResponse<DexTagAttributes>
typealias DexTagCollection = DexCollectionResponse<DexTagAttributes>

typealias DexTagData = DexResponseData<DexTagAttributes>

@JsonClass(generateAdapter = true)
data class DexTagAttributes(
    val name: DexLocaleObject,
    val group: DexMangaTagGroup,
    val version: Int,
)

fun DexTagData.toRibaTag() = RibaTag(
    id = id,
    name = attributes.name,
    group = attributes.group,
    version = attributes.version,
)