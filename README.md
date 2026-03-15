# Claude Code Sandbox for macOS

Claude Code has access to your filesystem by default. It has its own permission system that asks before running commands, but those guardrails live inside Claude itself. If a prompt injection were to bypass them, there's no second layer to fall back on.

This tool adds that second layer, at the operating system level, using Apple's built-in sandbox. Even if Claude is tricked, macOS itself blocks the access. It wraps Claude Code so it can **only** reach the project folder you're working in. Everything else on your system is off limits. You use it by running `cc-seatbelt claude` instead of `claude`, that's it.

**Requirements:** macOS only. Uses Apple's built-in `sandbox-exec`.

## Quick Start

```bash
git clone https://github.com/Connagh/claude-code-sandbox-for-macos
cd claude-code-sandbox-for-macos
chmod +x cc-seatbelt install.sh uninstall.sh
```

You can run it straight away:

```bash
./cc-seatbelt claude
```

Or install it so the `cc-seatbelt` command works from any folder:

```bash
./install.sh
```

If your terminal doesn't recognise `cc-seatbelt` after installing, add this line to your `~/.zshrc` and restart your terminal:

```bash
export PATH="$HOME/.local/bin:$PATH"
```

Then from any project folder:

```bash
cd ~/my-project
cc-seatbelt claude
```

## Test It Works

Open a sandboxed shell to check that files outside your project are blocked:

```bash
cc-seatbelt bash

cat ~/.ssh/id_rsa       # should say "Operation not permitted"
cat ~/.zshrc            # should say "Operation not permitted"
ls ~/Documents          # should say "Operation not permitted"
ls .                    # should work — this is your project folder
exit
```

You can also launch Claude Code sandboxed and ask it to run `cat ~/.zshrc` — it should fail.

## What It Allows

- Your current project folder — full read and write access
- System files that programs need to run (`/usr`, `/bin`, `/etc`, `/System`, etc.)
- Git config (`~/.gitconfig`, `~/.config/git`)
- Claude's own config and caches (`~/.claude`, `~/.cache`)
- Temp files (`/tmp`, `/var/folders`)
- Keychain access so `claude login` works
- Full network access (Claude needs this to talk to the API)

## What It Blocks

Everything else in your home folder — SSH keys, shell history, `.env` files, other projects, Documents, Desktop, Downloads, and anything not listed above.

<details>
<summary><strong>Options</strong></summary>

Most of the time you just need `cc-seatbelt claude`. But if you need more control:

```bash
# Work in a specific project folder instead of the current one
cc-seatbelt -d ~/projects/myapp claude

# Give Claude read access to an extra folder (e.g. shared libraries)
cc-seatbelt -r ~/shared-libs claude

# Save the generated sandbox profile to a file so you can inspect it
cc-seatbelt -o debug.sb claude

# Open a plain shell inside the sandbox to poke around
cc-seatbelt bash
```

</details>

<details>
<summary><strong>Customising the Rules</strong></summary>

If Claude Code needs access to an additional folder, edit `profile.sb` in the repo to add it, then re-run `./install.sh`.

You can also grant one-off read access without editing the profile using the `-r` flag:

```bash
cc-seatbelt -r ~/some-other-folder claude
```

### Seeing What's Being Blocked

If something isn't working and you think the sandbox might be blocking it, you can watch the deny log in a second terminal:

```bash
log stream --predicate 'eventMessage contains "deny"' --style compact | grep -i claude
```

Or open Console.app and filter by `sandbox`.

</details>

<details>
<summary><strong>How It Works</strong></summary>

The `cc-seatbelt` script takes the sandbox rules from `profile.sb`, combines them with the folder you're working in, and hands everything to macOS's `sandbox-exec`. From that point on, the operating system enforces the rules — Claude Code literally cannot access files outside the allowed paths, regardless of what it tries to do.

</details>

<details>
<summary><strong>Limitations</strong></summary>

- **macOS only** — uses Apple's `sandbox-exec`
- **No nested sandboxes** — a macOS limitation, not ours
- **Network is unrestricted** — Claude needs internet access to work, so network requests aren't blocked
- **Symlinks** — a malicious repo could include a symlink that points outside the sandbox

</details>

## Uninstall

```bash
./uninstall.sh
```

This removes the `cc-seatbelt` command and its config. Your projects are not touched.

## License

MIT
