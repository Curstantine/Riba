package moe.curstantine.mangodex.ui.common.components

import androidx.compose.foundation.layout.*
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.Dp

@Composable
fun FlexibleIndicator(height: Dp? = null, width: Dp? = null) {
    val modifier =
        if (height == null && width == null) {
            Modifier.fillMaxSize()
        } else if (height == null) {
            Modifier
                .fillMaxHeight()
                .width(width!!)
        } else {
            Modifier
                .fillMaxWidth()
                .height(height)
        }


    Box(modifier) {
        CircularProgressIndicator(Modifier.align(Alignment.Center))
    }
}