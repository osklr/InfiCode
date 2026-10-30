#!/usr/bin/env bash
# restore.sh — Install freellmpool into a project-local venv and print Cline setup instructions.
# Part of InfiCode. See PLAN.md for design.
set -euo pipefail

# ---- Colors ----
if [ -t 1 ]; then
  GREEN=$'\033[0;32m'; RED=$'\033[0;31m'; YELLOW=$'\033[0;33m'; NC=$'\033[0m'
else
  GREEN=''; RED=''; YELLOW=''; NC=''
fi
info() { printf '%s[INFO]%s %s\n' "$GREEN" "$NC" "$*"; }
warn() { printf '%s[WARN]%s %s\n' "$YELLOW" "$NC" "$*"; }
fail() { printf '%s[FAIL]%s %s\n' "$RED" "$NC" "$*" >&2; exit 1; }

# ---- Paths ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"

# ---- Preflight ----
info "Checking prerequisites"

command -v python3 >/dev/null 2>&1 \
  || fail "python3 not found. Install Python 3 and retry."

python3 -c 'import sys; sys.exit(0 if sys.version_info >= (3, 10) else 1)' \
  || fail "Python 3.10+ is required."

python3 -m pip --version >/dev/null 2>&1 \
  || fail "pip is not available for python3."

info "python3: $(python3 --version 2>&1)"

if command -v code >/dev/null 2>&1; then
  info "code:    $(code --version 2>&1 | head -n 1)"
else
  warn "'code' CLI not found. Cline is a VS Code extension."
  warn "Install VS Code and run: Shell Command: Install 'code' command in PATH"
fi

# ---- Venv ----
if [ ! -d "$VENV_DIR" ]; then
  info "Creating virtual environment at $VENV_DIR"
  python3 -m venv "$VENV_DIR"
else
  info "Reusing existing virtual environment at $VENV_DIR"
fi

# shellcheck disable=SC1091
. "$VENV_DIR/bin/activate"

# ---- Install freellmpool (idempotent) ----
info "Installing/upgrading freellmpool in venv"
python -m pip install --upgrade pip --quiet
python -m pip install --upgrade freellmpool --quiet

INSTALLED_VERSION="$(python -m pip show freellmpool | awk '/^Version:/ {print $2}')"
info "freellmpool: ${INSTALLED_VERSION}"

# ---- Cline instructions ----
cat <<'EOF'

================================================================
  Cline setup (manual, one-time, in VS Code)
================================================================

  1. Open the Cline sidebar
  2. Open Cline settings (gear icon)
  3. Set:
       API Provider     : OpenAI Compatible
       Base URL         : http://localhost:8080/v1
       API Key          : anything
       Model ID         : kilo/poolside/laguna-s-2.1:free
       Context Window   : 32000
       Max Output Tokens: 4096
       Supports Images  : OFF
       Supports Comp Use: ON

  Note: Cline requires a specific Model ID and manual capability limits 
  for custom endpoints. Using generic aliases like 'auto' or 'agent' 
  may fail validation.

  freellmpool stores its own config at ~/.config/freellmpool/
  InfiCode never modifies that directory.

================================================================
  Next step
================================================================

  Start the proxy:

      scripts/start-freellmpool.sh

  Then in Cline, send any message to verify.

EOF

info "Restore complete."