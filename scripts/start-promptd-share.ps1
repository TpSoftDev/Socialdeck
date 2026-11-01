$ErrorActionPreference = "Stop"
# IA: Start the PC-hosted AI server. Keep this terminal open while teammates test.
$backendPath = Join-Path (Split-Path $PSScriptRoot -Parent) "backend/promptd"
$env:NODE_USE_SYSTEM_CA = "1"
Push-Location -LiteralPath $backendPath
try {
    & npm.cmd run share
    if ($LASTEXITCODE -ne 0) { throw "AI sharing stopped with an error. See the message above." }
} finally { Pop-Location }
