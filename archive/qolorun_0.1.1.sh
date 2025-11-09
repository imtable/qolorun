#!/usr/bin/env bash

# =============================================================================
# qolorun.sh — Smart CLI Runner with Colorized Output
# Author: imtable
# Version: 0.1.1
# Created: October 2025
# Location: Dublin / Kyiv
# License: MIT
# =============================================================================

echo -e "\n\033[1;35m========== Running: $* ==========\033[0m"

# 🛑 Help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "\n\033[1;36mqolorun — smart command runner with optional colorized output\033[0m"
    echo -e "\nUsage:"
    echo "  qolorun [--interactive|-i] <command> [args...]   # run without color (for input-based programs)"
    echo "  qolorun [--plain|-p] <command> [args...]         # force colorized output"
    echo "  qolorun <command> [args...]                      # auto-detects input behavior"
    echo "  qolorun --install                                # install qolorun to ~/bin and update PATH"
    echo "  qolorun --version                                # show version and author"
    exit 0
fi

# 🧾 Version
if [[ "$1" == "--version" ]]; then
    echo -e "\033[1;36mqolorun.sh version 0.1.1\033[0m"
    echo -e "\033[1;90mCreated by imtable — Dublin/Kyiv, 2025\033[0m"
    exit 0
fi

# 🛠 Install
if [[ "$1" == "--install" ]]; then
    echo -e "\033[1;36mInstalling qolorun.sh...\033[0m"
    mkdir -p ~/bin
    cp "$0" ~/bin/qolorun
    chmod +x ~/bin/qolorun

    # additional calling
    ln -sf ~/bin/qolorun ~/bin/qr

    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    fi
    echo -e "\033[1;32mqolorun installed successfully! You can now use both 'qolorun' and 'qr'\033[0m"
    echo -e "\033[1;90mCreated by imtable — Kyiv, 2025\033[0m"
    exit 0
fi

# 🛑 Uninstall
if [[ "$1" == "--uninstall" ]]; then
    echo -e "\033[1;36mUninstalling qolorun...\033[0m"
    rm -f ~/bin/qolorun ~/bin/qr
    sed -i.bak '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.bashrc 2>/dev/null || true
    sed -i.bak '/export PATH="\$HOME\/bin:\$PATH"/d' ~/.zshrc 2>/dev/null || true
    echo -e "\033[1;32mqolorun uninstalled successfully!\033[0m"
    exit 0
fi

# 🛑 No command
if [[ -z "$1" ]]; then
    echo -e "\033[1;31mError: No command provided.\033[0m"
    echo "Try: qolorun --help"
    exit 1
fi

trap 'echo -e "\n\033[1;31mInterrupted by user\033[0m"; exit 130' INT

# 🎛️ Parse flags
force_interactive=false
force_plain=false

if [[ "$1" == "--interactive" || "$1" == "-i" ]]; then
    force_interactive=true
    shift
elif [[ "$1" == "--plain" || "$1" == "-p" ]]; then
    force_plain=true
    shift
fi

cmd=$(basename "$1")
args="${*:2}"

# 📦 Cache directory
cache_dir="$HOME/.qr-cache"
mkdir -p "$cache_dir"

# 🧠 Patterns that indicate interactive code
interactive_patterns=(
    "Scanner" "System.in" "input(" "read " "readline" "cin" "gets"
    "prompt" "ask" "select" "BufferedReader.readLine" "nextLine"
)

# 🧪 Detect interactive behavior
is_interactive=false
if ! $force_plain && ! $force_interactive; then
    if [[ -t 0 && -t 1 ]]; then
        for f in $args; do
            if [[ -f "$f" ]]; then
                cache_file="$cache_dir/$(basename "$f").flag"
                if [[ -f "$cache_file" ]]; then
                    if [[ "$(cat "$cache_file")" == "interactive" ]]; then
                        is_interactive=true
                        break
                    fi
                else
                    for pattern in "${interactive_patterns[@]}"; do
                        if grep -q "$pattern" "$f"; then
                            echo "interactive" > "$cache_file"
                            is_interactive=true
                            break
                        fi
                    done
                    [[ $is_interactive == false ]] && echo "plain" > "$cache_file"
                fi
            fi
        done
    fi

    if [[ "$cmd" == "java" && -f "${args%% *}.java" ]]; then
        f="${args%% *}.java"
        cache_file="$cache_dir/$(basename "$f").flag"
        if [[ -f "$cache_file" ]]; then
            [[ "$(cat "$cache_file")" == "interactive" ]] && is_interactive=true
        else
            for pattern in "${interactive_patterns[@]}"; do
                if grep -q "$pattern" "$f"; then
                    echo "interactive" > "$cache_file"
                    is_interactive=true
                    break
                fi
            done
            [[ $is_interactive == false ]] && echo "plain" > "$cache_file"
        fi
    fi
fi

# 🚀 Execution
if $force_interactive || $is_interactive; then
    "$@"
else
    "$@" > >(while IFS= read -r line; do
        if [[ "$line" =~ ([Ee]rror|[Ee]xception|Traceback|fail|FAIL|undefined|not\ found) ]]; then
            echo -e "\033[1;31m$line\033[0m"
        elif [[ "$line" =~ ([Ww]arning|deprecated|caution) ]]; then
            echo -e "\033[1;33m$line\033[0m"
        elif [[ "$line" =~ ([Ss]uccess|done|passed|✓|BUILD\ SUCCESSFUL|OK) ]]; then
            echo -e "\033[1;32m$line\033[0m"
        elif [[ "$line" =~ ^(System\.out|print|console\.log|echo|printf|fmt\.Println|println!) ]]; then
            echo -e "\033[1;36m$line\033[0m"
        else
            echo -e "\033[1;33m$line\033[0m"
        fi
    done) 2> >(while IFS= read -r line; do
        echo -e "\033[1;31m$line\033[0m"
    done)
fi

status=$?
if [ $status -eq 0 ]; then
    echo -e "\033[1;35m========== Done: Success ==========\033[0m\n"
else
    echo -e "\033[1;35m========== Done: Failed (Exit $status) ==========\033[0m\n"
fi

exit $status
