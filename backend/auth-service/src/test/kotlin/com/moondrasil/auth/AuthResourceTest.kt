package com.moondrasil.auth

import io.quarkus.test.junit.QuarkusTest
import io.restassured.RestAssured.given
import org.hamcrest.CoreMatchers.equalTo
import org.junit.jupiter.api.Test

@QuarkusTest
class AuthResourceTest {

    @Test
    fun `reports service status`() {
        given()
            .`when`().get("/auth")
            .then()
            .statusCode(200)
            .body("service", equalTo("auth-service"))
            .body("status", equalTo("up"))
    }
}
