param([string]$Device = "emulator-5554")
$ErrorActionPreference = "Stop"
# IA: Use the same checked-in app with explicit local AI configuration.
# Start backend/promptd with npm run emulators first. No provider key goes in Flutter.
$projectRoot = Split-Path $PSScriptRoot -Parent
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCommand) {
    throw "Flutter is not on PATH. Add your Flutter bin directory, then rerun this script."
}
Push-Location -LiteralPath $projectRoot
try {
    & $flutterCommand.Source run -d $Device --dart-define=PROMPTD_EMULATOR_HOST=10.0.2.2 --dart-define=PROMPTD_PROJECT_ID=demo-socialdeck-promptd
    if ($LASTEXITCODE -ne 0) { throw "Flutter exited with code $LASTEXITCODE." }
} finally {
    Pop-Location
}
