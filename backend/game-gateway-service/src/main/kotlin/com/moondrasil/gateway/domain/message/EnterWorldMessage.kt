package com.moondrasil.gateway.domain.message

data class EnterWorldMessage(
    val type: String = "ENTER_WORLD",
    val characterId: String,
    val characterName: String,
    val x: Int,
    val y: Int,
)
