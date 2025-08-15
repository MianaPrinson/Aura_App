import 'package:flutter/material.dart';

class SensorData {
  final double auraScore;
  final String riskLevel;
  final int pm25;
  final int pm10;
  final double uvIndex;
  final int voc;
  final int co2;
  final double temperature;
  final double pressure;
  final int ambientLight;
  final double latitude;
  final double longitude;
  final int satellites;
  final int batteryPercent;
  final DateTime timestamp;

  SensorData({
    this.auraScore = 0.0,
    this.riskLevel = 'UNKNOWN',
    this.pm25 = 0,
    this.pm10 = 0,
    this.uvIndex = 0.0,
    this.voc = 0,
    this.co2 = 0,
    this.temperature = 0.0,
    this.pressure = 0.0,
    this.ambientLight = 0,
    this.latitude = 0.0,
    this.longitude = 0.0,
    this.satellites = 0,
    this.batteryPercent = 0,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  // Create SensorData from JSON (from ESP32)
  factory SensorData.fromJson(Map<String, dynamic> json) {
    return SensorData(
      auraScore: (json['aura_score'] ?? 0.0).toDouble(),
      riskLevel: json['risk_level'] ?? 'UNKNOWN',
      pm25: json['pm25'] ?? 0,
      pm10: json['pm10'] ?? 0,
      uvIndex: (json['uv_index'] ?? 0.0).toDouble(),
      voc: json['voc'] ?? 0,
      co2: json['co2'] ?? 0,
      temperature: (json['temperature'] ?? 0.0).toDouble(),
      pressure: (json['pressure'] ?? 0.0).toDouble(),
      ambientLight: json['ambient_light'] ?? 0,
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      satellites: json['satellites'] ?? 0,
      batteryPercent: json['battery'] ?? 0,
      timestamp: DateTime.now(),
    );
  }

  // Get risk level color
  Color getRiskColor() {
    switch (riskLevel) {
      case 'LOW':
        return Colors.green;
      case 'MODERATE':
        return Colors.yellow[700]!;
      case 'HIGH':
        return Colors.orange;
      case 'VERY HIGH':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
