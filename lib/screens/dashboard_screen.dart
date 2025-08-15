import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/sensor_card.dart';

// Placeholder for the SensorData model. In a real app, this would be in its own file.
class SensorData {
  final int pm25;
  final double uvIndex;
  final int voc;
  final double temperature;
  final double humidity;
  final int co2;
  final int satellites;
  final int batteryPercent;
  final DateTime timestamp;

  SensorData({
    required this.pm25,
    required this.uvIndex,
    required this.voc,
    required this.temperature,
    required this.humidity,
    required this.co2,
    required this.satellites,
    required this.batteryPercent,
    required this.timestamp,
  });
}

// A placeholder for the AuraScoreWidget. You should replace this with your actual implementation.
class AuraScoreWidget extends StatelessWidget {
  final SensorData sensorData;

  const AuraScoreWidget({required this.sensorData, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.teal[600]!,
            Colors.teal[800]!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'AURA Score',
              style: TextStyle(
                fontSize: 18, // Reduced from 20
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${_calculateAuraScore(sensorData).toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 48, // Reduced from 56
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              _getAuraStatus(_calculateAuraScore(sensorData)),
              style: TextStyle(
                fontSize: 14, // Reduced from 16
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Example logic to calculate a simple score, now using humidity instead of CO2
  double _calculateAuraScore(SensorData data) {
    // A simple, illustrative score calculation based on sensor values.
    // Replace with your actual algorithm.
    double score =
        100 - (data.pm25 * 0.5) - (data.uvIndex * 2) - (data.humidity * 0.2);
    return score.clamp(0, 100);
  }

  // Example logic to get a status based on the score
  String _getAuraStatus(double score) {
    if (score > 80) return 'Excellent';
    if (score > 60) return 'Good';
    if (score > 40) return 'Moderate';
    return 'Poor';
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Initial data with default values to prevent null errors
  SensorData _currentData = SensorData(
    pm25: 0,
    uvIndex: 0.0,
    voc: 0,
    temperature: 0.0,
    humidity: 0.0,
    co2: 0,
    satellites: 0,
    batteryPercent: 0,
    timestamp: DateTime.now(),
  );

  @override
  void initState() {
    super.initState();
    _setupListeners();
  }

  void _setupListeners() {
    // Listen to real-time updates from Firestore
    // Replace 'sensor_data_collection' and 'your_document_id' with your actual collection and document names
    FirebaseFirestore.instance
        .collection('sensor_data_collection')
        .doc('your_document_id')
        .snapshots()
        .listen((DocumentSnapshot snapshot) {
      if (snapshot.exists) {
        // Map the Firestore data to your SensorData model
        final data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _currentData = SensorData(
            pm25: data['pm25'] as int? ?? 0,
            uvIndex: (data['uvIndex'] as num?)?.toDouble() ?? 0.0,
            voc: data['voc'] as int? ?? 0,
            temperature: (data['temperature'] as num?)?.toDouble() ?? 0.0,
            humidity: (data['humidity'] as num?)?.toDouble() ?? 0.0,
            co2: data['co2'] as int? ?? 0,
            satellites: data['satellites'] as int? ?? 0,
            batteryPercent: data['batteryPercent'] as int? ?? 0,
            timestamp:
                (data['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          );
        });
      }
    });
  }

  // Helper function to get a simple AQI score from PM2.5
  int _getAQIFromPM25(int pm25) {
    if (pm25 <= 12) return 1;
    if (pm25 <= 35) return 2;
    if (pm25 <= 55) return 3;
    if (pm25 <= 150) return 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1000;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2E7D7D),
            Color(0xFF1A4A4A),
            Color(0xFF0A2A2A),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(isDesktop ? 24.0 : 16.0),
        child: Column(
          children: [
            SizedBox(height: isDesktop ? 20 : 16),
            SizedBox(
              height: (isDesktop ? screenWidth * 0.1 : screenWidth * 0.2)
                  .clamp(150, 200),
              child: AuraScoreWidget(sensorData: _currentData),
            ),
            SizedBox(height: isDesktop ? 20 : 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Environmental Data',
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 12 : 16),
            // Replaced Wrap with an Expanded GridView to make the cards square and fit the screen without scrolling
            Expanded(
              child: GridView.count(
                crossAxisCount: isDesktop ? 4 : 2,
                crossAxisSpacing: isDesktop ? 16 : 12,
                mainAxisSpacing: isDesktop ? 16 : 12,
                childAspectRatio: 1.0, // This makes the grid items square
                children: [
                  // AQI Card (based on PM2.5)
                  SensorCard(
                    title: 'AQI',
                    value: '${_getAQIFromPM25(_currentData.pm25)}',
                    unit: 'Good',
                    icon: Icons.air,
                    color: _getAQIColor(_getAQIFromPM25(_currentData.pm25)),
                  ),
                  // UV Index Card
                  SensorCard(
                    title: 'UV Index',
                    value: '${_currentData.uvIndex.toStringAsFixed(1)}',
                    unit: '',
                    icon: Icons.wb_sunny,
                    color: _getUVColor(_currentData.uvIndex),
                  ),
                  // Humidity Card
                  SensorCard(
                    title: 'Humidity',
                    value: '${_currentData.humidity.toStringAsFixed(0)}',
                    unit: '%',
                    icon: Icons.water_drop,
                    color: Colors.lightBlue,
                  ),
                  // Temperature Card
                  SensorCard(
                    title: 'Temperature',
                    value: '${_currentData.temperature.toStringAsFixed(1)}',
                    unit: '°C',
                    icon: Icons.thermostat,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper functions for color and time formatting
  Color _getAQIColor(int aqi) {
    if (aqi == 1) return Colors.green;
    if (aqi == 2) return Colors.yellow[700]!;
    if (aqi == 3) return Colors.orange;
    if (aqi == 4) return Colors.red;
    return Colors.purple;
  }

  Color _getUVColor(double uv) {
    if (uv <= 2) return Colors.green;
    if (uv <= 5) return Colors.yellow[700]!;
    if (uv <= 7) return Colors.orange;
    return Colors.red;
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
