package com.moondrasil.gateway.interfaces.rest

import io.ktor.http.ContentType
import io.ktor.server.response.respondText
import io.ktor.server.routing.Route
import io.ktor.server.routing.get

fun Route.healthRoutes() {
    get("/health") {
        call.respondText(
            text = "game-gateway-service is running",
            contentType = ContentType.Text.Plain,
        )
    }
}
