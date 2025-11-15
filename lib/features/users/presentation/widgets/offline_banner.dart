import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          Icon(Icons.wifi_off, color: Colors.orange.shade700, size: 18),
          const SizedBox(width: 8),
          Text(
            'You are offline. Showing cached data if available.',
            style: TextStyle(color: Colors.orange.shade700),
          ),
        ],
      ),
    );
  }
}
