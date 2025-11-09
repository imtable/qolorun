#!/usr/bin/env bash

# =============================================================================
# qolorun.sh — Smart CLI Runner with Colorized Output
# Author: imtable
# Version: 0.2.1
# Created: October 2025
# Location: Dublin / Kyiv
# License: MIT
# =============================================================================

# 🏷️ Constants
VERSION="0.2.1"
AUTHOR_INFO="Created by imtable — Dublin/Kyiv, 2025"
INSTALL_DIR="$HOME/bin"
CACHE_DIR="$HOME/.qr-cache"

# 🎨 Color codes
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BROWN="\033[0;33m"
MAGENTA="\033[1;35m"
GRAY="\033[1;90m"
RESET="\033[0m"

# 🛠 Utility functions
cecho() { local color="$1"; shift; echo -e "${color}$*${RESET}"; }
get_shell_config() { [ -n "$ZSH_VERSION" ] && echo "$HOME/.zshenv" || ([ -n "$BASH_VERSION" ] && echo "$HOME/.bash_profile" || echo "$HOME/.profile"); }
color_line() {
    local line="$1"
    if [[ "$line" =~ ([Ee]rror|[Ee]xception|Traceback|fail|FAIL|undefined|not\ found) ]]; then cecho $RED "$line"
    elif [[ "$line" =~ ([Ww]arning|deprecated|caution) ]]; then cecho $YELLOW "$line"
    elif [[ "$line" =~ ([Ss]uccess|done|passed|✓|BUILD\ SUCCESSFUL|OK) ]]; then cecho $GREEN "$line"
    else cecho $BROWN "$line"; fi
}

# 📌 Header
cecho $MAGENTA "\n========== Running: $* =========="

# Start timer
START_TIME=$(date +%s.%N)

# 🛑 Help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "\n\033[1;36mqolorun — smart command runner with optional colorized output\033[0m"
    echo -e "\nNote: 'qr' is a shortcut for 'qolorun' for quick access."
    echo -e "\nUsage:"
    echo -e "\033[1;33m▶ qolorun [--interactive|-i] <command> [args...]\033[0m"
    echo "    run in interactive mode"
    echo -e "\033[1;33m▶ qolorun [--plain|-p] <command> [args...]\033[0m"
    echo "    force colorized output"
    echo -e "\033[1;33m▶ qolorun <command> [args...]\033[0m"
    echo "    auto-detect input behavior"
    echo -e "\033[1;33m▶ qolorun --uninstall\033[0m"
    echo "    uninstall qolorun and remove from PATH"
    echo -e "\033[1;33m▶ qolorun --version|-v\033[0m"
    echo "    show version and author"
    echo -e "\033[1;33m▶ qolorun --update\033[0m"
    echo "    update qolorun from GitHub"
    echo -e "\033[1;33m▶ qolorun --help|-h\033[0m"
    echo "    show this help"
    echo ""
    exit 0
fi

# 🧾 Version
if [[ "$1" == "--version" || "$1" == "-v" ]]; then
    cecho $BROWN "qolorun.sh version $VERSION"
    cecho $GRAY "$AUTHOR_INFO"
    exit 0
fi

