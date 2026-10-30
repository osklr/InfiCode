# start-freellmpool.ps1 - Start the freellmpool proxy on 127.0.0.1:8080.
# Part of InfiCode. See PLAN.md for design.
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$VenvDir = Join-Path $ProjectRoot ".venv"
$HostIp = "127.0.0.1"
$Port = "8080"

if (-not (Test-Path $VenvDir)) {
    Write-Host "Error: virtual environment not found. Run scripts\restore.ps1 first." -ForegroundColor Red
    exit 1
}

& "$VenvDir\Scripts\Activate.ps1"

if (-not (Get-Command freellmpool -ErrorAction SilentlyContinue)) {
    Write-Host "Error: freellmpool not installed in venv. Run scripts\restore.ps1 first." -ForegroundColor Red
    exit 1
}

# Check if port is in use
$PortInUse = Get-NetTCPConnection -LocalPort $Port -ErrorAction SilentlyContinue
if ($PortInUse) {
    Write-Host "Error: port $Port is already in use. Stop the existing process first." -ForegroundColor Red
    exit 1
}

Write-Host "Starting freellmpool proxy" -ForegroundColor Green
Write-Host "  Base URL : http://${HostIp}:${Port}/v1"
Write-Host "  Health   : curl http://${HostIp}:${Port}/livez"
Write-Host "  Dashboard: http://${HostIp}:${Port}/dashboard"
Write-Host "  Press Ctrl+C to stop."
Write-Host ""

freellmpool proxy --host $HostIp --port $Port