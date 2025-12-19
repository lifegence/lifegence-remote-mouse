# Android App Setup Guide

Androidアプリのセットアップガイド

## インストール方法

### 方法1: APKをダウンロード（推奨）

1. [Releases](https://github.com/lifegence/lifegence-remote-mouse/releases) から最新の `remote-mouse.apk` をダウンロード
2. スマホで「提供元不明のアプリ」を許可
3. APKをインストール

### 方法2: ソースからビルド

#### 必要環境
- Flutter SDK 3.10以上
- Android SDK

#### ビルド手順

```bash
cd app
flutter pub get
flutter build apk --release
```

生成されるAPK: `app/build/app/outputs/flutter-apk/app-release.apk`

## 権限

アプリは以下の権限を使用します:

| 権限 | 用途 |
|------|------|
| インターネット | PCサーバーとの通信 |
| カメラ | QRコードスキャン |

## 使い方

1. PCでサーバーを起動
2. アプリを開く
3. QRコードをスキャン、またはIPアドレスを入力
4. 「Connect」をタップ
5. タッチパッド画面でマウス操作

## 操作方法

| 操作 | 機能 |
|------|------|
| ドラッグ | マウス移動 |
| タップ | 左クリック |
| 長押し（0.5秒） | 右クリック |
| 2本指スワイプ | スクロール |
| 下部ボタン | 左/右クリック |

## トラブルシューティング

### 接続できない

1. PCとスマホが同じWiFiに接続されているか確認
2. PCのファイアウォールでポート8765が許可されているか確認
3. IPアドレスが正しいか確認

### 反応が遅い

- WiFiの電波強度を確認
- 5GHz帯のWiFiを使用（2.4GHzより高速）
