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

### Download pre-built binary

1. Download [ccnotify-macos.zip](https://github.com/codexxzz/ccnotify/releases/latest/download/ccnotify-macos.zip)
2. Unzip and move `ccnotify.app` to `/Applications`
3. Remove the quarantine attribute (since the app is not notarized by Apple):

```bash
xattr -cr /Applications/ccnotify.app
```

4. Create a CLI wrapper:

```bash
sudo bash -c 'echo "#!/bin/bash
open -W /Applications/ccnotify.app --args \"\\\$@\"" > /usr/local/bin/ccnotify && chmod +x /usr/local/bin/ccnotify'
```

5. Run `ccnotify "test"` — allow notifications when prompted.

### From source

Requires Xcode Command Line Tools (`xcode-select --install`).

```bash
git clone https://github.com/codexxzz/ccnotify.git
cd ccnotify
make install
```

> `make install` copies the app to `/Applications` and a CLI wrapper to `/usr/local/bin`. You may need `sudo make install` if `/usr/local/bin` is not writable.

On first run, macOS will prompt for notification permission — click **Allow**.

## Uninstall

```bash
make uninstall
```

Or manually:

```bash
rm -rf /Applications/ccnotify.app
rm -f /usr/local/bin/ccnotify
```

## How it works

`ccnotify` is a minimal macOS `.app` bundle (required by `UNUserNotificationCenter`) that:

1. Sends a native notification with your message
2. Plays the default notification sound
3. Exits automatically after delivery

It runs as an accessory app — no Dock icon, no menu bar.

## License

MIT
