#!/usr/bin/env bash
# start-freellmpool.sh — Start the freellmpool proxy on 127.0.0.1:8080.
# Part of InfiCode. See PLAN.md for design.
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
VENV_DIR="$PROJECT_ROOT/.venv"
HOST="127.0.0.1"
PORT="8080"

# ---- Preflight ----
[ -d "$VENV_DIR" ] \
  || { echo "Error: virtual environment not found at $VENV_DIR" >&2; \
       echo "Run scripts/restore.sh first." >&2; exit 1; }

# shellcheck disable=SC1091
. "$VENV_DIR/bin/activate"

command -v freellmpool >/dev/null 2>&1 \
  || { echo "Error: freellmpool not installed in venv." >&2; \
       echo "Run scripts/restore.sh first." >&2; exit 1; }

if command -v lsof >/dev/null 2>&1 && lsof -iTCP:"$PORT" -sTCP:LISTEN >/dev/null 2>&1; then
  echo "Error: port $PORT is already in use." >&2
  echo "Stop the existing process first (e.g. pkill -f 'freellmpool proxy')." >&2
  exit 1
fi

# ---- Start proxy ----
echo "Starting freellmpool proxy"
echo "  Base URL : http://${HOST}:${PORT}/v1"
echo "  Health   : curl http://${HOST}:${PORT}/livez"
echo "  Dashboard: http://${HOST}:${PORT}/dashboard"
echo "  Press Ctrl+C to stop."
echo

exec freellmpool proxy --host "$HOST" --port "$PORT"