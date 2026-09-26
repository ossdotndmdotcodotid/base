package id.co.ndm.base.android.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.clickable
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawBehind
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import id.co.ndm.base.android.R
import id.co.ndm.base.android.ui.theme.Bone
import id.co.ndm.base.android.ui.theme.Lime
import id.co.ndm.base.android.ui.theme.PrefixStyle
import id.co.ndm.base.android.ui.theme.WordmarkStyle
import kotlinx.coroutines.delay

private fun window(value: Float, start: Float, end: Float): Float =
    ((value - start) / (end - start)).coerceIn(0f, 1f)

@Composable
fun Wordmark(
    reveal: () -> Float,
    modifier: Modifier = Modifier
) {
    val official = stringResource(R.string.company_name)
    val splitAt = official.indexOf(' ')
    val prefix = if (splitAt > 0) official.substring(0, splitAt) else ""
    val core = if (splitAt > 0) official.substring(splitAt + 1) else official

    var taps by remember { mutableIntStateOf(0) }
    val underline = remember { Animatable(0f) }

    val idle = rememberInfiniteTransition(label = "wordmarkIdle")
    val drift by idle.animateFloat(
        initialValue = -1f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 5400, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "drift"
    )

    LaunchedEffect(taps) {
        if (taps == 0) return@LaunchedEffect
        underline.animateTo(1f, tween(durationMillis = 420, easing = FastOutSlowInEasing))
        delay(900)
        underline.animateTo(0f, tween(durationMillis = 320, easing = FastOutSlowInEasing))
    }

    Column(
        modifier = modifier
            .fillMaxWidth()
            .clickable(
                interactionSource = remember { MutableInteractionSource() },
                indication = null
            ) { taps++ }
            .graphicsLayer {
                translationY = drift * 1.5.dp.toPx()
            }
    ) {
        Text(
            text = prefix,
            style = PrefixStyle,
            color = Lime,
            modifier = Modifier.graphicsLayer {
                val p = window(reveal(), 0f, 0.45f)
                alpha = p
                translationY = (1f - p) * 10.dp.toPx()
            }
        )
        Spacer(modifier = Modifier.height(6.dp))
        Text(
            text = core,
            style = WordmarkStyle,
            color = Bone,
            maxLines = 1,
            overflow = TextOverflow.Ellipsis,
            modifier = Modifier
                .graphicsLayer {
                    val p = window(reveal(), 0.28f, 1f)
                    alpha = p
                    translationY = (1f - p) * 16.dp.toPx()
                }
                .drawBehind {
                    val width = size.width * underline.value
                    if (width <= 0f) return@drawBehind
                    drawRect(
                        color = Lime,
                        topLeft = Offset(0f, size.height + 7.dp.toPx()),
                        size = Size(width, 2.dp.toPx())
                    )
                }
        )
    }
}
