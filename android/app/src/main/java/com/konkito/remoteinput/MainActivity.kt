package com.konkito.remoteinput

import android.os.Bundle
import android.os.Parcelable
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.ExperimentalFoundationApi
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.gestures.draggable2D
import androidx.compose.foundation.gestures.rememberDraggable2DState
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material3.Button
import androidx.compose.material3.Card
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.material3.TextField
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.konkito.remoteinput.ui.theme.RemoteInputTheme
import java.util.logging.Logger
import androidx.compose.runtime.getValue
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.input.key.key
import androidx.compose.ui.input.key.onKeyEvent
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.dp
import kotlinx.android.parcel.Parcelize
import java.lang.NumberFormatException

val LOGGER = Logger.getLogger("com.konkito.remoteinput")

@Parcelize
class RemoteInput(var handle: Int) : Parcelable {
    companion object {
        init {
            System.loadLibrary("remoteinput")
        }
    }

    constructor (name: String, port: Short) : this(0) {
        val res = init(name, port);
        LOGGER.info("Init RemoteInput")
        LOGGER.info("Res: $res handle: $handle")
        if (res != 0) {
            throw Exception("Cannot connect!")
        }
    }

    private external fun init(name: String, port: Short): Int;
    external fun deinit()
    external fun press(key: Short)
    external fun release(key: Short)
    external fun type(text: String)
    external fun move(x: Int, y: Int)

    fun key(key: Short) {
        press(key)
        release(key)
    }
}

@Parcelize
sealed class Screen : Parcelable {
    data class Connect(var a: String) : Screen()
    data class Control(var remoteInput: RemoteInput) : Screen()
}

class MainActivity : ComponentActivity() {
    @OptIn(ExperimentalFoundationApi::class)
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContent {
            var screen by rememberSaveable {
                mutableStateOf(
                    Screen.Connect("") as Screen
                )
            }

            RemoteInputTheme {
                when (screen) {
                    is Screen.Connect -> {
                        Scaffold(modifier = Modifier.fillMaxSize()) {
                            ConnectScreen({ screen = it }, Modifier.padding(it))
                        }
                    }

                    is Screen.Control -> {
                        var remoteInput = (screen as Screen.Control).remoteInput
                        Scaffold(modifier = Modifier.fillMaxSize(), bottomBar = {
                            TextField("",
                                {
                                    if (it.length == 1) {
                                        LOGGER.info("Type `${it}`")
                                        remoteInput.type(it)
                                    }
                                },
                                modifier = Modifier
                                    .fillMaxWidth()
                                    .onKeyEvent { key ->
                                        LOGGER.info("Key: $key");
                                        if (key.key.keyCode == androidx.compose.ui.input.key.Key.Backspace.keyCode) {
                                            remoteInput.key(14)
                                        }
                                        false
                                    })
                        }
                        ) {
                            Box(modifier = Modifier.padding(it)) {
                                Card(modifier = Modifier
                                    .fillMaxSize()
                                    .padding(10.dp)
                                    .draggable2D(state = rememberDraggable2DState {
                                        remoteInput.move(it.x.toInt(), it.y.toInt())
                                    })
                                    .pointerInput(Unit) {
                                        detectTapGestures(
                                            onTap = {
                                                remoteInput.key(0x110);
                                            },
                                            onDoubleTap = {
                                                remoteInput.key(0x110);

                                                Thread() {
                                                    Thread.sleep(100)
                                                    remoteInput.key(0x110);
                                                }.start()

                                            },
                                            onLongPress = {
                                                remoteInput.key(0x111);
                                            }
                                        )
                                    }
                                )
                                {}
                            }
                        }
                    }
                }
            }
        }
    }
}

@Composable
fun ConnectScreen(onSetScreen: (Screen) -> Unit = {}, modifier: Modifier = Modifier) {
    var address by rememberSaveable { mutableStateOf("192.168.100.") }
    var text_port by rememberSaveable { mutableStateOf("2120") }

    val port: Result<UShort> = try {
        Result.success(text_port.toUShort())
    } catch (err: NumberFormatException) {
        Result.failure(err)
    };

    Column(
        modifier = modifier.fillMaxSize(),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.Center,
    ) {
        TextField(address, onValueChange = { address = it })
        TextField(
            text_port,
            { text_port = it },
            isError = port.isFailure,
            singleLine = true,
            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
        )
        Button({
            if (port.isSuccess) {
                try {
                    onSetScreen(Screen.Control(RemoteInput(address, port.getOrThrow().toShort())))
                } catch (e: Exception) {

                }
            }
        }) { Text("Connect") }
    }
}

@Preview()
@Composable
fun Test() {
    RemoteInputTheme { ConnectScreen() }
}