import 'package:flutter/material.dart';

class NovaChip extends StatelessWidget {
  final int? novaGroup;
  final bool compact;

  const NovaChip({super.key, required this.novaGroup, this.compact = false});

  @override
  Widget build(BuildContext context) {
    if (novaGroup == null) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 10,
          vertical: compact ? 2 : 4,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF334155),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          compact ? 'NOVA ?' : 'NOVA Unknown',
          style: TextStyle(
            color: const Color(0xFF94A3B8),
            fontSize: compact ? 10 : 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }

    final Color color;
    final String label;
    final String tag;

    switch (novaGroup) {
      case 1:
        color = const Color(0xFF10B981); // Emerald Green
        label = 'NOVA 1';
        tag = 'Whole Food';
        break;
      case 2:
        color = const Color(0xFFEAB308); // Yellow
        label = 'NOVA 2';
        tag = 'Culinary';
        break;
      case 3:
        color = const Color(0xFFF97316); // Orange
        label = 'NOVA 3';
        tag = 'Processed';
        break;
      case 4:
      default:
        color = const Color(0xFFEF4444); // Crimson Red
        label = 'NOVA 4';
        tag = 'Ultra-Processed';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 9 : 10,
        vertical: compact ? 3.5 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
        border: Border.all(color: color.withValues(alpha: 0.7), width: 1.2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            compact ? label : '$label • $tag',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontSize: 11.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}
