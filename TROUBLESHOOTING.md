# Troubleshooting

## `no candidate (provider, model) matched the given filters`
**Cause:** Cline is rejecting the request because it doesn't know the model's capabilities, or it is asking for a context window larger than the free providers allow.
**Fix:** Ensure you are using a specific Model ID (not `auto` or `agent`) and manually set the limits in Cline:
- **Model ID:** `pollinations/openai-fast`
- **Context Window:** `32000`
- **Max Output Tokens:** `4096`

## `zsh: command not found: code`
**Cause:** The VS Code CLI is not installed on macOS.
**Fix:** Open VS Code, press `Cmd + Shift + P`, type `Shell Command: Install 'code' command in PATH`, and press Enter. Restart your terminal.

## Port 8080 is already in use
**Cause:** Another process (or an old freellmpool proxy) is running on the default port.
**Fix:** Find and stop the process:
```sh
lsof -iTCP:8080 -sTCP:LISTEN
kill -9 <PID>
```
Or change the `PORT` variable inside `scripts/start-freellmpool.sh`.

## `freellmpool` command not found
**Cause:** The virtual environment is not activated, or `restore.sh` failed.
**Fix:** Run the proxy script directly (`./scripts/start-freellmpool.sh`). It automatically activates the `.venv`. If that fails, delete the `.venv` folder and run `./scripts/restore.sh` again.

## PowerShell says "running scripts is disabled on this system"
**Cause:** Windows blocks executing `.ps1` scripts by default for security.
**Fix:** You need to bypass the execution policy for your current terminal session only. Run this command before running the scripts:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```