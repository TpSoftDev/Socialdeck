param([string]$Device = "emulator-5554", [switch]$LocalAi, [string]$ServerUrl = "")
$ErrorActionPreference = "Stop"
# IA: -ServerUrl uses Ibrahim's PC share link with the existing Firebase login.
# IA: If only Android rejects the share link, check the AVG certificate notes in
# backend/promptd/PC_HOSTING.md; keep HTTPS verification enabled.
# No provider key goes into Flutter. Without overrides the app uses cloud functions.
# -LocalAi opts into the original demo server for backend development only.
$projectRoot = Split-Path $PSScriptRoot -Parent
$flutterCommand = Get-Command flutter -ErrorAction SilentlyContinue
if (-not $flutterCommand) {
    throw "Flutter is not on PATH. Add your Flutter bin directory, then rerun this script."
}
if ($LocalAi -and $ServerUrl) { throw "Choose either -LocalAi or -ServerUrl, not both." }
$flutterArgs = @("run", "-d", $Device)
if ($ServerUrl) {
    $serverUri = [Uri]$ServerUrl
    if (-not $serverUri.IsAbsoluteUri -or $serverUri.Scheme -ne "https" -or $serverUri.UserInfo -or $serverUri.Query -or $serverUri.Fragment -or $serverUri.AbsolutePath -ne "/") { throw "Use the HTTPS sharing URL printed by the host." }
    $flutterArgs += "--dart-define=PROMPTD_SERVER_URL=$ServerUrl"
}
if ($LocalAi) {
    $flutterArgs += "--dart-define=PROMPTD_EMULATOR_HOST=10.0.2.2"
    $flutterArgs += "--dart-define=PROMPTD_PROJECT_ID=demo-socialdeck-promptd"
}
Push-Location -LiteralPath $projectRoot
try {
    & $flutterCommand.Source @flutterArgs
    if ($LASTEXITCODE -ne 0) { throw "Flutter exited with code $LASTEXITCODE." }
} finally {
    Pop-Location
}
