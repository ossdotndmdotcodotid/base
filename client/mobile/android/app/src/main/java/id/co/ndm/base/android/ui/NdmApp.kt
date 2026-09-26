package id.co.ndm.base.android.ui

import androidx.compose.animation.AnimatedContent
import androidx.compose.animation.core.FastOutSlowInEasing
import androidx.compose.animation.core.tween
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.togetherWith
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import kotlinx.coroutines.delay

private const val SplashHoldMillis = 1400L
private const val FadeOutMillis = 300
private const val FadeInMillis = 380
private const val FadeSequenceGapMillis = 300

@Composable
fun NdmApp() {
    var showSplash by rememberSaveable { mutableStateOf(true) }

    LaunchedEffect(Unit) {
        if (showSplash) {
            delay(SplashHoldMillis)
            showSplash = false
        }
    }

    AnimatedContent(
        targetState = showSplash,
        transitionSpec = {
            fadeIn(
                animationSpec = tween(
                    durationMillis = FadeInMillis,
                    delayMillis = FadeSequenceGapMillis,
                    easing = FastOutSlowInEasing
                )
            ) togetherWith fadeOut(
                animationSpec = tween(
                    durationMillis = FadeOutMillis,
                    easing = FastOutSlowInEasing
                )
            )
        },
        label = "launchTransition"
    ) { splash ->
        if (splash) {
            SplashScreen()
        } else {
            HomeScreen()
        }
    }
}
