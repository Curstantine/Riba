package moe.curstantine.riba.api.riba

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import androidx.room.Room
import moe.curstantine.riba.api.database.RibaDatabase
import moe.curstantine.riba.api.mangadex.MangaDexService

class RibaAPIService(context: Context) {
    private val database = Room
        .databaseBuilder(context, RibaDatabase::class.java, "Riba")
        .build()

    val mangadex = MangaDexService(this.database)

    companion object {
        @Composable
        fun createDummy() = RibaAPIService(LocalContext.current)
    }
}

