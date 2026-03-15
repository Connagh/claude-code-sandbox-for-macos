# Claude Code Sandbox for macOS

![Claude Code Sandbox](https://i.imgur.com/Wk2S8ym.jpeg)

Claude Code has access to your system by default. There's no OS-level protection, so if a prompt injection tricks Claude into approving something, nothing stops it.

This tool wraps Claude Code in an OS-level sandbox using Apple's built-in `sandbox-exec`. Claude can **only** access the project folder you're working in. Everything else is blocked by macOS itself. Run `claude-sandbox claude` instead of `claude`.

**Requirements:** macOS. Claude Code CLI installed.

## Quick Start

```bash
# copy and paste this entire block into your terminal

# download
git clone https://github.com/Connagh/claude-code-sandbox-for-macos
cd claude-code-sandbox-for-macos

# install
chmod +x claude-sandbox install.sh
./install.sh

# add to PATH (only if not already there)
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc || echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

Then from any project folder:

```bash
cd ~/my-project
claude-sandbox claude
```

<details>
<summary><strong>Test It Works</strong></summary>

```bash
claude-sandbox bash

cat ~/.ssh/id_rsa       # should say "Operation not permitted"
cat ~/.zshrc            # should say "Operation not permitted"
ls ~/Documents          # should say "Operation not permitted"
ls .                    # should work, this is your project folder
exit
```

</details>

<details>
<summary><strong>What It Allows</strong></summary>

- Your current project folder, full read and write
- System files (`/usr`, `/bin`, `/etc`, `/System`, etc.)
- Git config (`~/.gitconfig`, `~/.config/git`)
- Claude's config and caches (`~/.claude`, `~/.cache`)
- Temp files (`/tmp`, `/var/folders`)
- Keychain access for `claude login`
- Network access (required for the API)

</details>

<details>
<summary><strong>What It Blocks</strong></summary>

Everything else in your home folder. SSH keys, shell history, `.env` files, other projects, Documents, Desktop, Downloads, and anything not listed above.

</details>

<details>
<summary><strong>Options</strong></summary>

```bash
claude-sandbox -d ~/projects/myapp claude   # use a specific project folder
claude-sandbox -r ~/shared-libs claude      # grant read access to an extra folder
claude-sandbox -o debug.sb claude           # save the generated profile for inspection
claude-sandbox bash                         # open a plain shell inside the sandbox
```

</details>

<details>
<summary><strong>Customising the Rules</strong></summary>

Edit `~/.local/share/claude-code-sandbox-for-macos/profile.sb` to add extra folders, then relaunch `claude-sandbox`.

For one-off access without editing the profile:

```bash
claude-sandbox -r ~/some-other-folder claude
```

### Seeing What's Being Blocked

```bash
log stream --predicate 'eventMessage contains "deny"' --style compact | grep -i claude
```

</details>

<details>
<summary><strong>How It Works</strong></summary>

The script combines rules from `profile.sb` with your project folder and passes them to `sandbox-exec`. macOS enforces these rules at the OS level. Claude cannot access anything outside the allowed paths.

</details>

<details>
<summary><strong>Limitations</strong></summary>

- **macOS only.** Uses Apple's `sandbox-exec`
- **No nested sandboxes.** A macOS limitation
- **Network is unrestricted.** Required for API access
- **Symlinks.** A malicious repo could include a symlink pointing outside the sandbox

</details>

<details>
<summary><strong>Uninstall</strong></summary>

```bash
rm -f ~/.local/bin/claude-sandbox
rm -rf ~/.local/share/claude-code-sandbox-for-macos
rm -rf ~/.config/claude-code-sandbox-for-macos
```

Your projects are not touched.

</details>

## License

MIT
