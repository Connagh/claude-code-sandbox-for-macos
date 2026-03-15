#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
echo "Removing claude-code-sandbox-for-macos..."
rm -f "$PREFIX/bin/cc-sandbox"
rm -rf "$PREFIX/share/claude-code-sandbox-for-macos"
rm -rf "$HOME/.config/claude-code-sandbox-for-macos"
echo "Done."
