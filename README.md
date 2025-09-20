# overlaynotify

🖥️ Lightweight macOS CLI tool for centered overlay notifications — perfect for workspace changes, alerts, or custom messages.

## Features
- Centered floating overlay on macOS
- Custom message and duration
- Fade-out animation
- Semi-transparent styling
- No Dock icon or app switcher presence

## Installation

### Build from source
```bash
git clone https://github.com/yourusername/overlaynotify.git
cd overlaynotify
swift build -c release
sudo cp .build/release/OverlayNotify /usr/local/bin/overlaynotify