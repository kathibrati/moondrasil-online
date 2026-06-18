package com.moondrasil.gateway.application

import com.moondrasil.gateway.domain.message.CharacterDto
import com.moondrasil.gateway.domain.message.CharacterListMessage
import com.moondrasil.gateway.domain.message.GetCharactersMessage
import com.moondrasil.gateway.domain.message.LoginFailedMessage
import com.moondrasil.gateway.domain.message.LoginMessage
import com.moondrasil.gateway.domain.message.LoginSuccessMessage
import com.moondrasil.gateway.domain.message.PongMessage

object GatewayMessageHandler {

    fun handlePing(): PongMessage = PongMessage()

    fun handleLogin(message: LoginMessage): Any =
        if (message.username == "test" && message.password == "test") {
            LoginSuccessMessage(username = message.username)
        } else {
            LoginFailedMessage()
        }

    fun handleGetCharacters(@Suppress("UNUSED_PARAMETER") message: GetCharactersMessage): CharacterListMessage =
        CharacterListMessage(
            characters = listOf(
                CharacterDto(name = "Basti"),
                CharacterDto(name = "Kathleen"),
            ),
        )
}
