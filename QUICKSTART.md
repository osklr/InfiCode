# Quick Start

Follow these steps to get InfiCode running on your machine.

## Prerequisites
- macOS or Linux (Windows support is coming in Phase 2)
- Python 3.10 or newer
- Visual Studio Code
- The [Cline extension](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) installed in VS Code

## Step 1: Setup the environment
Run the restore script. This will create a local virtual environment and install the freellmpool proxy.

```sh
./scripts/restore.sh
```

## Step 2: Start the proxy
Start the local OpenAI-compatible proxy. Keep this terminal running.

```sh
./scripts/start-freellmpool.sh
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