import 'package:flutter/material.dart';
import '../data/models/incident_model.dart';

class DangerBadge extends StatelessWidget {
  final DangerLevel level;

  const DangerBadge({super.key, required this.level});

  @override
  Widget build(BuildContext context) {
    final config = _config();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: config['bg'] as Color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        config['label'] as String,
        style: TextStyle(
          color: config['text'] as Color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Map<String, dynamic> _config() {
    switch (level) {
      case DangerLevel.bajo:
        return {
          'bg': const Color(0xFFFEF3C7),
          'text': const Color(0xFF92400E),
          'label': 'Bajo',
        };
      case DangerLevel.medio:
        return {
          'bg': const Color(0xFFFFEDD5),
          'text': const Color(0xFF9A3412),
          'label': 'Medio',
        };
      case DangerLevel.alto:
        return {
          'bg': const Color(0xFFFEE2E2),
          'text': const Color(0xFF991B1B),
          'label': 'Alto',
        };
    }
  }
}
