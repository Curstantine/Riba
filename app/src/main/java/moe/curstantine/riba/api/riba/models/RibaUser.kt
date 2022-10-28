package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

@Entity(tableName = "users")
data class RibaUser(
	@PrimaryKey val id: String,
	@ColumnInfo val username: String,
	@ColumnInfo val avatar: String?,
	@ColumnInfo val roles: List<String>,
	@ColumnInfo val version: Int,
) {
	companion object {
		fun getDefault() = RibaUser(
			id = "c36ab005-6329-4fe1-8517-099d7e134515",
			username = "Curstantine",
			avatar = null,
			roles = listOf("ROLE_MEMBER", "ROLE_GROUP_MEMBER"),
			version = 0,
		)
	}
}
