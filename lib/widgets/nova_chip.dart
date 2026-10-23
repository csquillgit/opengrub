import 'package:flutter/material.dart';

class NovaChip extends StatelessWidget {
  final int? novaGroup;
  final bool compact;

  const NovaChip({
    super.key,
    required this.novaGroup,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (novaGroup == null) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: compact ? 6 : 10, vertical: compact ? 2 : 4),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          compact ? 'NOVA ?' : 'NOVA Unknown',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: compact ? 10 : 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final Color color;
    final String label;
    final String fullDesc;

    switch (novaGroup) {
      case 1:
        color = const Color(0xFF10B981); // Emerald Green
        label = 'NOVA 1';
        fullDesc = 'Unprocessed / Whole Food';
        break;
      case 2:
        color = const Color(0xFFEAB308); // Yellow
        label = 'NOVA 2';
        fullDesc = 'Culinary Ingredient';
        break;
      case 3:
        color = const Color(0xFFF97316); // Orange
        label = 'NOVA 3';
        fullDesc = 'Processed Food';
        break;
      case 4:
      default:
        color = const Color(0xFFEF4444); // Crimson Red
        label = 'NOVA 4';
        fullDesc = 'Ultra-Processed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 3 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
        border: Border.all(color: color.withOpacity(0.7), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 6 : 8,
            height: compact ? 6 : 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: compact ? 5 : 8),
          Text(
            compact ? label : '$label • $fullDesc',
            style: TextStyle(
              color: color,
              fontSize: compact ? 11 : 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