# 🟤 Update
if [[ "$1" == "--update" ]]; then
    mkdir -p "$INSTALL_DIR"
    repo_url="https://github.com/imtable/qolorun.git"
    cecho $BROWN "Checking for updates..."
    local_version=$([[ -f "$INSTALL_DIR/qolorun" ]] && "$INSTALL_DIR/qolorun" --version | grep -oE '[0-9]+\.[0-9]+' || echo "0.0")
    cecho $BROWN "Local version: $local_version"
    remote_version=$(git ls-remote --tags "$repo_url" 2>/dev/null | awk -F'/' '{print $3}' | sort -V | tail -n1)
    remote_version=${remote_version#v}
    cecho $BROWN "Remote version: $remote_version"

    if [[ "$remote_version" == "" ]]; then cecho $RED "Unable to fetch remote version. Update aborted."; exit 1; fi
    if [[ "$(printf '%s\n' "$remote_version" "$local_version" | sort -V | head -n1)" == "$local_version" && "$local_version" != "0.0" ]]; then
        cecho $GREEN "Already up-to-date (version $local_version)."
        exit 0
    fi

    tmp_dir=$(mktemp -d)
    cecho $BROWN "Downloading latest version..."
    git clone --depth 1 "$repo_url" "$tmp_dir" >/dev/null 2>&1
    [[ ! -f "$tmp_dir/qolorun.sh" ]] && cecho $RED "Update failed: qolorun.sh not found" && rm -rf "$tmp_dir" && exit 1
    mv "$tmp_dir/qolorun.sh" "$INSTALL_DIR/qolorun"
    chmod +x "$INSTALL_DIR/qolorun"
    ln -sf "$INSTALL_DIR/qolorun" "$INSTALL_DIR/qr"
    rm -rf "$tmp_dir"
    cecho $GREEN "qolorun updated successfully to version $remote_version!"
    cecho $GRAY "$AUTHOR_INFO"
    exit 0
fi

# 🛠 Install
if [[ "$1" == "--install" ]]; then
    cecho $BROWN "Installing qolorun.sh..."
    mkdir -p "$INSTALL_DIR"
    [ -e "$INSTALL_DIR/qolorun" ] && { rm -rf "$INSTALL_DIR/qolorun"; cecho $YELLOW "Removed old qolorun installation"; }
    [ -L "$INSTALL_DIR/qr" ] || [ -f "$INSTALL_DIR/qr" ] && { rm -f "$INSTALL_DIR/qr"; cecho $YELLOW "Removed old qr symlink"; }
    cp "$0" "$INSTALL_DIR/qolorun"
    chmod +x "$INSTALL_DIR/qolorun"
    ln -sf "$INSTALL_DIR/qolorun" "$INSTALL_DIR/qr"
    shell_config=$(get_shell_config)
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' "$shell_config" 2>/dev/null; then
        echo 'export PATH="$HOME/bin:$PATH"' >> "$shell_config"
        cecho $BROWN "Added ~/bin to PATH in $shell_config"
    fi
    cecho $GREEN "qolorun installed successfully! You can now use both 'qolorun' and 'qr'"
    cecho $GRAY "$AUTHOR_INFO"
    exit 0
fi

# 🗑️ Uninstall
if [[ "$1" == "--uninstall" ]]; then
    cecho $BROWN "Uninstalling qolorun..."
    rm -f "$INSTALL_DIR/qolorun" "$INSTALL_DIR/qr"
    sed -i.bak '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc 2>/dev/null || true
    sed -i.bak '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.zshrc 2>/dev/null || true
    cecho $GREEN "qolorun uninstalled successfully!"
    exit 0
fi

# 🚫 No command / Invalid command
if [[ -z "$1" ]]; then
    cecho $RED "Error: No command provided."
    echo "Try: qolorun --help"
    exit 1
fi

# 🎛️ Parse flags
force_interactive=false
force_plain=false
if [[ "$1" == "--interactive" || "$1" == "-i" ]]; then force_interactive=true; shift
elif [[ "$1" == "--plain" || "$1" == "-p" ]]; then force_plain=true; shift
fi
cmd="$1"; args="${*:2}"

# 🔍 Check command existence
if [[ "$cmd" != "qolorun" && "$cmd" != "qr" ]]; then
    if ! command -v "$cmd" >/dev/null 2>&1; then
        cecho $RED "Error: Command '$cmd' not found."
        echo "Try: qolorun --help"
        exit 127
    fi
fi
cmd=$(basename "$cmd")
mkdir -p "$CACHE_DIR"

# 🧠 Interactive detection
interactive_patterns=("Scanner" "System.in" "input(" "read " "readline" "cin" "gets" "prompt" "ask" "select" "BufferedReader.readLine" "nextLine")
is_interactive=false
check_interactive() {
    local f="$1"; local cache_file="$CACHE_DIR/$(basename "$f").flag"
    if [[ -f "$cache_file" ]]; then [[ "$(cat "$cache_file")" == "interactive" ]] && is_interactive=true
    else
        for pattern in "${interactive_patterns[@]}"; do
            if grep -q "$pattern" "$f"; then
                echo "interactive" > "$cache_file"; is_interactive=true; break
            fi
        done
        [[ $is_interactive == false ]] && echo "plain" > "$cache_file"
    fi
}
if ! $force_plain && ! $force_interactive && [[ -t 0 && -t 1 ]]; then
    for f in $args; do [[ -f "$f" ]] && check_interactive "$f"; done
    [[ "$cmd" == "java" && -f "${args%% *}.java" ]] && check_interactive "${args%% *}.java"
fi

# 🚀 Execution
if $force_interactive || $is_interactive; then "$@"
else "$@" > >(while IFS= read -r line; do color_line "$line"; done) \
         2> >(while IFS= read -r line; do cecho $RED "$line"; done)
fi

status=$?
end_time=$(date +%s.%N)
elapsed=$(printf "%.2f" "$(echo "$end_time - $START_TIME" | bc)")

if [ $status -eq 0 ]; then
    cecho $MAGENTA "========== Done: Success (${elapsed}s) =========="
else
    cecho $MAGENTA "========== Done: Failed (Exit $status, ${elapsed}s) =========="
fi

exit $status
