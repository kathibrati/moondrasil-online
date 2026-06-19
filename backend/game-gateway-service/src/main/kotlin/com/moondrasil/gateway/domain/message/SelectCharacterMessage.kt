package com.moondrasil.gateway.domain.message

data class SelectCharacterMessage(
    val type: String = "SELECT_CHARACTER",
    val characterId: String = "",
)
