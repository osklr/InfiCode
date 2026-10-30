## Plan: InfiCode Assembly Template

InfiCode is a reproducible VS Code environment template that connects Cline to a local freellmpool OpenAI-compatible proxy. It installs or invokes third-party tools without redistributing source code, model weights, credentials, binaries, or personal configuration.

The initial release targets Linux and macOS. Windows support follows after dedicated validation.

## Directory Structure

`InfiCode/`

- `README.md` — project overview, quick start, dependencies, licenses, disclaimer, FAQ, and links.
- `QUICKSTART.md` — concise setup and first-run instructions.
- `TROUBLESHOOTING.md` — prerequisite, installation, proxy, Cline, networking, and Settings Sync issues.
- `CONTRIBUTING.md` — contribution workflow, testing, documentation, and scope rules.
- `SECURITY.md` — secret handling, privacy warnings, and vulnerability reporting.
- `LICENSE` — MIT license for InfiCode-authored material.
- `.gitignore` — excludes secrets, `.env*`, local configuration, logs, caches, and generated files.
- `.gitattributes` — consistent text and script handling.
- `scripts/`
  - `restore.sh` — Linux/macOS setup and dependency verification.
  - `start-freellmpool.sh` — Linux/macOS proxy launcher.
  - `restore.ps1` — Windows setup and dependency verification.
  - `start-freellmpool.ps1` — Windows proxy launcher.
  - `common/` — optional InfiCode-owned helpers shared by scripts.
- `.vscode/`
  - `extensions.json` — recommends Cline without bundling it.
  - `settings.json` — repository-safe settings only.
  - `tasks.json` — optional tasks for starting the proxy.
  - `README.md` — explains omitted personal settings and Settings Sync.
- `.github/`
  - `workflows/ci.yml` — shellcheck, PowerShell lint, Markdown lint, secret scanning, and structure checks.
  - `ISSUE_TEMPLATE/bug_report.yml`
  - `ISSUE_TEMPLATE/feature_request.yml`
  - `PULL_REQUEST_TEMPLATE.md`
- `docs/`
  - `architecture.md` — data flow and trust boundaries.
  - `dependency-licenses.md` — dependency sources, licenses, and installation methods.
  - `release-checklist.md` — private validation and public-release checks.

## Verified Contracts (Day 1 results)

- freellmpool `0.13.0` installs successfully on Python `3.14.8` with `python -m pip install freellmpool` inside a virtual environment. No version fallback is needed.
- Five keyless providers work out of the box: `pollinations`, `llm7`, `ovh`, `kilo`, and `opencode`.
- The verified provider pool exposes 61 models.
- Zero API keys are required for the first run.
- Verified proxy startup command:

  ```sh
  freellmpool proxy --host 127.0.0.1 --port 8080
  ```

- `GET /livez` returns `{"status": "ok"}`.
- `GET /readyz` returns JSON containing overall status, ready provider count, total provider count, and per-provider state.
- OpenAI-compatible base URL: `http://127.0.0.1:8080/v1`.
- Anthropic Messages base URL: `http://127.0.0.1:8080`.
- Dashboard: `http://127.0.0.1:8080/dashboard`.
- `freellmpool code cline` only prints setup instructions; it does not configure Cline automatically.
- The printed Cline instructions are:
  - Settings -> API Provider: `OpenAI Compatible`
  - Base URL: `http://localhost:8080/v1`
  - API Key: anything
  - Model: `auto`
- freellmpool stores user configuration, quota, and cache in `~/.config/freellmpool/`. InfiCode scripts must not modify or delete this directory.
- `freellmpool doctor` and `freellmpool models` are safe read-only diagnostics that scripts may call for verification.

### Re-verification

Future maintainers should recheck the package version, Python compatibility, provider list, model count, startup command, endpoint behavior, Cline instructions, storage path, and diagnostic commands before changing scripts or claiming compatibility.

## Phased Implementation Plan

### Phase 1: Minimum Viable Linux/macOS Release

1. Initialize Git metadata, ignore rules, MIT license, documentation, and VS Code files.
2. Record the verified freellmpool and Cline contracts.
3. Implement `restore.sh` with prerequisite checks and idempotent installation.
4. Implement `start-freellmpool.sh` with localhost binding, process handling, logs, and readiness checks.
5. Document the three-step workflow: install freellmpool, start the proxy, and configure Cline.
6. Test from clean Linux and macOS environments.
7. Repeat restore and confirm that user-level VS Code settings and `~/.config/freellmpool/` remain unchanged.

### Phase 2: Windows and Usability

1. Implement `restore.ps1` and `start-freellmpool.ps1`.
2. Add platform-specific handling for PATH, permissions, Python, pip, VS Code CLI, network access, ports, and PowerShell execution policy.
3. Improve troubleshooting, restart behavior, diagnostics, logs, and Settings Sync guidance.
4. Add CI linting, secret scanning, and repository-structure checks.

### Phase 3: Community and Future Extensions

