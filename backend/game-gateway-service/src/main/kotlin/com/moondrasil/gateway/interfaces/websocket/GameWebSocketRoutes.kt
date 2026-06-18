package com.moondrasil.gateway.interfaces.websocket

import com.moondrasil.gateway.interfaces.serialization.JsonMapper
import io.ktor.server.routing.Route
import io.ktor.server.websocket.webSocket
import io.ktor.websocket.Frame
import io.ktor.websocket.readText
import io.ktor.websocket.send

fun Route.gameWebSocketRoutes() {
    webSocket("/ws") {
        send("""{"type":"CONNECTED","message":"Welcome to Moondrasil"}""")

        for (frame in incoming) {
            if (frame is Frame.Text) {
                val response = MessageDispatcher.dispatch(frame.readText())
                send(JsonMapper.mapper.writeValueAsString(response))
            }
        }
    }
}
