import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum WsConnectionState { disconnected, connecting, connected, error }

class WebSocketService extends ChangeNotifier {
  WebSocketChannel? _channel;
  WsConnectionState _state = WsConnectionState.disconnected;
  String? _errorMessage;
  String? _serverUrl;

  WsConnectionState get state => _state;
  String? get errorMessage => _errorMessage;
  String? get serverUrl => _serverUrl;
  bool get isConnected => _state == WsConnectionState.connected;

  Future<void> connect(String url) async {
    if (_state == WsConnectionState.connecting) return;

    _state = WsConnectionState.connecting;
    _errorMessage = null;
    _serverUrl = url;
    notifyListeners();

    try {
      final uri = Uri.parse(url);
      _channel = WebSocketChannel.connect(uri);

      await _channel!.ready;

      _state = WsConnectionState.connected;
      notifyListeners();

      _channel!.stream.listen(
        (message) {
          // Handle server messages if needed
        },
        onError: (error) {
          _state = WsConnectionState.error;
          _errorMessage = error.toString();
          notifyListeners();
        },
        onDone: () {
          _state = WsConnectionState.disconnected;
          notifyListeners();
        },
      );
    } catch (e) {
      _state = WsConnectionState.error;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _channel = null;
    _state = WsConnectionState.disconnected;
    notifyListeners();
  }

  void sendMove(int dx, int dy) {
    _send({'type': 'move', 'dx': dx, 'dy': dy});
  }

  void sendClick(String button) {
    _send({'type': 'click', 'button': button});
  }

  void sendScroll(int dy) {
    _send({'type': 'scroll', 'dy': dy});
  }

  void _send(Map<String, dynamic> data) {
    if (_state == WsConnectionState.connected && _channel != null) {
      _channel!.sink.add(jsonEncode(data));
    }
  }

  @override
  void dispose() {
    disconnect();
    super.dispose();
  }
}
