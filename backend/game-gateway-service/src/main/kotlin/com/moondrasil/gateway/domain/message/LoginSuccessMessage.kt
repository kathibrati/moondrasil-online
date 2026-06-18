package com.moondrasil.gateway.domain.message

data class LoginSuccessMessage(
    val type: String = "LOGIN_SUCCESS",
    val username: String,
)
