package com.moondrasil.gateway.interfaces.websocket

import com.fasterxml.jackson.databind.JsonNode
import com.moondrasil.gateway.application.GatewayMessageHandler
import com.moondrasil.gateway.domain.message.ErrorMessage
import com.moondrasil.gateway.domain.message.GetCharactersMessage
import com.moondrasil.gateway.domain.message.LoginMessage
import com.moondrasil.gateway.interfaces.serialization.JsonMapper

object MessageDispatcher {

    fun dispatch(message: String): Any {
        val payload = parse(message)
            ?: return ErrorMessage()

        return when (payload.path("type").asText()) {
            "PING" -> GatewayMessageHandler.handlePing()
            "LOGIN" -> GatewayMessageHandler.handleLogin(
                JsonMapper.mapper.treeToValue(payload, LoginMessage::class.java),
            )
            "GET_CHARACTERS" -> GatewayMessageHandler.handleGetCharacters(
                JsonMapper.mapper.treeToValue(payload, GetCharactersMessage::class.java),
            )
            else -> ErrorMessage()
        }
    }

    private fun parse(message: String): JsonNode? =
        runCatching { JsonMapper.mapper.readTree(message) }.getOrNull()
}
