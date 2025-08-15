import 'package:flutter/material.dart';
import '../models/sensor_data.dart';

class AuraScoreWidget extends StatelessWidget {
  final SensorData sensorData;

  const AuraScoreWidget({Key? key, required this.sensorData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: sensorData.getRiskColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: sensorData.getRiskColor(), width: 2),
      ),
      child: Column(
        children: [
          Text(
            'AURA Score',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '${sensorData.auraScore.toInt()}',
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: sensorData.getRiskColor(),
            ),
          ),
          Text(
            sensorData.riskLevel,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: sensorData.getRiskColor(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _getRiskDescription(sensorData.riskLevel),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  String _getRiskDescription(String riskLevel) {
    switch (riskLevel) {
      case 'LOW':
        return 'Safe for outdoor activities';
      case 'MODERATE':
        return 'Consider shorter exposure times';
      case 'HIGH':
        return 'Limit outdoor activities, use protection';
      case 'VERY HIGH':
        return 'Avoid outdoor exposure if possible';
      default:
        return 'Waiting for data...';
    }
  }
}
