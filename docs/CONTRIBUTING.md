# Contributing Guide

Thank you for contributing to Remote Mouse!

## Development Environment Setup

### Server (Python)

```bash
cd server
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
pip install -r requirements.txt
```

### App (Flutter)

```bash
cd app
flutter pub get
flutter run
```

## Pull Requests

1. Fork this repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push the branch (`git push origin feature/amazing-feature`)
5. Create a Pull Request

## Coding Standards

### Python
- Follow PEP 8
- Use type hints
- Write docstrings

### Dart/Flutter
- No errors from `flutter analyze`
- Follow Effective Dart guidelines

## Reporting Issues

When reporting bugs, please include:

- OS / Android version
- Steps to reproduce
- Expected behavior
- Actual behavior
- Error messages (if any)

## Feature Requests

If you have ideas for new features, please propose them via Issues.
