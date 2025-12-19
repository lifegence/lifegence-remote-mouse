# Remote Mouse Server

Remote mouse server for Windows.

## Requirements

- Windows 10/11
- Python 3.8 or higher

## Installation

```bash
pip install -r requirements.txt
```

## Run

```bash
python main.py
```

## Build

### EXE Only

```bash
pyinstaller --onefile --noconsole --icon=icon.ico --name RemoteMouseServer main.py
```

### With Installer

1. Install [Inno Setup](https://jrsoftware.org/isdl.php)
2. Run `build.bat`

## File Structure

| File | Description |
|------|-------------|
| main.py | GUI application |
| websocket_server.py | WebSocket communication |
| mouse_controller.py | Mouse control (pyautogui) |
| installer.iss | Inno Setup script |
| build.bat | Build script |
| icon.ico | Application icon |
