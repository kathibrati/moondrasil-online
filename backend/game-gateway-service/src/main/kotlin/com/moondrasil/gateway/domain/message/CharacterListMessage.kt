package com.moondrasil.gateway.domain.message

data class CharacterListMessage(
    val type: String = "CHARACTER_LIST",
    val characters: List<CharacterDto>,
)
