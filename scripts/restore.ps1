# restore.ps1 - Install freellmpool into a project-local venv and print Cline setup instructions.
# Part of InfiCode. See PLAN.md for design.
$ErrorActionPreference = "Stop"

$ProjectRoot = Split-Path -Parent $PSScriptRoot
$VenvDir = Join-Path $ProjectRoot ".venv"

Write-Host "[INFO] Checking prerequisites" -ForegroundColor Green

# Check Python
if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
    Write-Host "[FAIL] python not found. Install Python 3 and retry." -ForegroundColor Red
    exit 1
}
Write-Host "[INFO] python: $(python --version 2>&1)"

# Check VS Code CLI
if (Get-Command code -ErrorAction SilentlyContinue) {
    Write-Host "[INFO] code: $((code --version)[0])"
} else {
    Write-Host "[WARN] 'code' CLI not found. Install VS Code and add it to PATH." -ForegroundColor Yellow
}

# Setup venv
if (-not (Test-Path $VenvDir)) {
    Write-Host "[INFO] Creating virtual environment at $VenvDir"
    python -m venv $VenvDir
} else {
    Write-Host "[INFO] Reusing existing virtual environment at $VenvDir"
}

# Activate and install
& "$VenvDir\Scripts\Activate.ps1"
Write-Host "[INFO] Installing/upgrading freellmpool in venv"
python -m pip install --upgrade pip --quiet
python -m pip install --upgrade freellmpool --quiet

$Version = python -m pip show freellmpool | Select-String "^Version:" | ForEach-Object { $_.Line.Split(":")[1].Trim() }
Write-Host "[INFO] freellmpool: $Version"

Write-Host @"

================================================================
  Cline setup (manual, one-time, in VS Code)
================================================================

  1. Open the Cline sidebar
  2. Open Cline settings (gear icon)
  3. Set:
       API Provider     : OpenAI Compatible
       Base URL         : http://localhost:8080/v1
       API Key          : anything
       Model ID         : pollinations/openai-fast
       Context Window   : 32000
       Max Output Tokens: 4096
       Supports Images  : OFF
       Supports Comp Use: ON

  Note: Cline requires a specific Model ID and manual capability 
  limits for custom endpoints. Using 'auto' or 'agent' may fail 
  validation. If 'pollinations/openai-fast' is unavailable, try 
  'kilo/poolside/laguna-s-2.1:free'.

  freellmpool stores its own config at ~/.config/freellmpool/
  InfiCode never modifies that directory.

================================================================
  Next step
================================================================

  Start the proxy:

      scripts\start-freellmpool.ps1

"@

Write-Host "[INFO] Restore complete." -ForegroundColor Green