package com.moondrasil.gateway.domain.message

data class LoginFailedMessage(
    val type: String = "LOGIN_FAILED",
    val reason: String = "Invalid credentials",
)
