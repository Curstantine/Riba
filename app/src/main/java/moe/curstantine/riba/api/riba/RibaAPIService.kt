package moe.curstantine.riba.api.riba

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import moe.curstantine.riba.api.mangadex.MangaDexService

class RibaAPIService(context: Context) {
    val mangadex = MangaDexService(context)

    companion object {
        @Composable
        fun createDummy() = RibaAPIService(LocalContext.current)
    }
}

