import 'package:flutter/material.dart';

class SensorCard extends StatelessWidget {
  final String title;
  final String value;
  final String unit;
  final IconData icon;
  final Color color;
  final String status; // Added for status text like "Good", "Excellent"

  const SensorCard({
    Key? key,
    required this.title,
    required this.value,
    required this.unit,
    required this.icon,
    this.color = Colors.blue,
    this.status = '', // Default empty status
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2, // Reduced from 4 for subtler shadow
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(8), // Added margin for better spacing
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white, // Solid white background instead of gradient
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 24, // Increased from 10 for better visibility
              color: color,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14, // Increased from 12
                fontWeight: FontWeight.bold,
                color: Colors.grey[800], // Darker text for better readability
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 28, // Increased from 24
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (unit.isNotEmpty || status.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                unit.isNotEmpty ? unit : status,
                style: TextStyle(
                  fontSize: 14, // Increased from 12
                  color: unit.isNotEmpty
                      ? Colors.grey[600]
                      : color.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
