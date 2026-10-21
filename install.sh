#!/usr/bin/env bash
set -e

# ClaudeM Installer
# GitHub: https://github.com/Pikaswelt/claudem

REPO_URL="https://raw.githubusercontent.com/Pikaswelt/claudem/main/claudem"

BOLD="\033[1m"
GREEN="\033[32m"
CYAN="\033[36m"
YELLOW="\033[33m"
RED="\033[31m"
RESET="\033[0m"

echo -e "${BOLD}${CYAN}⚡ Installing ClaudeM (Claude Code Session Manager)...${RESET}"

# Check Python 3
if ! command -v python3 >/dev/null 2>&1; then
    echo -e "${RED}Error: Python 3 is required but not installed.${RESET}"
    exit 1
fi

# Check tmux
if ! command -v tmux >/dev/null 2>&1; then
    echo -e "${YELLOW}Warning: tmux is not installed. ClaudeM requires tmux for persistent sessions.${RESET}"
    if command -v apt-get >/dev/null 2>&1; then
        echo -e "You can install it with: ${BOLD}sudo apt-get install tmux -y${RESET}"
    elif command -v dnf >/dev/null 2>&1; then
        echo -e "You can install it with: ${BOLD}sudo dnf install tmux -y${RESET}"
    elif command -v pacman >/dev/null 2>&1; then
        echo -e "You can install it with: ${BOLD}sudo pacman -S tmux --noconfirm${RESET}"
    elif command -v brew >/dev/null 2>&1; then
        echo -e "You can install it with: ${BOLD}brew install tmux${RESET}"
    fi
fi

# Check Claude Code
if ! command -v claude >/dev/null 2>&1 && [ ! -f "$HOME/.local/bin/claude" ]; then
    echo -e "${YELLOW}Notice: 'claude' CLI was not found in PATH or ~/.local/bin/claude.${RESET}"
    echo -e "Make sure Claude Code is installed: ${BOLD}npm install -g @anthropic-ai/claude-code${RESET}"
fi

# Determine install location
if [ -w "/usr/local/bin" ]; then
    INSTALL_DIR="/usr/local/bin"
elif command -v sudo >/dev/null 2>&1 && [ "$(id -u)" -eq 0 ]; then
    INSTALL_DIR="/usr/local/bin"
else
    INSTALL_DIR="$HOME/.local/bin"
    mkdir -p "$INSTALL_DIR"
fi

TARGET="$INSTALL_DIR/claudem"
TARGET_LINK="$INSTALL_DIR/ClaudeM"

# If installing locally from repo clone:
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd)"
if [ -f "$SCRIPT_DIR/claudem" ]; then
    cp "$SCRIPT_DIR/claudem" "$TARGET"
else
    if command -v curl >/dev/null 2>&1; then
        curl -fsSL "$REPO_URL" -o "$TARGET"
    elif command -v wget >/dev/null 2>&1; then
        wget -qO "$TARGET" "$REPO_URL"
    else
        echo -e "${RED}Error: Neither curl nor wget is available.${RESET}"
        exit 1
    fi
fi

chmod +x "$TARGET"
ln -sf "$TARGET" "$TARGET_LINK"

echo -e "\n${BOLD}${GREEN}✓ ClaudeM successfully installed to ${TARGET}!${RESET}"
echo -e "Symlink created: ${CYAN}${TARGET_LINK}${RESET}"

# Verify PATH
case ":$PATH:" in
    *":$INSTALL_DIR:"*) ;;
    *)
        echo -e "\n${YELLOW}Note:${RESET} $INSTALL_DIR is not in your PATH."
        echo -e "Add it to your shell profile (~/.bashrc or ~/.zshrc):"
        echo -e "  export PATH=\"\$PATH:$INSTALL_DIR\""
        ;;
esac

echo -e "\n${BOLD}Quick Start:${RESET}"
echo -e "  ${GREEN}claudem start${RESET}       # Launch a persistent Claude Code session (12h TTL)"
echo -e "  ${GREEN}claudem list${RESET}        # List active sessions & remaining time"
echo -e "  ${GREEN}claudem attach 1${RESET}    # Connect to session #1"
echo -e "  ${GREEN}claudem help${RESET}        # View all commands\n"
