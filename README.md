<img src="https://github.com/user-attachments/assets/32087086-c96b-4dab-ad0a-432ddf3f981f" alt="Preview" width="300"/>

#￹​‌​‌​‌‌​​‌‌‌‌​‌‌‌​​​‌‌​​​​‌​​​​​‌‌​​‌‌​‌​‌​​‌‌​​‌​​‌‌​​‌‌​‌‌‌​‌‌‌​‌​​​​​‌‌​‌‌‌​​​‌​‌​‌‌‌​‌​​‌‌​‌​‌​‌​​​‌​​​​‌​​​​​‌​‌‌‌​​‌​​​​​​￺ qolorun.sh — Smart CLI Runner with Colorized Output

`qolorun` is a smart Bash script that runs your commands with optional colorized output. It automatically detects whether the program expects user input and adjusts behavior accordingly — so interactive programs like Java `Scanner`, Python `input()`, or Bash `read` work without breaking.

Although `qolorun` is universal and works with any run commands, it has been thoroughly tested with **Java** and **Node.js** projects.

---

## 🚀 Features

- ✅ Auto-detects interactive programs and preserves stdin
- ✅ Colorizes stdout and stderr with meaningful highlights
- ✅ Manual override with `--interactive` or `--plain`
- ✅ Works on Linux and macOS
- ✅ Handles Ctrl+C gracefully
- ✅ Includes `--help`, `--version`, and `--install`
- ✅ Can be integrated with VS Code `launch.json` for direct execution Java

---

## 📦 Installation

```bash
git clone https://github.com/imtable/qolorun.git ~/qolorun
cd ~/qolorun
bash qolorun.sh --install
```
Reopen your terminal

🗑️ Uninstallation

```bash
bash qolorun.sh --uninstall
```

🔄 Update to latest version
```bash
qr --update
```

## 🧪 Usage
Run the script using either:
```bash
qolorun <command> [args...]
qr <command> [args...]
```

Run commands with automatic detection:
```bash
qr node app.js
qr npm run start
qr java NestedMenu.java
qr ./gradlew build
qr python3 app.py
```

Force interactive mode (no colorization, preserves stdin):
```bash
qr --interactive java NestedMenu
qr -i python3 script.py
```

Force plain mode (colorize even if input is expected):
```bash
qr --plain ./script.sh
qr -p node app.js
```

Show help or version info:
```bash
qr --help
qr --version
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
