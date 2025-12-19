import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';

class TouchpadWidget extends StatefulWidget {
  const TouchpadWidget({super.key});

  @override
  State<TouchpadWidget> createState() => _TouchpadWidgetState();
}

class _TouchpadWidgetState extends State<TouchpadWidget> {
  // For mouse movement
  Offset? _lastPosition;
  int _pointerCount = 0;

  // For tap detection
  DateTime? _tapDownTime;
  Offset? _tapDownPosition;
  static const _tapTimeout = Duration(milliseconds: 200);
  static const _tapMaxDistance = 20.0;

  // For long press (right click)
  Timer? _longPressTimer;
  bool _longPressTriggered = false;
  static const _longPressDuration = Duration(milliseconds: 500);

  // For scroll
  double _scrollAccumulator = 0;
  static const _scrollThreshold = 10.0;

  // Sensitivity multiplier
  static const _moveSensitivity = 1.5;

  void _onPointerDown(PointerDownEvent event) {
    _pointerCount++;
    _lastPosition = event.localPosition;

    if (_pointerCount == 1) {
      _tapDownTime = DateTime.now();
      _tapDownPosition = event.localPosition;
      _longPressTriggered = false;

      // Start long press timer
      _longPressTimer?.cancel();
      _longPressTimer = Timer(_longPressDuration, () {
        if (_pointerCount == 1 && !_longPressTriggered) {
          _longPressTriggered = true;
          // Right click
          context.read<WebSocketService>().sendClick('right');
          _vibrate();
        }
      });
    }
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (_lastPosition == null) return;

    final delta = event.localPosition - _lastPosition!;
    _lastPosition = event.localPosition;

    // Cancel long press if moved too much
    if (_tapDownPosition != null) {
      final distanceFromTap =
          (event.localPosition - _tapDownPosition!).distance;
      if (distanceFromTap > _tapMaxDistance) {
        _longPressTimer?.cancel();
      }
    }

    final service = context.read<WebSocketService>();

    if (_pointerCount == 1 && !_longPressTriggered) {
      // Single finger: mouse move
      final dx = (delta.dx * _moveSensitivity).round();
      final dy = (delta.dy * _moveSensitivity).round();
      if (dx != 0 || dy != 0) {
        service.sendMove(dx, dy);
      }
    } else if (_pointerCount == 2) {
      // Two fingers: scroll
      _scrollAccumulator += delta.dy;
      if (_scrollAccumulator.abs() >= _scrollThreshold) {
        final scrollAmount = -(_scrollAccumulator / _scrollThreshold).round();
        if (scrollAmount != 0) {
          service.sendScroll(scrollAmount);
          _scrollAccumulator = 0;
        }
      }
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    _longPressTimer?.cancel();

    if (_pointerCount == 1 && !_longPressTriggered) {
      // Check for tap
      final tapDuration = DateTime.now().difference(_tapDownTime!);
      final distance =
          _tapDownPosition != null
              ? (event.localPosition - _tapDownPosition!).distance
              : double.infinity;

      if (tapDuration < _tapTimeout && distance < _tapMaxDistance) {
        // Left click
        context.read<WebSocketService>().sendClick('left');
      }
    }

    _pointerCount--;
    if (_pointerCount <= 0) {
      _pointerCount = 0;
      _lastPosition = null;
      _scrollAccumulator = 0;
    }
  }

  void _onPointerCancel(PointerCancelEvent event) {
    _longPressTimer?.cancel();
    _pointerCount--;
    if (_pointerCount <= 0) {
      _pointerCount = 0;
      _lastPosition = null;
      _scrollAccumulator = 0;
    }
  }

  void _vibrate() {
    // Simple haptic feedback
  }

  @override
  void dispose() {
    _longPressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: _onPointerDown,
      onPointerMove: _onPointerMove,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey[400]!, width: 2),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app, size: 48, color: Colors.grey[500]),
              const SizedBox(height: 16),
              Text(
                'Touch here to move mouse',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Tap = Left click\nLong press = Right click\n2 fingers = Scroll',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[500], fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
