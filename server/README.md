# Remote Mouse Server

Windows用のリモートマウスサーバー。

## 必要環境

- Windows 10/11
- Python 3.8以上

## インストール

```bash
pip install -r requirements.txt
```

## 実行

```bash
python main.py
```

## ビルド

### EXEのみ

```bash
pyinstaller --onefile --noconsole --name RemoteMouseServer main.py
```

### インストーラー付き

1. [Inno Setup](https://jrsoftware.org/isdl.php) をインストール
2. `build.bat` を実行

## ファイル構成

| ファイル | 説明 |
|----------|------|
| main.py | GUIアプリケーション |
| websocket_server.py | WebSocket通信 |
| mouse_controller.py | マウス操作（pyautogui） |
| installer.iss | Inno Setupスクリプト |
| build.bat | ビルドスクリプト |
