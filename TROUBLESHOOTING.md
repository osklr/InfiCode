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
**Cause:** The free model is generating too much code at once, and either Cline's internal timeout or the provider's connection limit cuts it off mid-generation.
**Fix:**
1. Click the red **Stop** button, then **New Task (`+`)**.
2. The `.clinerules` Rule 4 (skeleton strategy) already splits large files into small `replace_in_file` chunks to prevent this. If it still happens, the model may be ignoring the rule.
3. If the model keeps timing out, switch to a more capable free model (e.g., from your `freellmpool models` list) or reduce the scope of your request.

## Cline gets stuck in a loop running `dir` or `ls` repeatedly
**Cause:** On some Windows setups, Cline's terminal shell integration fails to capture command output. The AI thinks the command failed and keeps retrying. It also happens when the AI uses Linux commands (`ls`, `cat`) on Windows PowerShell.
**Fix:**
1. Click the red **Stop** button in Cline.
2. Click **New Task** to start fresh.
3. This repository includes a `.clinerules` file (Rule 0 and Rule 1) that forbids using terminal commands for file exploration. Ensure the file is present in the project root.
4. If shell integration keeps failing, open VS Code settings and disable `terminal.integrated.shellIntegration.enabled`, then reload VS Code.

## Cline says `AI_NoSuchToolError: Model tried to call unavailable tool 'editor'`
**Cause:** Some Cline versions do not expose `write_to_file`/`replace_in_file` tools in every mode. The AI, trying to edit a file, searches for a plausible tool name, fails, and falls back to `python -c`, which then breaks on Windows PowerShell (especially with `&`, `|`, `>` characters).
**Fix:**
1. Click the red **Stop** button.
2. Open VS Code settings -> Cline -> ensure the assistant is in **Act/Agent mode** (not Ask mode), which enables file-editing tools.
3. Start a **New Task** so the AI re-reads `.clinerules`.
4. The `.clinerules` Rule 8 now instructs the AI to use a **base64-encoded Python write command** as a shell-safe fallback when native file tools are truly unavailable. Users do not need to edit files manually.

## PowerShell `AmpersandNotAllowed` error when running `python -c`
**Cause:** PowerShell treats `&` as the "call operator," so any string containing `&` (like `"D&A"`) inside a `python -c "..."` command will fail to parse.
**Fix:**
1. `.clinerules` Rule 6 now forbids embedding `&`, `|`, `>`, `<` inside terminal strings.
2. `.clinerules` Rule 8 provides a **base64 fallback** that avoids these characters entirely when native file tools are unavailable.
3. If you must use `python -c` manually, escape the `&` as backtick-ampersand or wrap the entire argument in single quotes.