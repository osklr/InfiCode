# Security Policy

## Supported Versions
Only the latest `main` branch is supported with security updates.

## Reporting a Vulnerability
Please do not report security vulnerabilities through public GitHub issues.
Instead, please open a private security advisory on GitHub or contact the maintainers directly.

## API Key & Privacy Warning
InfiCode does not provide privacy anonymization. The local freellmpool proxy routes your code to free third-party LLM providers. 
- **Do not use** InfiCode with sensitive credentials, proprietary code, or regulated data.
- **Never** commit your `.env` files or API keys to this repository. The CI pipeline includes Gitleaks to automatically block any accidental secret commits.