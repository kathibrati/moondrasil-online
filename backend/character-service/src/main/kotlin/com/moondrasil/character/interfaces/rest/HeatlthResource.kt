package com.moondrasil.character.interfaces.rest

import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@Path("/health")
class HealthResource {

    @GET
    @Produces(MediaType.TEXT_PLAIN)
    fun health(): String = "char-service is running"
}