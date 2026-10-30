# Troubleshooting

## `no candidate (provider, model) matched the given filters`
**Cause:** Cline is rejecting the request because it doesn't know the model's capabilities, or it is asking for a context window larger than the free providers allow.
**Fix:** Ensure you are using a specific Model ID (not `auto` or `agent`) and manually set the limits in Cline:
- **Model ID:** `kilo/poolside/laguna-s-2.1:free`
- **Context Window:** `262144`
- **Max Output Tokens:** `32768`

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

## Cline gets stuck in a recursive loop trying to create a file
**Cause:** Sometimes, AI models try to use Linux/Bash terminal commands (like `cat > file.txt` or `python -c`) to create files. This fails on Windows PowerShell, causing Cline to repeat the same failing command in a loop.
**Fix:** 
1. Click the red **Stop** button in Cline to cancel the task.
2. Click **New Task** to start fresh.
3. This repository includes a `.clinerules` file which tells Cline to use its native file tools instead of the terminal. Ensure this file is in your project root.
4. Keep **"Execute commands"** unchecked in Cline's Auto-approve settings to prevent runaway terminal commands.

## `ReadTimeout: The read operation timed out` or `all providers exhausted`
**Cause:** The free model is trying to generate too much code in one response, and Cline's internal timeout (or the provider's connection limit) cuts it off.
**Fix:**
1. Stop the task, click **New Task (`+`)**.
2. Split your request: ask for ONE file per message (e.g., "Create `dcf_engine.py` first. Do not create `app.py` yet.").
3. The `.clinerules` file enforces one-file-per-response automatically, which prevents this error from happening in the first place.

## Cline gets stuck in a loop running `dir` or `ls` repeatedly
**Cause:** On some Windows setups, Cline's terminal shell integration fails to capture command output. The AI thinks the command failed and keeps retrying. It also happens when the AI uses Linux commands (`ls`, `cat`) on Windows PowerShell.
**Fix:**
1. Click the red **Stop** button in Cline.
2. Click **New Task** to start fresh.
3. This repository includes a `.clinerules` file that forbids using terminal commands for file exploration. Ensure the file is present in the project root.
4. If shell integration keeps failing, open VS Code settings and disable `terminal.integrated.shellIntegration.enabled`, then reload VS Code.