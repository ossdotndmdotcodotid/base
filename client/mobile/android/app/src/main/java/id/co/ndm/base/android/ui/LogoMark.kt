package id.co.ndm.base.android.ui

import androidx.compose.animation.core.Animatable
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.animateFloatAsState
import androidx.compose.animation.core.exponentialDecay
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.spring
import androidx.compose.animation.core.tween
import androidx.compose.foundation.Image
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.interaction.MutableInteractionSource
import androidx.compose.foundation.interaction.collectIsPressedAsState
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.StrokeCap
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.drawscope.rotate
import androidx.compose.ui.graphics.graphicsLayer
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.res.painterResource
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import id.co.ndm.base.android.R
import id.co.ndm.base.android.ui.theme.Ink
import id.co.ndm.base.android.ui.theme.Lime
import kotlinx.coroutines.launch

private const val ArcSweepDegrees = 52f
private const val IdleSweepMillis = 18000
private const val DragToDegrees = 0.4f

@Composable
fun LogoMark(
    modifier: Modifier = Modifier,
    diameter: Dp = 168.dp
) {
    val interaction = remember { MutableInteractionSource() }
    val pressed by interaction.collectIsPressedAsState()
    val spin = remember { Animatable(0f) }
    val scope = rememberCoroutineScope()
    var flingVelocity by remember { mutableFloatStateOf(0f) }

    val pressScale by animateFloatAsState(
        targetValue = if (pressed) 0.94f else 1f,
        animationSpec = spring(dampingRatio = 0.55f, stiffness = 380f),
        label = "pressScale"
    )

    val idle = rememberInfiniteTransition(label = "logoIdle")
    val breathe by idle.animateFloat(
        initialValue = 0f,
        targetValue = 1f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = 3200, easing = FastOutSlowInEasing),
            repeatMode = RepeatMode.Reverse
        ),
        label = "breathe"
    )
    val sweep by idle.animateFloat(
        initialValue = 0f,
        targetValue = 360f,
        animationSpec = infiniteRepeatable(
            animation = tween(durationMillis = IdleSweepMillis, easing = LinearEasing),
            repeatMode = RepeatMode.Restart
        ),
        label = "sweep"
    )

    Box(
        modifier = modifier
            .size(diameter)
            .graphicsLayer {
                val s = pressScale * (1f + breathe * 0.012f)
                scaleX = s
                scaleY = s
            }
            .pointerInput(Unit) {
                detectHorizontalDragGestures(
                    onHorizontalDrag = { change, dragAmount ->
                        change.consume()
                        flingVelocity = dragAmount * DragToDegrees
                        scope.launch { spin.snapTo(spin.value + dragAmount * DragToDegrees) }
                    },
                    onDragEnd = {
                        scope.launch {
                            spin.animateDecay(
                                initialVelocity = flingVelocity * 22f,
                                animationSpec = exponentialDecay(frictionMultiplier = 0.82f)
                            )
                        }
                    }
                )
            }
            .clickable(
                interactionSource = interaction,
                indication = null
            ) { }
            .drawWithCache {
                val strokeWidth = 2.dp.toPx()
                val stroke = Stroke(width = strokeWidth, cap = StrokeCap.Round)
                onDrawBehind {
                    val radius = size.minDimension / 2f - strokeWidth
                    rotate(degrees = sweep + spin.value) {
                        drawArc(
                            color = Lime.copy(alpha = 0.45f + 0.45f * breathe),
                            startAngle = -90f,
                            sweepAngle = ArcSweepDegrees,
                            useCenter = false,
                            topLeft = Offset(center.x - radius, center.y - radius),
                            size = Size(radius * 2f, radius * 2f),
                            style = stroke
                        )
                    }
                }
            }
    ) {
        Box(
            modifier = Modifier
                .fillMaxSize()
                .padding(10.dp)
                .graphicsLayer {
                    shape = CircleShape
                    clip = true
                }
                .background(Ink)
        ) {
            Image(
                painter = painterResource(R.drawable.ic_ndm_logo),
                contentDescription = stringResource(R.string.logo_content_description),
                modifier = Modifier.fillMaxSize()
            )
        }
    }
}
