package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.Json
import com.squareup.moshi.JsonClass
import moe.curstantine.riba.R
import moe.curstantine.riba.api.adapters.retrofit.getEnumValue
import moe.curstantine.riba.api.mangadex.DexUtils

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

@JsonClass(generateAdapter = false)
enum class DexResponseType {
	@field:Json(name = "entity")
	Entity,

	@field:Json(name = "collection")
	Collection
}

@JsonClass(generateAdapter = false)
enum class DexUserRole {
	@field:Json(name = "ROLE_UNVERIFIED")
	Unverified,

	/**
	 * Normal user, this role is given to all users by default.
	 */
	@field:Json(name = "ROLE_MEMBER")
	Member,

	/**
	 * A group member, this role is given to any user who is in a scanlation group.
	 *
	 * Permissions are same as a normal [Member], but they can upload chapters under the group they are in
	 * regardless of whether it's locked or not.
	 */
	@field:Json(name = "ROLE_GROUP_MEMBER")
	GroupMember,

	/**
	 * Users who support the site by hosting their MD@H instance,
	 * these users don't have any special permissions compared to [Member]s.
	 */
	@field:Json(name = "ROLE_MD_AT_HOME")
	MdAtHome,

	/**
	 * A Contributor. As the name implies, someone who contributes to the site.
	 *
	 * These users can perform these actions without moderator approval.
	 * - Create/Edit chapters
	 * - Create/Edit titles
	 */
	@field:Json(name = "ROLE_CONTRIBUTOR")
	Contributor,

	/**
	 * A group leader, this role is given to any user who is the leader of a scanlation group.
	 *
	 * These users can perform these actions without moderator approval.
	 * - Create/Edit chapters
	 * - Create/Edit titles
	 * - Change group meta
	 * - Invite users to the group
	 */
	@field:Json(name = "ROLE_GROUP_LEADER")
	GroupLeader,

	/**
	 * User with elevated permissions, this role is given to users with 500 or more uploads.
	 *
	 * Permissions are same as [Contributor].
	 */
	@field:Json(name = "ROLE_POWER_UPLOADER")
	PowerUploader,

	@field:Json(name = "ROLE_VIP")
	Vip,

	/**
	 * MangaDex staff, don't really know why this exists.
	 *
	 * Every user with [PublicRelation], [Designer], [ForumModerator],
	 * [GlobalModerator], [Developer] [Administrator] in their role list have this role.
	 */
	@field:Json(name = "ROLE_STAFF")
	Staff,

	@field:Json(name = "ROLE_PUBLIC_RELATION")
	PublicRelation,

	@field:Json(name = "ROLE_DESIGNER")
	Designer,

	@field:Json(name = "ROLE_FORUM_MODERATOR")
	ForumModerator,

	@field:Json(name = "ROLE_GLOBAL_MODERATOR")
	GlobalModerator,

	@field:Json(name = "ROLE_DEVELOPER")
	Developer,

	@field:Json(name = "ROLE_ADMIN")
	Administrator;

	override fun toString(): String = DexUtils.toTitleCase(name)

	/**
	 * @return [Json.name] of this enum value.
	 * @throws NullPointerException  If the annotation couldn't be found for this enum.
	 */
	fun toDexEnum(): String = this.getEnumValue()

	companion object {
		/**
		 * @throws IllegalArgumentException  if the given [name] is not a valid [Json.name] value.
		 */
		fun fromDexEnum(name: String): DexUserRole {
			return DexUserRole::class.java.enumConstants?.firstOrNull { it.toDexEnum() == name }
				?: throw IllegalArgumentException("No DexUserRole enum value with name $name")
		}
	}
}


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

	/**
	 * @return [Json.name] of this enum value.
	 * @throws NullPointerException  If the annotation couldn't be found for this enum.
	 */
	fun toDexEnum(): String = this.getEnumValue()
}

enum class DexLocaleType {
	Default,
	Romanized,
	Traditional,
	Simplified;

	override fun toString(): String = DexUtils.toTitleCase(name)
}

@JsonClass(generateAdapter = false)
enum class DexLocale(val type: DexLocaleType = DexLocaleType.Default) {
	@field:Json(name = "en")
	English,

	@field:Json(name = "ja")
	Japanese,

	@field:Json(name = "ja-ro")
	JapaneseRomanized(DexLocaleType.Romanized),

	@field:Json(name = "zh")
	SimplifiedChinese(DexLocaleType.Simplified),

	@field:Json(name = "zh-hk")
	TraditionalChinese(DexLocaleType.Traditional),

	@field:Json(name = "zh-ro")
	ChineseRomanized(DexLocaleType.Romanized),

	@field:Json(name = "ko")
	Korean,

	@field:Json(name = "ko-ro")
	KoreanRomanized(DexLocaleType.Romanized),

	@field:Json(name = "se")
	Swedish,

	@field:Json(name = "fi")
	Finnish,

	@field:Json(name = "fr")
	French,

	@field:Json(name = "de")
	German,

	@field:Json(name = "it")
	Italian,

	@field:Json(name = "es")
	Spanish,

	@field:Json(name = "pt")
	Portuguese,

	@field:Json(name = "ru")
	Russian,

	@field:Json(name = "vi")
	Vietnamese,

	@field:Json(name = "ar")
	Arabic,

	@field:Json(name = "tr")
	Turkish,

	@field:Json(name = "id")
	Indonesian,

	@field:Json(name = "ms")
	Malay,

	@field:Json(name = "private_not_impl")
	NotImplemented;

	override fun toString(): String = DexUtils
		.toTitleCase(name)
		.replace("Romanized", "(Romanized)")

	/**
	 * Returns the human name of the [DexLocaleType] of this locale.
	 */
	fun getTypeName(): String = this.type.toString()

	/**
	 * Ignores [DexLocaleType] and returns just the language name.
	 *
	 * This is not 1:1 compatible with [valueOf] this enum, as it can return values that are not
	 * part of this enum set.
	 *
	 * Examples:
	 * - [DexLocale.JapaneseRomanized] -> `"Japanese"`
	 * - [DexLocale.TraditionalChinese] -> `"Chinese"` (DexLocale.Chinese doesn't exist!)
	 *
	 * 	@see toString
	 * 	@see getTypeName
	 */
	fun getLanguage(): String {
		return if (this.type == DexLocaleType.Default) this.toString()
		else {
			this.name.replace("(Romanized|Simplified|Traditional)".toRegex(), "")
		}

	}

	/**
	 * @return Flag asset ID or null if the locale doesn't have a flag.
	 */
	fun getFlagId(): Int? {
		return when (this) {
			English -> R.drawable.flag_uk
			JapaneseRomanized,
			Japanese -> R.drawable.flag_jp
			KoreanRomanized,
			Korean -> R.drawable.flag_kr
			ChineseRomanized,
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