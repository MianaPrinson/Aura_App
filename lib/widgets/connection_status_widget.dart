import 'package:flutter/material.dart';
import '../services/bluetooth_service.dart';

class ConnectionStatusWidget extends StatelessWidget {
  final BluetoothConnectionState state;
  final VoidCallback? onTap;

  const ConnectionStatusWidget({
    Key? key,
    required this.state,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _getBorderColor()),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              color: _getTextColor(),
              size: 16,
            ),
            const SizedBox(width: 8),
            Text(
              _getText(),
              style: TextStyle(
                color: _getTextColor(),
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            if (state == BluetoothConnectionState.connecting) ...[
              const SizedBox(width: 8),
              SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(_getTextColor()),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (state) {
      case BluetoothConnectionState.connected:
        return Colors.green.withOpacity(0.1);
      case BluetoothConnectionState.connecting:
        return Colors.orange.withOpacity(0.1);
      case BluetoothConnectionState.error:
        return Colors.red.withOpacity(0.1);
      default:
        return Colors.grey.withOpacity(0.1);
    }
  }

  Color _getBorderColor() {
    switch (state) {
      case BluetoothConnectionState.connected:
        return Colors.green;
      case BluetoothConnectionState.connecting:
        return Colors.orange;
      case BluetoothConnectionState.error:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Color _getTextColor() {
    return _getBorderColor();
  }

  IconData _getIcon() {
    switch (state) {
      case BluetoothConnectionState.connected:
        return Icons.bluetooth_connected;
      case BluetoothConnectionState.connecting:
        return Icons.bluetooth_searching;
      case BluetoothConnectionState.error:
        return Icons.bluetooth_disabled;
      default:
        return Icons.bluetooth;
    }
  }

  String _getText() {
    switch (state) {
      case BluetoothConnectionState.connected:
        return 'Connected';
      case BluetoothConnectionState.connecting:
        return 'Connecting...';
      case BluetoothConnectionState.error:
        return 'Connection Error';
      default:
        return 'Tap to Connect';
    }
  }
}
