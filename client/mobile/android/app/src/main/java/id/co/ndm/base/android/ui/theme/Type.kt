package id.co.ndm.base.android.ui.theme

import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.sp

val WordmarkStyle = TextStyle(
    fontFamily = FontFamily.SansSerif,
    fontWeight = FontWeight.W900,
    fontSize = 40.sp,
    lineHeight = 42.sp,
    letterSpacing = (-1.5).sp
)

val PrefixStyle = TextStyle(
    fontFamily = FontFamily.SansSerif,
    fontWeight = FontWeight.W700,
    fontSize = 12.sp,
    lineHeight = 14.sp,
    letterSpacing = 4.sp
)

val MicroStyle = TextStyle(
    fontFamily = FontFamily.Monospace,
    fontWeight = FontWeight.Normal,
    fontSize = 10.sp,
    lineHeight = 12.sp,
    letterSpacing = 1.8.sp
)
