import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../models/sensor_data.dart';

enum BluetoothConnectionState { disconnected, connecting, connected, error }

class BluetoothService {
  static final BluetoothService _instance = BluetoothService._internal();
  factory BluetoothService() => _instance;
  BluetoothService._internal();

  BluetoothConnection? _connection;
  StreamController<SensorData> _dataController =
      StreamController<SensorData>.broadcast();
  StreamController<BluetoothConnectionState> _stateController =
      StreamController<BluetoothConnectionState>.broadcast();

  // Getters for streams
  Stream<SensorData> get sensorDataStream => _dataController.stream;
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _stateController.stream;

  BluetoothConnectionState _currentState =
      BluetoothConnectionState.disconnected;
  BluetoothConnectionState get currentState => _currentState;

  SensorData _latestData = SensorData();
  SensorData get latestData => _latestData;

  // Update connection state
  void _updateState(BluetoothConnectionState newState) {
    _currentState = newState;
    _stateController.add(newState);
  }

  // Get list of paired devices
  Future<List<BluetoothDevice>> getPairedDevices() async {
    try {
      return await FlutterBluetoothSerial.instance.getBondedDevices();
    } catch (e) {
      print('Error getting paired devices: $e');
      return [];
    }
  }

  // Connect to AURA device
  Future<bool> connectToAURADevice() async {
    try {
      _updateState(BluetoothConnectionState.connecting);

      // Get paired devices
      List<BluetoothDevice> devices = await getPairedDevices();

      // Find AURA device
      BluetoothDevice? auraDevice;
      for (BluetoothDevice device in devices) {
        if (device.name != null &&
            (device.name!.contains('AURA') ||
                device.name == 'AURA-Stack-Device')) {
          auraDevice = device;
          break;
        }
      }

      if (auraDevice == null) {
        print('AURA device not found in paired devices');
        _updateState(BluetoothConnectionState.error);
        return false;
      }

      // Attempt connection
      _connection = await BluetoothConnection.toAddress(auraDevice.address);
      print('Connected to ${auraDevice.name}');

      // Listen for data
      _connection!.input!.listen(
        _onDataReceived,
        onError: (error) {
          print('Connection error: $error');
          _updateState(BluetoothConnectionState.error);
        },
        onDone: () {
          print('Connection closed');
          _updateState(BluetoothConnectionState.disconnected);
        },
      );

      _updateState(BluetoothConnectionState.connected);
      return true;
    } catch (e) {
      print('Connection failed: $e');
      _updateState(BluetoothConnectionState.error);
      return false;
    }
  }

  // Handle incoming data from ESP32
  void _onDataReceived(Uint8List data) {
    try {
      String dataString = String.fromCharCodes(data).trim();
      print('Received: $dataString');

      // Try to parse as JSON first
      if (dataString.startsWith('{') && dataString.endsWith('}')) {
        Map<String, dynamic> jsonData = json.decode(dataString);
        SensorData newData = SensorData.fromJson(jsonData);
        _latestData = newData;
        _dataController.add(newData);
      } else {
        // Parse simple key-value pairs
        _parseSimpleData(dataString);
      }
    } catch (e) {
      print('Error parsing data: $e');
    }
  }

  // Parse simple data format (e.g., "PM2.5: 25")
  void _parseSimpleData(String dataString) {
    Map<String, dynamic> parsedData = {};

    List<String> lines = dataString.split('\n');
    for (String line in lines) {
      if (line.contains(':')) {
        List<String> parts = line.split(':');
        if (parts.length == 2) {
          String key = parts[0].trim().toLowerCase();
          String value = parts[1].trim();

          try {
            switch (key) {
              case 'pm2.5':
              case 'pm25':
                parsedData['pm25'] = int.parse(value);
                break;
              case 'uv':
              case 'uv index':
                parsedData['uv_index'] = double.parse(value);
                break;
              case 'temperature':
              case 'temp':
                parsedData['temperature'] = double.parse(value);
                break;
              case 'aura':
              case 'aura score':
                parsedData['aura_score'] = double.parse(value);
                break;
            }
          } catch (e) {
            print('Error parsing value for $key: $e');
          }
        }
      }
    }

    if (parsedData.isNotEmpty) {
      SensorData newData = SensorData.fromJson(parsedData);
      _latestData = newData;
      _dataController.add(newData);
    }
  }

  // Disconnect from device
  void disconnect() {
    if (_connection != null) {
      _connection!.dispose();
      _connection = null;
      _updateState(BluetoothConnectionState.disconnected);
    }
  }

  // Send data to ESP32 (for settings, etc.)
  void sendData(String data) {
    if (_connection != null &&
        _currentState == BluetoothConnectionState.connected) {
      _connection!.output.add(Uint8List.fromList(utf8.encode(data)));
    }
  }

  // Cleanup
  void dispose() {
    disconnect();
    _dataController.close();
    _stateController.close();
  }
}
