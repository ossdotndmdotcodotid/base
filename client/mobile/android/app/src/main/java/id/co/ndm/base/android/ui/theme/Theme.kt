package id.co.ndm.base.android.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable

private val NdmColourScheme = darkColorScheme(
    primary = Lime,
    onPrimary = AmoledBlack,
    primaryContainer = Ink,
    onPrimaryContainer = Bone,
    inversePrimary = Lime,
    secondary = Bone,
    onSecondary = AmoledBlack,
    secondaryContainer = Ink,
    onSecondaryContainer = Bone,
    tertiary = Bone,
    onTertiary = AmoledBlack,
    tertiaryContainer = Ink,
    onTertiaryContainer = Bone,
    background = AmoledBlack,
    onBackground = Bone,
    surface = AmoledBlack,
    onSurface = Bone,
    surfaceVariant = Ink,
    onSurfaceVariant = Bone,
    surfaceTint = Lime,
    inverseSurface = Bone,
    inverseOnSurface = AmoledBlack,
    error = ErrorRed,
    onError = AmoledBlack,
    errorContainer = Ink,
    onErrorContainer = ErrorRed,
    outline = Bone,
    outlineVariant = Ink,
    scrim = AmoledBlack,
    surfaceBright = Ink,
    surfaceDim = AmoledBlack,
    surfaceContainer = Ink,
    surfaceContainerHigh = Ink,
    surfaceContainerHighest = Ink,
    surfaceContainerLow = AmoledBlack,
    surfaceContainerLowest = AmoledBlack
)

@Composable
fun NdmTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = NdmColourScheme,
        content = content
    )
}
