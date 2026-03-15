#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"
SHARE_DIR="$PREFIX/share/claude-code-sandbox-for-macos"

mkdir -p "$BIN_DIR" "$SHARE_DIR"
cp profile.sb "$SHARE_DIR/profile.sb"

sed "s|SCRIPT_DIR=.*|SCRIPT_DIR=\"$SHARE_DIR\"|" cc-sandbox > "$BIN_DIR/cc-sandbox"
chmod +x "$BIN_DIR/cc-sandbox"

echo "Installed to $BIN_DIR/cc-sandbox"
echo "Profile at $SHARE_DIR/profile.sb"

# ---- install .app to /Applications ----
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_SRC="${SCRIPT_DIR}/Claude Code Sandbox.app"
APP_DEST="/Applications/Claude Code Sandbox.app"

if [[ -d "$APP_SRC" ]]; then
  rm -rf "$APP_DEST"
  cp -R "$APP_SRC" "$APP_DEST"
  chmod +x "$APP_DEST/Contents/MacOS/launch"
  xattr -dr com.apple.quarantine "$APP_DEST" 2>/dev/null || true
  echo "App installed to /Applications/Claude Code Sandbox.app"
fi

echo ""
echo "Make sure $BIN_DIR is in your PATH, then run:"
echo "  cc-sandbox claude"
echo ""
echo "Or open \"Claude Code Sandbox\" from Launchpad / Spotlight / Dock."
