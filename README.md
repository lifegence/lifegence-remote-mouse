# Remote Mouse

[![Build](https://github.com/lifegence/lifegence-remote-mouse/actions/workflows/build.yml/badge.svg)](https://github.com/lifegence/lifegence-remote-mouse/actions/workflows/build.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows%20%7C%20Android-blue.svg)]()

スマートフォンをPCのマウス・タッチパッドとして使用するアプリケーション。

トラックパッドが壊れた時や、プレゼン時のリモートマウスとして活用できます。

<p align="center">
  <img src="docs/images/screenshot_server.png" alt="Server" width="300">
  <img src="docs/images/screenshot_app.png" alt="App" width="200">
</p>

## 特徴

- **簡単接続**: QRコードスキャンで即座に接続
- **低遅延**: WiFi経由のWebSocket通信で快適な操作感
- **多機能**: マウス移動、クリック、スクロールに対応
- **キーボード不要**: PC側はEnterキー一発で起動

## 機能

| 操作 | 機能 |
|------|------|
| ドラッグ | マウス移動 |
| タップ | 左クリック |
| 長押し（0.5秒） | 右クリック |
| 2本指スワイプ | スクロール |

## クイックスタート

### 1. ダウンロード

[Releases](https://github.com/lifegence/lifegence-remote-mouse/releases) から最新版をダウンロード:

- **Windows**: `RemoteMouseServer_Setup.exe` または `RemoteMouseServer.exe`
- **Android**: `remote-mouse.apk`

### 2. PCでサーバーを起動

```
RemoteMouseServer.exe を実行
→ QRコードとIPアドレスが表示される
```

### 3. スマホで接続

```
アプリを起動
→ QRコードをスキャン or IPアドレスを入力
→ Connect をタップ
```

### 4. 使う

タッチパッド画面でスマホをマウスとして使用！

## プロジェクト構成

```
lifegence-remote-mouse/
├── server/                 # PCサーバー（Python/Windows）
│   ├── main.py            # メインアプリ（GUI）
│   ├── websocket_server.py # WebSocket通信
│   ├── mouse_controller.py # マウス操作
│   ├── requirements.txt
│   ├── build.bat          # ビルドスクリプト
│   └── installer.iss      # インストーラー設定
│
├── app/                    # Androidアプリ（Flutter）
│   ├── lib/
│   │   ├── main.dart
│   │   ├── screens/       # 画面
│   │   ├── services/      # WebSocket通信
│   │   └── widgets/       # タッチパッド
│   └── pubspec.yaml
│
├── docs/                   # ドキュメント
│   ├── SETUP_SERVER.md
│   ├── SETUP_APP.md
│   └── CONTRIBUTING.md
│
└── .github/workflows/      # CI/CD
    └── build.yml
```

## 開発

### サーバー（Python）

```bash
cd server
pip install -r requirements.txt
python main.py
```

### アプリ（Flutter）

```bash
cd app
flutter pub get
flutter run
```

詳細は [CONTRIBUTING.md](docs/CONTRIBUTING.md) を参照。

## ビルド

### Windows インストーラー

```bash
cd server
build.bat
```

[Inno Setup](https://jrsoftware.org/isdl.php) がインストールされていれば、インストーラーも自動生成されます。

### Android APK

```bash
cd app
flutter build apk --release
```

## 動作環境

| コンポーネント | 要件 |
|--------------|------|
| サーバー | Windows 10/11, Python 3.8+ |
| アプリ | Android 5.0 (API 21) 以上 |
| ネットワーク | 同一WiFiネットワーク |

## トラブルシューティング

### 接続できない

1. PCとスマホが**同じWiFi**に接続されているか確認
2. Windowsファイアウォールでポート**8765**を許可
3. VPNを使用している場合は一時的に無効化

### 反応が遅い

- 5GHz帯のWiFiを使用（2.4GHzより高速）
- ルーターに近い場所で使用

## ライセンス

[MIT License](LICENSE)

## 貢献

Issue や Pull Request を歓迎します。
詳細は [CONTRIBUTING.md](docs/CONTRIBUTING.md) を参照してください。
