package moe.curstantine.riba

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.expandVertically
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.shrinkVertically
import androidx.compose.material3.Scaffold
import androidx.compose.material3.SnackbarHost
import androidx.compose.runtime.getValue
import androidx.core.view.WindowCompat
import moe.curstantine.riba.nav.RibaNavHost
import moe.curstantine.riba.nav.RibaRoute
import moe.curstantine.riba.ui.common.components.MangoNavigationBar
import moe.curstantine.riba.ui.theme.RibaTheme

class MainActivity : ComponentActivity() {
	override fun onCreate(savedInstanceState: Bundle?) {
		super.onCreate(savedInstanceState)
		WindowCompat.setDecorFitsSystemWindows(window, false)

		setContent {
			val state = RibaHostState.create()
			val currentRoute by state.navigator.currentRouteAsState()

			RibaTheme {
				Scaffold(
					snackbarHost = { SnackbarHost(state.snackbarHost) },
					content = { RibaNavHost(state, it) },
					bottomBar = {
						AnimatedVisibility(
							currentRoute.type == RibaRoute.Type.Default,
							exit = fadeOut() + shrinkVertically(),
							enter = fadeIn() + expandVertically(),
							content = { MangoNavigationBar(state.navigator) }
						)
					},
				)
			}
		}
	}
}



