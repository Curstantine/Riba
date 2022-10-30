package moe.curstantine.riba.api.mangadex.models

import com.squareup.moshi.JsonClass
import moe.curstantine.riba.api.riba.models.RibaUser

typealias DexUser = DexResponse<DexUserAttributes>
typealias DexUserCollection = DexCollectionResponse<DexUserAttributes>

typealias DexUserData = DexResponseData<DexUserAttributes>

@JsonClass(generateAdapter = true)
data class DexUserAttributes(
	val username: String,
	val roles: List<DexUserRole>,
	val version: Int,
)

@JsonClass(generateAdapter = true)
data class DexRelatedUser(
	override val id: String,
	override val type: DexEntityType,
	val attributes: DexUserAttributes?,
) : DexRelationship {
	/**
	 * Convert this [DexRelatedUser] to a [RibaUser].
	 *
	 * @throws IllegalStateException if [attributes] is null.
	 */
	fun toRibaUser(): RibaUser {
		if (attributes == null) {
			throw IllegalStateException("Attributes cannot be null trying to convert to a ${RibaUser::class.simpleName}")
		}

		return RibaUser(
			id = id,
			avatar = null,
			username = attributes.username,
			roles = attributes.roles,
			version = attributes.version,
		)
	}
}

// TODO: Add avatars when they are supported by the MangaDex API
fun DexUser.toRibaUser(): RibaUser = RibaUser(
	id = data.id,
	username = data.attributes.username,
	roles = data.attributes.roles,
	avatar = null,
	version = data.attributes.version,
)

fun DexUserData.toRibaUser(): RibaUser = RibaUser(
	id = id,
	username = attributes.username,
	roles = attributes.roles,
	avatar = null,
	version = attributes.version,
)

/**
 * POST body that's needed by MangaDex to authenticate.
 */
@JsonClass(generateAdapter = true)
data class DexUserAuthBody(
	val username: String,
	val password: String,
)

/**
 * POST body that's needed to refresh a token using the refresh token.
 *
 * @property token Refresh token returned by the auth.
 */
@JsonClass(generateAdapter = true)
data class DexUserAuthRefreshBody(
	val token: String,
)

/**
 * Response returned by the server when trying to log in.
 */
@JsonClass(generateAdapter = true)
data class DexUserAuthResponse(
	override val result: DexResult,
	val token: DexUserAuthTokens,
) : DexBaseResponse

/**
 * Tokens returned by the server when trying to log in,
 * typically wrapped within a [DexUserAuthResponse].
 *
 * @param session The session token, used to authenticate the user. This expires in 15 minutes.
 * @param refresh The refresh token, used to refresh the session token. This expires in 30 days.
 */
@JsonClass(generateAdapter = true)
data class DexUserAuthTokens(
	val session: String,
	val refresh: String,
)