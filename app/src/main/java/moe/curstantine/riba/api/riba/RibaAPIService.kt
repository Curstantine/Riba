package moe.curstantine.riba.api.riba

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.LocalContext
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.SupervisorJob
import moe.curstantine.riba.api.mangadex.MangaDexService

class RibaAPIService(context: Context, applicationScope: CoroutineScope) {
	val mangadex = MangaDexService(context, applicationScope)

	companion object {
		@Composable
		fun createDummy(applicationScope: CoroutineScope = CoroutineScope(SupervisorJob())) = RibaAPIService(
			LocalContext.current,
			applicationScope,
		)
	}
}

