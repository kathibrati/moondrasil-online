$ErrorActionPreference = "Stop"

Write-Host "Creating Gradle wrapper..."

Invoke-WebRequest `
  -Uri "https://services.gradle.org/distributions/gradle-8.14.3-bin.zip" `
  -OutFile "gradle.zip"

Expand-Archive gradle.zip -DestinationPath ".gradle-temp" -Force

.\.gradle-temp\gradle-8.14.3\bin\gradle.bat wrapper `
  --gradle-version 8.14.3 `
  --distribution-type bin

Remove-Item gradle.zip -Force
Remove-Item .gradle-temp -Recurse -Force

Write-Host "Gradle wrapper created."
Write-Host "Now run: .\gradlew.bat --version"