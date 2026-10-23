import 'package:flutter/material.dart';
import '../models/food_flag.dart';

class FlagBadge extends StatelessWidget {
  final FoodFlag flag;

  const FlagBadge({
    super.key,
    required this.flag,
  });

  @override
  Widget build(BuildContext context) {
    final Color color;
    final IconData icon;

    switch (flag.severity) {
      case FlagSeverity.alert:
        color = const Color(0xFFEF4444);
        icon = Icons.warning_amber_rounded;
        break;
      case FlagSeverity.warning:
        color = const Color(0xFFF59E0B);
        icon = Icons.error_outline_rounded;
        break;
      case FlagSeverity.info:
      default:
        color = const Color(0xFF38BDF8);
        icon = Icons.info_outline_rounded;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  flag.title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          if (flag.matchedTerms.isNotEmpty) ...[
            const SizedBox(height: 6),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: flag.matchedTerms.map((term) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    term,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          const SizedBox(height: 6),
          Text(
            flag.description,
            style: const TextStyle(
              color: Color(0xFF94A3B8),
              fontSize: 12,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
