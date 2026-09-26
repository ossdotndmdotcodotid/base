package id.co.ndm.base.android.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.size
import androidx.compose.material3.CircularProgressIndicator
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.unit.dp
import id.co.ndm.base.android.ui.theme.AmoledBlack
import id.co.ndm.base.android.ui.theme.Bone
import id.co.ndm.base.android.ui.theme.Lime

private val MarkDiameter = 184.dp
private val ProgressRingDiameter = 224.dp

@Composable
fun SplashScreen() {
    val reveal = remember { Animatable(0f) }

    LaunchedEffect(Unit) {
        reveal.animateTo(1f, tween(durationMillis = 620, easing = FastOutSlowInEasing))
    }

    Box(
        modifier = Modifier
            .fillMaxSize()
            .background(AmoledBlack),
        contentAlignment = Alignment.Center
    ) {
        Box(
            contentAlignment = Alignment.Center,
            modifier = Modifier.graphicsLayer {
                val p = reveal.value
                alpha = p
                val s = 0.92f + 0.08f * p
                scaleX = s
                scaleY = s
            }
        ) {
            CircularProgressIndicator(
                modifier = Modifier.size(ProgressRingDiameter),
                color = Lime,
                trackColor = Bone.copy(alpha = 0.12f)
            )

            LogoMark(
                diameter = MarkDiameter,
                showArc = false,
                interactive = false
            )
        }
    }
}
