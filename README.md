# InfiCode

InfiCode is a reproducible VS Code environment template that connects Cline to a local freellmpool OpenAI-compatible proxy using free provider tiers.

## Why InfiCode?
- **Zero-Cost:** Aggregates multiple free LLM providers with automatic failover.
- **No Lock-in:** No API keys required to start. No Cursor or Copilot subscription needed.
- **Reproducible:** A single script sets up the entire local environment in seconds.

## Prerequisites
- **macOS, Linux, or Windows**
- Python 3.10 or newer
- [Visual Studio Code](https://code.visualstudio.com/)
- The [Cline extension](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) installed in VS Code

## Quick Start

1. **Clone and restore:**
   **macOS / Linux:**
   ```sh
   git clone https://github.com/osklr/InfiCode.git
   cd InfiCode
   ./scripts/restore.sh
   ```
   **Windows (PowerShell):**
   ```powershell
   git clone https://github.com/osklr/InfiCode.git
   cd InfiCode
   Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
   .\scripts\restore.ps1
   ```

2. **Start the proxy:**
   **macOS / Linux:**
   ```sh
   ./scripts/start-freellmpool.sh
   ```
   **Windows (PowerShell):**
   ```powershell
   .\scripts\start-freellmpool.ps1
   ```

3. **Configure Cline:**
   Open VS Code, go to Cline settings (gear icon), and set:
   - **API Provider:** `OpenAI Compatible`
   - **Base URL:** `http://localhost:8080/v1`
   - **API Key:** `anything`
   - **Model ID:** `kilo/poolside/laguna-s-2.1:free`
   - **Context Window:** `262144`
   - **Max Output Tokens:** `32768`
   - **Supports Images:** `OFF`
   - **Supports Computer Use:** `ON`

## Dependencies & Licenses
This project is an assembly template. It does not redistribute third-party code.
- [freellmpool](https://github.com/0xzr/freellmpool) — MIT License
- [Cline](https://github.com/cline/cline) — Apache-2.0 License
- VS Code — Proprietary (Microsoft)

## Disclaimer
Free API availability depends on upstream provider policies. InfiCode does not guarantee permanent free or unlimited use. Users are responsible for complying with each provider's terms. Do not send sensitive or proprietary code to free API pools.

## Contributing
Contributions are welcome! Please see [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.