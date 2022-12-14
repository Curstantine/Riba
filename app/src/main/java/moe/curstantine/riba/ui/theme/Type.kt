package moe.curstantine.riba.ui.theme

import androidx.compose.material3.Typography
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.Font
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontStyle
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp
import moe.curstantine.riba.R


val Nunito = FontFamily(
	Font(R.font.nunito_light, FontWeight.Light, FontStyle.Normal),
	Font(R.font.nunito_regular, FontWeight.Normal, FontStyle.Normal),
	Font(R.font.nunito_italic, FontWeight.Normal, FontStyle.Italic),
	Font(R.font.nunito_medium, FontWeight.Medium, FontStyle.Normal),
)

val Rubik = FontFamily(
	Font(R.font.rubik_regular, FontWeight.Normal, FontStyle.Normal),
	Font(R.font.rubik_medium, FontWeight.Medium, FontStyle.Normal),
)

val Typography = Typography(
	bodySmall = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Normal,
		fontSize = 12.sp,
		lineHeight = 16.sp,
	),
	bodyMedium = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Normal,
		fontSize = 14.sp,
		lineHeight = 20.sp,
	),
	bodyLarge = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Normal,
		fontSize = 16.sp,
		lineHeight = 24.sp,
	),
	labelSmall = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Medium,
		fontSize = 11.sp,
		lineHeight = 16.sp,
	),
	labelMedium = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Medium,
		fontSize = 12.sp,
		lineHeight = 16.sp,
	),
	labelLarge = TextStyle(
		fontFamily = Nunito,
		fontWeight = FontWeight.Medium,
		fontSize = 14.sp,
		lineHeight = 20.sp,
	),
	titleSmall = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Medium,
		fontSize = 14.sp,
		lineHeight = 20.sp,
	),
	titleMedium = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Medium,
		fontSize = 16.sp,
		lineHeight = 24.sp,
	),
	titleLarge = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 22.sp,
		lineHeight = 28.sp,
	),
	headlineSmall = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 24.sp,
		lineHeight = 32.sp,
	),
	headlineMedium = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 28.sp,
		lineHeight = 36.sp,
	),
	headlineLarge = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 32.sp,
		lineHeight = 40.sp,
	),
	displaySmall = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 36.sp,
		lineHeight = 44.sp,
	),
	displayMedium = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 45.sp,
		lineHeight = 52.sp,
	),
	displayLarge = TextStyle(
		fontFamily = Rubik,
		fontWeight = FontWeight.Normal,
		fontSize = 57.sp,
		lineHeight = 64.sp,
	),
)