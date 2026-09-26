package id.co.ndm.base.android.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxHeight
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.dp
import id.co.ndm.base.android.R
import id.co.ndm.base.android.ui.theme.Bone
import id.co.ndm.base.android.ui.theme.InkDeep
import id.co.ndm.base.android.ui.theme.Lime
import id.co.ndm.base.android.ui.theme.MicroStyle

private fun phase(value: Float, start: Float, end: Float): Float =
    ((value - start) / (end - start)).coerceIn(0f, 1f)

@Composable
fun BrandScreen() {
    val reveal = remember { Animatable(0f) }

    LaunchedEffect(Unit) {
        reveal.animateTo(1f, tween(durationMillis = 980, easing = FastOutSlowInEasing))
    }

    val idle = rememberInfiniteTransition(label = "ruleGlow")
    val ruleGlow by idle.animateFloat(
        initialValue = 0.10f,
        targetValue = 0.32f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 4200, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "ruleGlow"
    )

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(InkDeep)
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .safeDrawingPadding()
                .padding(horizontal = 30.dp, vertical = 26.dp)
        ) {
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .verticalScroll(rememberScrollState())
            ) {
                LogoMark(
                    modifier = Modifier.graphicsLayer {
                        val p = phase(reveal.value, 0f, 0.55f)
                        alpha = p
                        val s = 0.88f + 0.12f * p
                        scaleX = s
                        scaleY = s
                        translationY = (1f - p) * 22.dp.toPx()
                    }
                )

                Spacer(modifier = Modifier.height(38.dp))

                Wordmark(reveal = { phase(reveal.value, 0.32f, 1f) })

                Spacer(modifier = Modifier.height(22.dp))

                Box(
                    modifier = Modifier
                        .height(1.dp)
                        .fillMaxWidth()
                        .graphicsLayer {
                            val p = phase(reveal.value, 0.62f, 1f)
                            alpha = p
                            scaleX = p
                            transformOrigin = TransformOrigin(0f, 0.5f)
                        }
                        .background(Bone.copy(alpha = 0.16f))
                )

                Spacer(modifier = Modifier.height(16.dp))

                Text(
                    text = stringResource(R.string.app_version),
                    style = MicroStyle,
                    color = Bone,
                    modifier = Modifier.graphicsLayer {
                        alpha = phase(reveal.value, 0.72f, 1f) * 0.55f
                    }
                )

                Spacer(modifier = Modifier.height(14.dp))

                Text(
                    text = stringResource(R.string.app_name).uppercase(),
                    style = MicroStyle,
                    color = Lime,
                    modifier = Modifier.graphicsLayer {
                        alpha = phase(reveal.value, 0.82f, 1f) * ruleGlow
                    }
                )

                Spacer(modifier = Modifier.height(26.dp))
            }

            Box(
                modifier = Modifier
                    .align(Alignment.TopEnd)
                    .fillMaxHeight()
                    .width(1.dp)
                    .graphicsLayer {
                        val p = phase(reveal.value, 0.45f, 1f)
                        alpha = p * 0.45f
                        scaleY = p
                        transformOrigin = TransformOrigin(0.5f, 0f)
                    }
                    .background(Lime)
            )
        }
    }
}
