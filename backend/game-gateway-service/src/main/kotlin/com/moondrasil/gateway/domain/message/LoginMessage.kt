package com.moondrasil.gateway.domain.message

data class LoginMessage(
    val type: String = "LOGIN",
    val username: String = "",
    val password: String = "",
)
