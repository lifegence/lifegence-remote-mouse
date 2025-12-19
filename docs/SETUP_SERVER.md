# Server Setup Guide

PCサーバーのセットアップガイド

## 必要環境

- Windows 10/11
- Python 3.8以上

## インストール方法

### 方法1: インストーラーを使用（推奨）

1. [Releases](https://github.com/user/lifegence-remote-mouse/releases) から最新の `RemoteMouseServer_Setup.exe` をダウンロード
2. インストーラーを実行
3. デスクトップのショートカットから起動

### 方法2: ソースから実行

```bash
cd server
pip install -r requirements.txt
python main.py
```

### 方法3: 自分でビルド

```bash
cd server
pip install -r requirements.txt
build.bat
```

## ファイアウォール設定

初回起動時にWindowsファイアウォールの許可を求められます。
「プライベートネットワーク」を許可してください。

手動で設定する場合:
1. Windows設定 → Windows セキュリティ → ファイアウォールとネットワーク保護
2. 「ファイアウォールによるアプリケーションの許可」
3. 「設定の変更」→「別のアプリの許可」
4. RemoteMouseServer.exe を追加

## トラブルシューティング

### QRコードが表示されない

- Python と Pillow が正しくインストールされているか確認
- `pip install pillow qrcode` を実行

### IPアドレスが取得できない

- WiFiに接続されているか確認
- VPNを使用している場合は一時的に無効化