1. Complete contributor, security, issue-template, and pull-request documentation.
2. Add automated checks for secrets, vendored artifacts, scripts, and required documentation.
3. Maintain a tested compatibility matrix for OS, Python, VS Code, freellmpool, and Cline.
4. Add future capabilities only through documented extension points.
5. Keep the core scope limited to VS Code, Cline, freellmpool, recovery scripts, and documentation.

## Script Functional Specifications

### Shared Rules

- Provide discoverable help through `--help` or PowerShell help.
- Support optional non-interactive mode and command overrides where useful.
- Report progress, versions, endpoint status, logs, and meaningful exit codes.
- Detect the operating system and validate supported platforms.
- Check Python, pip, VS Code CLI, network access, writable project directories, and freellmpool availability.
- Detect existing installations and healthy proxy processes before acting.
- Never overwrite user VS Code settings, Cline settings, shell profiles, or unrelated processes.
- Never write secrets to disk.
- Use only environment variables or ignored local files for secrets and sensitive runtime configuration.
- Never print secrets, tokens, or complete environment dumps.
- Bind the proxy to localhost by default.
- Do not modify or delete `~/.config/freellmpool/`.
- Clean up temporary files and child processes where practical.
- Return nonzero exit codes with actionable remediation messages.
- Rerunning restore must be safe.
- Rerunning start must detect an existing healthy process or report a clear conflict.

### `restore.sh`

Inputs:

- Optional non-interactive mode.
- Optional Python command override.
- Optional VS Code CLI override.
- Optional extension verification or installation mode.

Preflight checks:

- Linux or macOS.
- Python 3 and pip.
- `code --version`.
- VS Code extension installation capability.
- Network access.
- Write access to InfiCode-owned directories.

Actions:

- Verify or install freellmpool `0.13.0` or the currently verified compatible version using `python -m pip install freellmpool`.
- Print the four Cline setup instructions as user-facing output: Provider, Base URL, API Key, and Model.
- Do not auto-configure Cline.
- Do not modify `~/.config/freellmpool/`.
- Optionally call `freellmpool doctor` and `freellmpool models` for read-only verification.
- Print versions and next steps.

Failure cases:

- Missing Python, pip, or VS Code CLI.
- Unsupported platform.
- Permission failure.
- Package installation failure.
- Extension installation failure.
- Invalid upstream configuration.

### `start-freellmpool.sh`

Inputs:

- Optional foreground/background mode.
- Optional runtime directory.

Preflight checks:

- freellmpool is installed.
- Port `8080` is available, unless a healthy existing instance is detected.
- `~/.config/freellmpool/` is accessible but is not modified or deleted.

Actions:

- Start freellmpool with the verified command:

  ```sh
  freellmpool proxy --host 127.0.0.1 --port 8080
  ```

- Store PID and runtime state only in ignored local directories.
- Redirect logs to ignored local files.
- Call `GET http://127.0.0.1:8080/livez` and report the result.
- Optionally call `GET http://127.0.0.1:8080/readyz` and print the `ready_providers` count.
- Print the OpenAI-compatible base URL: `http://127.0.0.1:8080/v1`.
- Print the Anthropic Messages base URL and dashboard URL when useful.

Failure cases:

- Missing command.
- Port `8080` is occupied by an unhealthy or unrelated process.
- Startup timeout.
- `/livez` does not return a healthy response.
- Unexpected child-process termination.

### `restore.ps1`

Mirror `restore.sh` using PowerShell-native argument parsing, command discovery, `$LASTEXITCODE`, Windows paths, and safe process execution.

Do not modify the registry, user settings, shell profiles, or `~/.config/freellmpool/` equivalent configuration location.

### `start-freellmpool.ps1`

Mirror the Unix launcher with Windows process management, port checks, readiness polling, ignored runtime files, and explicit handling for existing processes.

Use the verified host, port, startup command, `/livez` health check, and optional `/readyz` provider count where supported.

Add stop scripts only if the verified upstream process behavior requires dedicated lifecycle control.

## QUICKSTART.md Outline

1. Install freellmpool in a virtual environment:

   ```sh
   python -m pip install freellmpool
   ```

2. Run `start-freellmpool.sh`.
3. Manually configure Cline using the four setup instructions printed by the script:
   - API Provider: `OpenAI Compatible`
   - Base URL: `http://localhost:8080/v1`
   - API Key: anything
   - Model: `auto`

## README Outline

1. One-line description.
2. Why InfiCode exists.
3. Three-step quick start.
4. Architecture and data flow.
5. Supported platforms and tested versions.
6. Dependencies and licenses:
   - InfiCode scripts and documentation: MIT.
   - freellmpool `0.13.0`: MIT, installed from PyPI.
   - Cline: verified marketplace/source license.
   - Python, pip, VS Code, and any additional required tools.
7. Free-tier disclaimer.
8. Privacy and security warning.
9. FAQ covering API keys, Settings Sync, missing `code`, model selection, endpoint configuration, repeated restore, and supported platforms.
10. Links to troubleshooting, contributing, and security documentation.

