# Contributing to InfiCode

First off, thanks for taking the time to contribute!

## How to Contribute
1. Fork the repository.
2. Create a new branch (`git checkout -b feature/your-feature`).
3. Make your changes.
4. Ensure your shell scripts pass ShellCheck and do not contain secrets.
5. Commit your changes (`git commit -m 'Add some feature'`).
6. Push to the branch (`git push origin feature/your-feature`).
7. Open a Pull Request.

## Code Style
- Keep shell scripts POSIX-compliant where possible.
- Use `set -euo pipefail` in all bash scripts.
- Update documentation (`README.md`, `QUICKSTART.md`) if you change behavior.