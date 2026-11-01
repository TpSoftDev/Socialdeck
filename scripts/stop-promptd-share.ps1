$ErrorActionPreference = "Stop"
# IA: A local stop request closes only our sharing run; it is not an internet endpoint.
$statePath = Join-Path (Split-Path $PSScriptRoot -Parent) "backend/promptd/.share.local"
$connectionPath = Join-Path $statePath "connection.json"
if (-not (Test-Path -LiteralPath $connectionPath)) { Write-Output "No active PC AI sharing session was found."; exit 0 }
$connection = Get-Content -LiteralPath $connectionPath -Raw | ConvertFrom-Json
[System.IO.File]::WriteAllText((Join-Path $statePath "stop.request"), [string]$connection.runId)
Write-Output "Stop requested. Current AI requests can finish before the server closes."
