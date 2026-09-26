package id.co.ndm.base.android.ui

import android.content.pm.PackageManager
import android.os.Build
import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxWithConstraints
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.heightIn
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.safeDrawingPadding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.TransformOrigin
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.dp
import id.co.ndm.base.android.ui.theme.AmoledBlack
import id.co.ndm.base.android.ui.theme.Bone
import id.co.ndm.base.android.ui.theme.MicroStyle

private fun phase(value: Float, start: Float, end: Float): Float =
    ((value - start) / (end - start)).coerceIn(0f, 1f)

@Suppress("DEPRECATION")
@Composable
private fun rememberVersionName(): String {
    val context = LocalContext.current
    return remember(context) {
        runCatching {
            val manager = context.packageManager
            val info = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
                manager.getPackageInfo(context.packageName, PackageManager.PackageInfoFlags.of(0L))
            } else {
                manager.getPackageInfo(context.packageName, 0)
            }
            info.versionName
        }.getOrNull().orEmpty()
    }
}

@Composable
fun HomeScreen() {
    val reveal = remember { Animatable(0f) }
    val versionName = rememberVersionName()

    LaunchedEffect(Unit) {
        reveal.animateTo(1f, tween(durationMillis = 980, easing = FastOutSlowInEasing))
    }

    BoxWithConstraints(
        modifier = Modifier
            .fillMaxSize()
            .background(AmoledBlack)
            .safeDrawingPadding()
            .padding(horizontal = 32.dp, vertical = 24.dp)
    ) {
        val viewportHeight = maxHeight

        Box(
            modifier = Modifier
                .fillMaxSize()
                .verticalScroll(rememberScrollState())
        ) {
            Column(
                modifier = Modifier
                    .fillMaxWidth()
                    .heightIn(min = viewportHeight),
                horizontalAlignment = Alignment.CenterHorizontally,
                verticalArrangement = Arrangement.Center
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

                Spacer(modifier = Modifier.height(24.dp))

                Box(
                    modifier = Modifier
                        .height(1.dp)
                        .width(54.dp)
                        .graphicsLayer {
                            val p = phase(reveal.value, 0.62f, 1f)
                            alpha = p * 0.30f
                            scaleX = p
                            transformOrigin = TransformOrigin(0.5f, 0.5f)
                        }
                        .background(Bone)
                )

                Spacer(modifier = Modifier.height(18.dp))

                Text(
                    text = "V$versionName",
                    style = MicroStyle,
                    color = Bone,
                    textAlign = TextAlign.Center,
                    modifier = Modifier.graphicsLayer {
                        alpha = phase(reveal.value, 0.72f, 1f) * 0.85f
                    }
                )
            }
        }
    }
}
