import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../services/websocket_service.dart';
import '../widgets/touchpad_widget.dart';

class TouchpadScreen extends StatefulWidget {
  const TouchpadScreen({super.key});

  @override
  State<TouchpadScreen> createState() => _TouchpadScreenState();
}

class _TouchpadScreenState extends State<TouchpadScreen> {
  @override
  void initState() {
    super.initState();
    // Keep screen on and hide status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  void _onLeftClick() {
    context.read<WebSocketService>().sendClick('left');
    HapticFeedback.lightImpact();
  }

  void _onRightClick() {
    context.read<WebSocketService>().sendClick('right');
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Consumer<WebSocketService>(
          builder: (context, service, child) {
            return Row(
              children: [
                Icon(
                  service.isConnected ? Icons.link : Icons.link_off,
                  color: service.isConnected ? Colors.green : Colors.red,
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text('Touchpad'),
              ],
            );
          },
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          Consumer<WebSocketService>(
            builder: (context, service, child) {
              return IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  service.disconnect();
                  Navigator.pop(context);
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<WebSocketService>(
        builder: (context, service, child) {
          if (!service.isConnected) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.link_off, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text(
                    'Disconnected',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Connect'),
                  ),
                ],
              ),
            );
          }

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Touchpad area
                  const Expanded(child: TouchpadWidget()),
                  const SizedBox(height: 16),
                  // Click buttons
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _onLeftClick,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[100],
                              foregroundColor: Colors.blue[900],
                            ),
                            child: const Text(
                              'Left Click',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _onRightClick,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[300],
                              foregroundColor: Colors.grey[800],
                            ),
                            child: const Text(
                              'Right Click',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
