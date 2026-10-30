# Quick Start

Follow these steps to get InfiCode running on your machine.

## Prerequisites
- **macOS, Linux, or Windows**
- Python 3.10 or newer
- [Visual Studio Code](https://code.visualstudio.com/)
- The [Cline extension](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) installed in VS Code

## Step 1: Setup the environment
Run the restore script. This will create a local virtual environment and install the freellmpool proxy.

**macOS / Linux:**
```sh
./scripts/restore.sh
```

**Windows (PowerShell):**
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
.\scripts\restore.ps1
```

## Step 2: Start the proxy
Start the local OpenAI-compatible proxy. Keep this terminal running.

**macOS / Linux:**
```sh
./scripts/start-freellmpool.sh
```

**Windows (PowerShell):**
```powershell
.\scripts\start-freellmpool.ps1
```

## Step 3: Configure Cline
Open VS Code, go to the Cline settings (gear icon), and set the following:

- **API Provider:** `OpenAI Compatible`
- **Base URL:** `http://localhost:8080/v1`
- **API Key:** `anything` (this is ignored by the local proxy)
- **Model ID:** `pollinations/openai-fast`
- **Context Window:** `32000`
- **Max Output Tokens:** `4096`
- **Supports Images:** `OFF`
- **Supports Computer Use:** `ON`

## Step 4: Test it
In the Cline chat box, type:
> Say hello in one sentence and list three programming languages.

If you see a reply, your zero-cost AI coding environment is ready!