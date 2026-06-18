package com.moondrasil.gateway.domain.message

data class ErrorMessage(
    val type: String = "ERROR",
    val reason: String = "Unknown message type",
)
