# Contributing Guide

Remote Mouse への貢献ありがとうございます！

## 開発環境のセットアップ

### サーバー（Python）

```bash
cd server
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### アプリ（Flutter）

```bash
cd app
flutter pub get
flutter run
```

## プルリクエスト

1. このリポジトリをフォーク
2. 機能ブランチを作成 (`git checkout -b feature/amazing-feature`)
3. 変更をコミット (`git commit -m 'Add amazing feature'`)
4. ブランチをプッシュ (`git push origin feature/amazing-feature`)
5. プルリクエストを作成

## コーディング規約

### Python
- PEP 8 に従う
- 型ヒントを使用
- docstring を記述

### Dart/Flutter
- `flutter analyze` でエラーがないこと
- Effective Dart に従う

## Issue の報告

バグを報告する際は以下を含めてください:

- OS / Androidバージョン
- 再現手順
- 期待される動作
- 実際の動作
- エラーメッセージ（あれば）

## 機能リクエスト

新機能のアイデアがあれば、Issue で提案してください。
