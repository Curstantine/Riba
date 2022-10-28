package moe.curstantine.riba.api.riba.models

import androidx.room.ColumnInfo
import androidx.room.Entity
import androidx.room.PrimaryKey

/**
 * Generalized Statistic object that's used by the app, all external APIs should dissolve to this.
 *
 * @property id Manga id related to this statistic
 */
@Entity(tableName = "statistics")
data class RibaStatistic(
	@PrimaryKey val id: String,
	@ColumnInfo val bayesian: Float,
	@ColumnInfo val follows: Int,
) {
	companion object {
		fun getDefault(): RibaStatistic = RibaStatistic(
			"f9c33607-9180-4ba6-b85c-e4b5faee7192",
			7.9759936F,
			8469,
		)
	}
}