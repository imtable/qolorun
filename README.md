# qq.sh — Smart CLI Runner with Colorized Output

`qq` is a smart Bash script that runs your commands with optional colorized output. It automatically detects whether the program expects user input and adjusts behavior accordingly — so interactive programs like Java `Scanner`, Python `input()`, or Bash `read` work without breaking.

Current version: **0.1**  
Released: October 2025

---

## 🚀 Features

- ✅ Auto-detects interactive programs and preserves stdin
- ✅ Colorizes stdout and stderr with meaningful highlights
- ✅ Manual override with `--interactive` or `--plain`
- ✅ Works on Linux and macOS
- ✅ Handles Ctrl+C gracefully
- ✅ Includes `--help`, `--version`, and `--install`

---

## 📦 Installation

```bash
bash qq.sh --install
```
Reopen your terminal or run one of the following:
```bash
source ~/.bashrc   # if you're using Bash
source ~/.zshrc    # if you're using Zsh
```

## 🧪 Usage

Run commands with automatic detection:
```bash
qq ./gradlew build
qq java NestedMenu nestedMenu.java
qq python3 script.py
```

Force interactive mode (no colorization, preserves stdin):
```bash
qq --interactive java NestedMenu
qq -i python3 script.py
```

Force plain mode (colorize even if input is expected):
```bash
qq --plain ./script.sh
qq -p node app.js
```

Show help or version info:
```bash
qq --help
qq --version
```

## 🎨 Color Rules
| Type         | Color      |
|--------------|------------|
| Errors       | 🔴 Red      |
| Warnings     | 🟡 Yellow   |
| Success      | 🟢 Green    |
| Print/echo   | 🔵 Cyan     |
| Default text | 🟤 Bold Yellow |

## 📬 Contact
For questions, feedback, or collaboration inquiries — feel free to reach out:

- 📧 Email: [imtable99@gmail.com](mailto:imtable99@gmail.com)
- 📲 Telegram: [t.me/imtable](https://t.me/imtable) 
- 💼 LinkedIn: [linkedin.com/in/imtable](https://linkedin.com/in/imtable)
- 🌐 GitHub: [github.com/imtable](https://github.com/imtable)
