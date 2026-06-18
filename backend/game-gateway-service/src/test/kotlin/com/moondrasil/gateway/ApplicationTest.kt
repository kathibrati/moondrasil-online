package com.moondrasil.gateway

import io.ktor.client.plugins.websocket.DefaultClientWebSocketSession
import io.ktor.client.plugins.websocket.WebSockets
import io.ktor.client.plugins.websocket.webSocket
import io.ktor.client.request.get
import io.ktor.http.HttpStatusCode
import io.ktor.server.testing.testApplication
import io.ktor.websocket.Frame
import io.ktor.websocket.readText
import kotlin.test.Test
import kotlin.test.assertEquals

class ApplicationTest {

    @Test
    fun `reports service status`() = testApplication {
        application {
            module()
        }

        val response = client.get("/health")

        assertEquals(HttpStatusCode.OK, response.status)
    }

    @Test
    fun `supports ping and successful login`() = testApplication {
        application {
            module()
        }

        val webSocketClient = createClient {
            install(WebSockets)
        }

        webSocketClient.webSocket("/ws") {
            assertEquals(
                """{"type":"CONNECTED","message":"Welcome to Moondrasil"}""",
                receiveText(),
            )

            send(Frame.Text("""{"type":"PING"}"""))
            assertEquals("""{"type":"PONG"}""", receiveText())

            send(Frame.Text("""{"type":"LOGIN","username":"test","password":"test"}"""))
            assertEquals("""{"type":"LOGIN_SUCCESS","username":"test"}""", receiveText())

            send(Frame.Text("""{"type":"GET_CHARACTERS"}"""))
            assertEquals(
                """{"type":"CHARACTER_LIST","characters":[{"name":"Basti"},{"name":"Kathleen"}]}""",
                receiveText(),
            )
        }
    }

    @Test
    fun `rejects invalid login and unknown message types`() = testApplication {
        application {
            module()
        }

        val webSocketClient = createClient {
            install(WebSockets)
        }

        webSocketClient.webSocket("/ws") {
            receiveText()

            send(Frame.Text("""{"type":"LOGIN","username":"test","password":"wrong"}"""))
            assertEquals(
                """{"type":"LOGIN_FAILED","reason":"Invalid credentials"}""",
                receiveText(),
            )

            send(Frame.Text("""{"type":"SOMETHING_ELSE"}"""))
            assertEquals(
                """{"type":"ERROR","reason":"Unknown message type"}""",
                receiveText(),
            )
        }
    }

    private suspend fun DefaultClientWebSocketSession.receiveText(): String =
        (incoming.receive() as Frame.Text).readText()
}
