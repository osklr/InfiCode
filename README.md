# InfiCode

InfiCode is a reproducible VS Code environment template that connects Cline to a local freellmpool OpenAI-compatible proxy using free provider tiers.

## Why InfiCode?
- **Zero-Cost:** Aggregates multiple free LLM providers with automatic failover.
- **No Lock-in:** No API keys required to start. No Cursor or Copilot subscription needed.
- **Reproducible:** A single script sets up the entire local environment in seconds.

## Quick Start

1. **Clone and restore:**
   ```sh
   git clone https://github.com/osklr/InfiCode.git
   cd InfiCode
   ./scripts/restore.sh
   ```

2. **Start the proxy:**
   ```sh
   ./scripts/start-freellmpool.sh
   ```

3. **Configure Cline:**
   Open VS Code, go to Cline settings (gear icon), and set:
   - **API Provider:** `OpenAI Compatible`
   - **Base URL:** `http://localhost:8080/v1`
   - **API Key:** `anything`
   - **Model ID:** `pollinations/openai-fast`
   - **Context Window:** `32000`
   - **Max Output Tokens:** `4096`
   - **Supports Images:** `OFF`
   - **Supports Computer Use:** `ON`

## Dependencies & Licenses
This project is an assembly template. It does not redistribute third-party code.
- [freellmpool](https://github.com/0xzr/freellmpool) — MIT License
- [Cline](https://github.com/cline/cline) — Apache-2.0 License
- VS Code — Proprietary (Microsoft)

## Disclaimer
Free API availability depends on upstream provider policies. InfiCode does not guarantee permanent free or unlimited use. Users are responsible for complying with each provider's terms. Do not send sensitive or proprietary code to free API pools.