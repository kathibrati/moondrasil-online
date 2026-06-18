package com.moondrasil.gateway

import com.moondrasil.gateway.interfaces.rest.healthRoutes
import io.ktor.server.application.Application
import io.ktor.server.application.install
import io.ktor.server.engine.embeddedServer
import io.ktor.server.netty.Netty
import io.ktor.server.routing.routing
import io.ktor.server.websocket.WebSockets
import io.ktor.server.websocket.pingPeriod
import io.ktor.server.websocket.timeout
import io.ktor.server.websocket.webSocket
import io.ktor.websocket.Frame
import io.ktor.websocket.readText
import io.ktor.websocket.send
import kotlin.time.Duration.Companion.seconds

fun main() {
    embeddedServer(
        factory = Netty,
        port = 8090,
        host = "0.0.0.0",
        module = Application::module
    ).start(wait = true)
}

fun Application.module() {
    install(WebSockets) {
        pingPeriod = 15.seconds
        timeout = 30.seconds
        maxFrameSize = Long.MAX_VALUE
        masking = false
    }

    routing {
        healthRoutes()

        webSocket("/ws") {
            send("""{"type":"CONNECTED","message":"Welcome to Moondrasil"}""")

            for (frame in incoming) {
                if (frame is Frame.Text) {
                    val receivedText = frame.readText()
                    send("""{"type":"ECHO","message":"$receivedText"}""")
                }
            }
        }
    }
}