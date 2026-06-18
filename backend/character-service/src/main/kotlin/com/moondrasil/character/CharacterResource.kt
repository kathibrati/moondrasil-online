package com.moondrasil.character

import jakarta.ws.rs.GET
import jakarta.ws.rs.Path
import jakarta.ws.rs.Produces
import jakarta.ws.rs.core.MediaType

@Path("/characters")
class CharacterResource {

    @GET
    @Produces(MediaType.APPLICATION_JSON)
    fun status(): Map<String, String> =
        mapOf(
            "service" to "character-service",
            "status" to "up",
        )
}
