package id.co.ndm.base.android.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.height
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
        Column(
            horizontalAlignment = Alignment.CenterHorizontally,
            verticalArrangement = Arrangement.Center
        ) {
            LogoMark(
                diameter = 108.dp,
                interactive = false,
                modifier = Modifier.graphicsLayer {
                    val p = reveal.value
                    alpha = p
                    val s = 0.90f + 0.10f * p
                    scaleX = s
                    scaleY = s
                }
            )

            Spacer(modifier = Modifier.height(44.dp))

            CircularProgressIndicator(
                modifier = Modifier
                    .size(30.dp)
                    .graphicsLayer { alpha = reveal.value },
                color = Lime,
                strokeWidth = 3.dp,
                trackColor = Bone.copy(alpha = 0.14f)
            )
        }
    }
}
