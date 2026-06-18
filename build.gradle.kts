plugins {
    kotlin("jvm") version "2.0.21" apply false
    kotlin("plugin.allopen") version "2.0.21" apply false
    id("io.quarkus") version "3.17.5" apply false
    id("io.ktor.plugin") version "3.1.1" apply false
}

allprojects {
    group = "com.moondrasil"
    version = "0.1.0-SNAPSHOT"
}
