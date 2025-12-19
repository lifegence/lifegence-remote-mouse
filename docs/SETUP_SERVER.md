# Server Setup Guide

Setup guide for the PC server.

## Requirements

- Windows 10/11
- Python 3.8 or higher

## Installation

### Option 1: Use Installer (Recommended)

1. Download the latest `RemoteMouseServer_Setup.exe` from [Releases](https://github.com/lifegence/lifegence-remote-mouse/releases)
2. Run the installer
3. Launch from the desktop shortcut

### Option 2: Run from Source

```bash
cd server
pip install -r requirements.txt
python main.py
```

### Option 3: Build Yourself

```bash
cd server
pip install -r requirements.txt
build.bat
```

## Firewall Configuration

On first launch, Windows Firewall will ask for permission.
Allow access for "Private networks".

Manual configuration:
1. Windows Settings → Windows Security → Firewall & network protection
2. "Allow an app through firewall"
3. "Change settings" → "Allow another app"
4. Add RemoteMouseServer.exe

## Troubleshooting

### QR Code Not Displayed

- Verify Python and Pillow are installed correctly
- Run `pip install pillow qrcode`

### Cannot Get IP Address

- Check WiFi connection
- Temporarily disable VPN if using one
