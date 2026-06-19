package com.moondrasil.gateway.domain.message

data class CharacterNotFoundMessage(
    val type: String = "ERROR",
    val errorCode: String = "CHARACTER_NOT_FOUND",
)
