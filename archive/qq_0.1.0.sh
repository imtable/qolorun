#!/usr/bin/env bash

# =============================================================================
# qq.sh — Smart CLI Runner with Colorized Output
# Author: imtable
# Version: 0.1
# Created: October 2025
# Location: Dublin / Kyiv
# License: MIT
# =============================================================================

# 💜 Show the command being executed
echo -e "\n\033[1;35m========== Running: $* ==========\033[0m"

# 🛑 Show help
if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    echo -e "\n\033[1;36mqq — smart command runner with optional colorized output\033[0m"
    echo -e "\nUsage:"
    echo "  qq [--interactive|-i] <command> [args...]   # run without color (for input-based programs)"
    echo "  qq [--plain|-p] <command> [args...]         # force colorized output"
    echo "  qq <command> [args...]                      # auto-detects input behavior"
    echo "  qq --install                                # install qq to ~/bin and update PATH"
    echo "  qq --version                                # show version and author"
    exit 0
fi

# 🛑 Show version
if [[ "$1" == "--version" ]]; then
    echo -e "\033[1;36mqq.sh version 0.1\033[0m"
    echo -e "\033[1;90mCreated by imtable — Dublin, 2025\033[0m"
    exit 0
fi

# 🛠 Install script to ~/bin
if [[ "$1" == "--install" ]]; then
    echo -e "\033[1;36mInstalling qq.sh...\033[0m"
    mkdir -p ~/bin
    cp "$0" ~/bin/qq
    chmod +x ~/bin/qq
    if ! grep -q 'export PATH="$HOME/bin:$PATH"' ~/.bashrc; then
        echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
    fi
    echo -e "\033[1;32mqq installed successfully!\033[0m"
    echo -e "\033[1;90mCreated by imtable — Zurich, 2025\033[0m"
    exit 0
fi

# 🛑 Handle empty command
if [[ -z "$1" ]]; then
    echo -e "\033[1;31mError: No command provided.\033[0m"
    echo "Try: qq --help"
    exit 1
fi

# 🧯 Handle Ctrl+C gracefully
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

# 🧠 Extract command name and arguments
cmd=$(basename "$1")
args="${*:2}"

# 🧠 Define patterns that indicate interactive behavior
interactive_patterns=("Scanner" "System.in" "input(" "read " "readline" "cin" "gets")

# 🧪 Check if any of the provided arguments are source files containing interactive patterns
is_interactive=false
if ! $force_plain && ! $force_interactive; then
    for f in $args; do
        if [[ -f "$f" ]]; then
            for pattern in "${interactive_patterns[@]}"; do
                if grep -q "$pattern" "$f"; then
                    is_interactive=true
                    break
                fi
            done
        fi
    done
    # 🧪 Extra check: if command is 'java' and source file exists
    if [[ "$cmd" == "java" && -f "${args%% *}.java" ]]; then
        for pattern in "${interactive_patterns[@]}"; do
            if grep -q "$pattern" "${args%% *}.java"; then
                is_interactive=true
                break
            fi
        done
    fi
fi

# 🚀 If forced or detected as interactive — run directly to preserve stdin
if $force_interactive || $is_interactive; then
    "$@"
else
    # 🎨 Otherwise, run with colorized output
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

# 🧾 Capture exit status and display result
status=$?
if [ $status -eq 0 ]; then
    echo -e "\033[1;35m========== Done: Success ==========\033[0m\n"
else
    echo -e "\033[1;35m========== Done: Failed (Exit $status) ==========\033[0m\n"
fi

exit $status
