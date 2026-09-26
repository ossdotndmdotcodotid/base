package id.co.ndm.base.android.ui.theme

import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.runtime.Composable

private val NdmColourScheme = darkColorScheme(
    primary = Lime,
    onPrimary = InkDeep,
    background = InkDeep,
    onBackground = Bone,
    surface = Ink,
    onSurface = Bone
)

@Composable
fun NdmTheme(content: @Composable () -> Unit) {
    MaterialTheme(
        colorScheme = NdmColourScheme,
        content = content
    )
}
