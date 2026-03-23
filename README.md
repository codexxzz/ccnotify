# ccnotify

A simple macOS command-line tool that sends native notifications.

![notification example](https://img.shields.io/badge/macOS-13%2B-blue)

## Usage

```bash
# Basic notification
ccnotify "Hello, world!"

# Custom title
ccnotify -t "Build" "Compilation finished!"
```

## Install

### From source

Requires Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/codexxzz/ccnotify.git
cd ccnotify
make install
```

> `make install` copies the app to `/Applications` and a CLI wrapper to `/usr/local/bin`. You may need `sudo make install` if `/usr/local/bin` is not writable.

On first run, macOS will prompt for notification permission — click **Allow**.

### Build only (without installing)

```bash
make build
```

Then run directly:

```bash
open -W ccnotify.app --args "your message"
```

## Uninstall

```bash
make uninstall
```

## How it works

`ccnotify` is a minimal macOS `.app` bundle (required by `UNUserNotificationCenter`) that:

1. Sends a native notification with your message
2. Plays the default notification sound
3. Exits automatically after delivery

It runs as an accessory app — no Dock icon, no menu bar.

## License

MIT
