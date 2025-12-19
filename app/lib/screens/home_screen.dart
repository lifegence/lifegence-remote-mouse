import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/websocket_service.dart';
import 'touchpad_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _ipController = TextEditingController();
  final _portController = TextEditingController(text: '8765');
  bool _isScanning = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();
    final savedIp = prefs.getString('server_ip');
    final savedPort = prefs.getString('server_port');
    if (savedIp != null) {
      _ipController.text = savedIp;
    }
    if (savedPort != null) {
      _portController.text = savedPort;
    }
  }

  Future<void> _saveAddress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('server_ip', _ipController.text);
    await prefs.setString('server_port', _portController.text);
  }

  void _connect() async {
    final ip = _ipController.text.trim();
    final port = _portController.text.trim();

    if (ip.isEmpty || port.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter IP and port')),
      );
      return;
    }

    final url = 'ws://$ip:$port';
    final service = context.read<WebSocketService>();

    await _saveAddress();
    await service.connect(url);

    if (service.isConnected && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TouchpadScreen()),
      );
    }
  }

  void _startQRScan() {
    setState(() => _isScanning = true);
  }

  void _onQRDetected(BarcodeCapture capture) {
    final barcode = capture.barcodes.firstOrNull;
    if (barcode?.rawValue != null) {
      final url = barcode!.rawValue!;
      // Parse ws://IP:PORT format
      final uri = Uri.tryParse(url);
      if (uri != null) {
        setState(() {
          _ipController.text = uri.host;
          _portController.text = uri.port.toString();
          _isScanning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Remote Mouse'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Consumer<WebSocketService>(
        builder: (context, service, child) {
          if (_isScanning) {
            return Column(
              children: [
                Expanded(
                  child: MobileScanner(onDetect: _onQRDetected),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () => setState(() => _isScanning = false),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            );
          }

          return Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mouse, size: 80, color: Colors.blue),
                const SizedBox(height: 32),
                const Text(
                  'Connect to PC',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextField(
                  controller: _ipController,
                  decoration: const InputDecoration(
                    labelText: 'IP Address',
                    hintText: '192.168.1.100',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.computer),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _portController,
                  decoration: const InputDecoration(
                    labelText: 'Port',
                    hintText: '8765',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.settings_ethernet),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed:
                            service.state == WsConnectionState.connecting
                                ? null
                                : _connect,
                        icon:
                            service.state == WsConnectionState.connecting
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : const Icon(Icons.link),
                        label: Text(
                          service.state == WsConnectionState.connecting
                              ? 'Connecting...'
                              : 'Connect',
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: _startQRScan,
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 20,
                        ),
                      ),
                    ),
                  ],
                ),
                if (service.state == WsConnectionState.error) ...[
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${service.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _ipController.dispose();
    _portController.dispose();
    super.dispose();
  }
}
