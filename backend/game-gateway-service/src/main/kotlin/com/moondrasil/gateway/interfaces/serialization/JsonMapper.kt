package com.moondrasil.gateway.interfaces.serialization

import com.fasterxml.jackson.module.kotlin.jacksonObjectMapper

object JsonMapper {
    val mapper = jacksonObjectMapper()
}