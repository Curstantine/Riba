package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.R
import moe.curstantine.riba.api.adapters.retrofit.EnumValue
import moe.curstantine.riba.api.mangadex.DexUtils

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexResult {
	@field:Json(name = "ok")
	Ok,

	@field:Json(name = "ko")
	Ko,

	@field:Json(name = "error")
	Error;

	override fun toString() = DexUtils.toNormalizedString(name)
}

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexResponseType {
	@field:Json(name = "entity")
	Entity,

	@field:Json(name = "collection")
	Collection
}

@Suppress("unused")
@JsonClass(generateAdapter = false)
enum class DexEntityType {
	@field:Json(name = "author")
	Author,

	@field:Json(name = "artist")
	Artist,

	@field:Json(name = "chapter")
	Chapter,

	@field:Json(name = "custom_list")
	CustomList,

	@field:Json(name = "cover_art")
	CoverArt,

	@field:Json(name = "user")
	User,

	@field:Json(name = "tag")
	Tag,

	@field:Json(name = "manga")
	Manga,

	@field:Json(name = "scanlation_group")
	ScanlationGroup,

	/**
	 * Member of a group.
	 *
	 * This is only available in [DexGroup] relationships.
	 */
	@field:Json(name = "member")
	Member,

	/**
	 * Leader of a group.
	 *
	 * This is only available in [DexGroup] relationships.
	 */
	@field:Json(name = "leader")
	Leader;

	override fun toString(): String = DexUtils.toTitleCase(name)
	fun toDexEnum(): String = DexUtils.toNormalizedString(name)
}

@JsonClass(generateAdapter = false)
enum class DexLocale {
	@EnumValue("en")
	@field:Json(name = "en")
	English,

	@EnumValue("ja")
	@field:Json(name = "ja")
	Japanese,

	@EnumValue("ja-ro")
	@field:Json(name = "ja-ro")
	JapaneseRomanized,

	@EnumValue("zh")
	@field:Json(name = "zh")
	SimplifiedChinese,

	@EnumValue("zh-hk")
	@field:Json(name = "zh-hk")
	TraditionalChinese,

	@EnumValue("zh-ro")
	@field:Json(name = "zh-ro")
	ChineseRomanized,

	@EnumValue("ko")
	@field:Json(name = "ko")
	Korean,

	@EnumValue("ko-ro")
	@field:Json(name = "ko-ro")
	KoreanRomanized,

	@EnumValue("se")
	@field:Json(name = "se")
	Swedish,

	@EnumValue("fi")
	@field:Json(name = "fi")
	Finnish,

	@EnumValue("fr")
	@field:Json(name = "fr")
	French,

	@EnumValue("de")
	@field:Json(name = "de")
	German,

	@EnumValue("it")
	@field:Json(name = "it")
	Italian,

	@EnumValue("es")
	@field:Json(name = "es")
	Spanish,

	@EnumValue("pt")
	@field:Json(name = "pt")
	Portuguese,

	@EnumValue("ru")
	@field:Json(name = "ru")
	Russian,

	@EnumValue("vi")
	@field:Json(name = "vi")
	Vietnamese,

	@EnumValue("ar")
	@field:Json(name = "ar")
	Arabic,

	@EnumValue("tr")
	@field:Json(name = "tr")
	Turkish,

	@EnumValue("id")
	@field:Json(name = "id")
	Indonesian,

	@EnumValue("ms")
	@field:Json(name = "ms")
	Malay,

	@field:Json(name = "private_not_impl")
	NotImplemented;

	override fun toString(): String = DexUtils.toTitleCase(name)

	/**
	 * @return Flag asset ID or null if the locale doesn't have a flag.
	 */
	fun getFlagId(): Int? {
		return when (this) {
			English -> R.drawable.flag_uk
			Japanese -> R.drawable.flag_jp
			Korean -> R.drawable.flag_kr
			SimplifiedChinese -> R.drawable.flag_cn
			TraditionalChinese -> R.drawable.flag_hk
			Finnish -> R.drawable.flag_fi
			French -> R.drawable.flag_fr
			German -> R.drawable.flag_de
			Indonesian -> R.drawable.flag_id
			Italian -> R.drawable.flag_it
			Malay -> R.drawable.flag_ms
			Portuguese -> R.drawable.flag_pt
			Russian -> R.drawable.flag_ru
			Arabic -> R.drawable.flag_sa
			Swedish -> R.drawable.flag_se
			Turkish -> R.drawable.flag_tr
			Vietnamese -> R.drawable.flag_vn
			Spanish -> R.drawable.flag_esp
			else -> null
		}
	}
}

@JsonClass(generateAdapter = false)
enum class DexListVisibility {
	@field:Json(name = "public")
	Public,

	@field:Json(name = "private")
	Private;

	override fun toString(): String = DexUtils.toTitleCase(name)
}

@JsonClass(generateAdapter = false)
enum class DexContentRating {
	@field:Json(name = "safe")
	Safe,

	@field:Json(name = "suggestive")
	Suggestive,

	@field:Json(name = "erotica")
	Erotica,

	@field:Json(name = "pornographic")
	Pornographic;

	override fun toString(): String = DexUtils.toTitleCase(name)
}

typealias DexLocaleObject = Map<DexLocale, String?>

interface DexBaseResponse {
	val result: DexResult
}

@JsonClass(generateAdapter = true)
data class DexBaseResponseImpl(
	override val result: DexResult,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexResponse<T>(
	override val result: DexResult,
	val response: DexResponseType,
	val data: DexResponseData<T>,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexCollectionResponse<T>(
	override val result: DexResult,
	val response: DexResponseType,
	val data: List<DexResponseData<T>>,
	val limit: Int,
	val offset: Int,
	val total: Int,
) : DexBaseResponse

@JsonClass(generateAdapter = true)
data class DexResponseData<T>(
	val id: String,
	val type: DexEntityType,
	val attributes: T,
	val relationships: List<DexRelationship>
)