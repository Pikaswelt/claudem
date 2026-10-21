# ⚡ ClaudeM — Claude Code Persistent Session Manager

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Python: 3.6+](https://img.shields.io/badge/python-3.6+-brightgreen.svg)](https://www.python.org/)
[![Tmux](https://img.shields.io/badge/tmux-required-orange.svg)](https://github.com/tmux/tmux)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-ready-purple.svg)](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview)

A lightweight CLI session manager designed for [Claude Code](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code/overview) on Linux and remote servers.

Run background Claude Code instances that survive SSH disconnects, automatically handle permissions, bypass trust prompts, and auto-expire safely via configurable TTL.

---

## 🚀 Key Features

- 🔄 **Persistent Background Sessions:** Runs in dedicated `tmux` sessions. If your SSH connection drops or terminal closes, Claude Code keeps working uninterrupted.
- ⚡ **Autonomous Execution (No-Permission Mode):** Launches Claude Code with `--dangerously-skip-permissions` and handles root-user sandbox checks (`IS_SANDBOX=1`).
- 🛡️ **Auto-Trust Workspace:** Automatically registers the target directory in `~/.claude.json` (`hasTrustDialogAccepted: true`) to eliminate blocking trust dialogs.
- ⏳ **TTL & Auto-Cleanup:** Each session has a customizable Time-To-Live (default: 12 hours) with automatic cleanup when expired.
- ⏱️ **Instant Session Renewal:** Extend session runtimes on the fly (`claudem renew <id> 24`).
- 📋 **Live Status Overview:** Clean terminal dashboard displaying all running sessions, remaining time, expiration timestamps, and target directories.
- 📜 **Log Peeking:** Check on an agent's progress without attaching to the session (`claudem logs <id>`).

---

## 📦 Installation

### Quick Install (One-Liner)

```bash
curl -fsSL https://raw.githubusercontent.com/Pikaswelt/claudem/main/install.sh | bash
```

### Manual Installation

Clone the repository and link the binary:

```bash
git clone https://github.com/Pikaswelt/claudem.git
cd claudem
sudo ./install.sh
```

Both `claudem` and `ClaudeM` aliases will be available globally in your PATH.

---

## 🛠️ Requirements

- **Linux** (or macOS)
- **Python 3.6+**
- **tmux** (`sudo apt install tmux` or `sudo dnf install tmux`)
- **Claude Code CLI** (`npm install -g @anthropic-ai/claude-code`)

---

## 📖 Usage & Commands

```
⚡ ClaudeM — Claude Code Session Manager ⚡

COMMANDS:
  claudem start [path] [--hours H]   Start a new Claude Code session
  claudem list                       List all active sessions & remaining time
  claudem attach <id>                Attach to a session (or just 'claudem attach')
  claudem renew <id> [hours]         Extend session lifetime (default: +12h)
  claudem logs <id> [lines]          View recent session output without attaching
  claudem stop <id>                  Terminate a session and free resources
  claudem cleanup                    Prune dead or expired sessions
  claudem help                       Show help and options
```

### 1. Start a Session

Start in current directory (12-hour default lifetime):
```bash
claudem start
```

Start in a specific directory with a custom duration (e.g., 24 hours):
```bash
claudem start /var/www/my-app --hours 24
```

### 2. View Active Sessions

```bash
claudem list
```

Output:
```text
⚡ Aktive ClaudeM Sitzungen (2) ⚡
══════════════════════════════════════════════════════════════════════════════════════
Nr   Status     Restzeit           Ablaufzeit           Pfad / Befehl
──────────────────────────────────────────────────────────────────────────────────────
#1   Aktiv      11h 48m 12s        2026-10-22 01:35     /root
     ↳ Beitreten mit: ClaudeM attach 1  | Verlängern: ClaudeM renew 1
──────────────────────────────────────────────────────────────────────────────────────
#2   Aktiv      23h 59m 50s        2026-10-22 13:45     /var/www/my-app
     ↳ Beitreten mit: ClaudeM attach 2  | Verlängern: ClaudeM renew 2
──────────────────────────────────────────────────────────────────────────────────────
```

### 3. Attach & Detach

Join the interactive terminal:
```bash
claudem attach 1
```

> **How to detach without killing the session:**
> Press `Ctrl + B`, then press `D`.
> Claude Code will continue running smoothly in the background!

### 4. Extend a Session (Renew)

Add 12 hours (default) or any number of hours:
```bash
claudem renew 1
claudem renew 1 24   # Add 24 hours
```

### 5. Check Output without Attaching

```bash
claudem logs 1 50    # Print last 50 lines
```

### 6. Stop a Session

```bash
claudem stop 1
```

---

## 🔒 Security Disclaimer

ClaudeM starts Claude Code with `--dangerously-skip-permissions` to allow headless, autonomous problem solving without manual confirmation prompts for file edits and commands.

> **Warning:** Only run ClaudeM in trusted environments, isolated virtual machines, or developer containers. Ensure sensitive credentials or production files are not exposed to unrestricted actions.

---

## 📄 License

Distributed under the [MIT License](LICENSE).

Created by [Pikaswelt](https://github.com/Pikaswelt).
