package com.moondrasil.gateway.application

import com.moondrasil.gateway.domain.message.CharacterDto
import com.moondrasil.gateway.domain.message.CharacterListMessage
import com.moondrasil.gateway.domain.message.CharacterNotFoundMessage
import com.moondrasil.gateway.domain.message.EnterWorldMessage
import com.moondrasil.gateway.domain.message.GetCharactersMessage
import com.moondrasil.gateway.domain.message.LoginFailedMessage
import com.moondrasil.gateway.domain.message.LoginMessage
import com.moondrasil.gateway.domain.message.LoginSuccessMessage
import com.moondrasil.gateway.domain.message.PongMessage
import com.moondrasil.gateway.domain.message.SelectCharacterMessage

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
                CharacterDto(id = "1", name = "Basti"),
                CharacterDto(id = "2", name = "Kathleen"),
            ),
        )

    fun handleSelectCharacter(message: SelectCharacterMessage): Any =
        when (message.characterId) {
            "1" -> EnterWorldMessage(
                characterId = "1",
                characterName = "Basti",
                x = 100,
                y = 200,
            )
            "2" -> EnterWorldMessage(
                characterId = "2",
                characterName = "Kathleen",
                x = 120,
                y = 200,
            )
            else -> CharacterNotFoundMessage()
        }
}