Required disclaimer:

> Free API availability depends on upstream provider policies. InfiCode does not guarantee permanent free or unlimited use. Users are responsible for complying with each provider’s terms.

Avoid claims such as “unlimited free” or “bypass limits.” Describe freellmpool as aggregating multiple free tiers with automatic failover.

## License Recommendation

Use MIT for InfiCode-authored scripts, documentation, configuration examples, and workflow files. MIT is permissive, familiar, concise, and suitable for reusable templates.

Do not redistribute third-party software. Reference each dependency in a license table containing its name, official source URL, verified license, installation method, and attribution requirements.

Installation commands instruct users to obtain software from upstream; they do not bundle that software. Do not copy third-party source code, notices, binaries, icons, model weights, or extension packages into the repository.

Recheck upstream licenses before every public release.

## Security and Compliance Checklist

- Confirm that no API keys, tokens, cookies, credentials, `.env` files, personal paths, usernames, machine names, or private logs are committed.
- Scan both the current working tree and Git history.
- Confirm that no third-party source code, model weights, or extension binaries are present in the repository or its Git history.
- Confirm that no generated package caches or copied Marketplace assets are present.
- Confirm that scripts call only documented installation commands.
- Confirm that scripts do not download hidden executables or modify unrelated user configuration.
- Confirm that scripts never write secrets to disk.
- Confirm that secrets are accepted only through environment variables or ignored local files.
- Confirm that the proxy binds to localhost by default.
- Confirm that the README includes dependency licenses, upstream links, privacy warnings, and the free-tier disclaimer.
- Confirm that prohibited claims such as “unlimited free” and “bypass limits” are absent.
- Configure the GitHub repository as a template repository when appropriate.
- Run shellcheck, PowerShell linting, Markdown linting, secret scanning, and structure checks.
- Validate privately from clean Linux and macOS environments before public release.
- Validate Windows before claiming Windows support.
- Test first run, repeated restore, missing prerequisites, occupied ports, network failures, invalid configuration, startup timeouts, and safe logs.
- Recheck package names, extension ID, CLI syntax, health endpoint, licenses, and provider terms before release.

## Risks and Limitations

- Free API availability, quotas, models, latency, and provider policies may change or disappear.
- Permanent or unlimited access is not guaranteed.
- InfiCode does not bypass provider limits or terms.
- Free API pools may not anonymize, redact, or prevent retention of submitted code.
- Do not send secrets, proprietary code, regulated data, or sensitive personal information to free API pools.
- Cline and freellmpool behavior depends on upstream versions and selected providers.
- Agent performance varies by model, context limit, tool-calling support, and provider reliability.
- Failover can produce inconsistent results.
- Settings Sync restores selected VS Code state; it is not a complete machine backup.
- Network, authentication, regional availability, firewall, and permission issues may prevent setup or runtime.
- Phase 1 supports Linux/macOS only until Windows validation is complete.
- Unsupported architectures and older tool versions must be listed explicitly.

## Assumptions

- freellmpool `0.13.0` installs successfully on Python `3.14.8` using `python -m pip install freellmpool` in a virtual environment; this was verified on Day 1.
- The keyless provider set and 61 available models were verified on Day 1 and may change with upstream releases.
- The proxy command, ports, endpoints, dashboard, and OpenAI-compatible base URL were verified on Day 1.
- Cline requires manual configuration using the four printed instructions; automatic configuration is not supported by `freellmpool code cline`.
- freellmpool owns `~/.config/freellmpool/` for user configuration, quota, and cache; scripts must not modify or delete it.
- `freellmpool doctor` and `freellmpool models` are read-only diagnostics; this was verified on Day 1.
- Users obtain VS Code, Python, pip, Cline, and freellmpool from upstream.
- Settings Sync remains user-controlled; scripts do not enable or upload it.
- “Zero-cost” describes the intended software path, not guaranteed provider availability, hardware, bandwidth, or future pricing.

## Scope Boundaries

Included:

- VS Code.
- Cline.
- freellmpool.
- Restore and start workflows.
- Documentation.
- License references.
- Security checks.
- Optional CI validation.

Excluded:

- Building a new IDE.
- Implementing an AI agent.
- Redistributing third-party software or models.
- Managing provider accounts.
- Guaranteeing free capacity.
- Automatically uploading settings.
- Storing credentials.
- Circumventing provider limits or terms.

## Verification

1. Verify the freellmpool and Cline contracts using the Verified Contracts section.
2. Run shellcheck, PowerShell lint, Markdown lint, and secret scans.
3. Execute restore on clean Linux and macOS environments.
4. Repeat restore and confirm no duplicate installations or user-setting overwrites.
5. Start freellmpool and confirm `/livez` readiness on localhost.
6. Configure Cline and perform a minimal non-sensitive coding request.
7. Exercise documented failure cases.
8. Verify exit codes, remediation messages, and secret-free logs.
9. Validate Windows before advertising Windows support.