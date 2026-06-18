package com.moondrasil.character

import io.quarkus.test.junit.QuarkusTest
import io.restassured.RestAssured.given
import org.hamcrest.CoreMatchers.equalTo
import org.junit.jupiter.api.Test

@QuarkusTest
class CharacterResourceTest {

    @Test
    fun `reports service status`() {
        given()
            .`when`().get("/characters")
            .then()
            .statusCode(200)
            .body("service", equalTo("character-service"))
            .body("status", equalTo("up"))
    }
}
