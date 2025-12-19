# Remote Mouse App

Android用のリモートマウスアプリ（Flutter）。

## 必要環境

- Flutter SDK 3.10以上
- Android SDK

## セットアップ

```bash
flutter pub get
```

## 実行

```bash
flutter run
```

## ビルド

### デバッグビルド

```bash
flutter build apk --debug
```

### リリースビルド

```bash
flutter build apk --release
```

生成されるAPK: `build/app/outputs/flutter-apk/app-release.apk`

## ファイル構成

```
lib/
├── main.dart              # エントリーポイント
├── screens/
│   ├── home_screen.dart   # 接続画面（IP入力・QRスキャン）
│   └── touchpad_screen.dart # タッチパッド画面
├── services/
│   └── websocket_service.dart # WebSocket通信
└── widgets/
    └── touchpad_widget.dart   # タッチパッドUI
```

## 機能

- IP入力またはQRコードスキャンで接続
- タッチパッドでマウス操作
- タップで左クリック
- 長押しで右クリック
- 2本指スワイプでスクロール
