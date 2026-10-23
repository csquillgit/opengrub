import 'package:flutter/material.dart';

class MacroCard extends StatelessWidget {
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final double? fiber;
  final String label; // "Per Serving" or "Per 100g"

  const MacroCard({
    super.key,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    this.fiber,
    this.label = 'Per 100g',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'NUTRITIONAL MACROS',
                style: TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Color(0xFF38BDF8),
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem(
                title: 'Calories',
                value: calories != null ? '${calories!.round()}' : '--',
                unit: 'kcal',
                color: Colors.white,
              ),
              _buildMacroItem(
                title: 'Protein',
                value: protein != null ? '${protein!.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFF38BDF8), // Cyan
              ),
              _buildMacroItem(
                title: 'Carbs',
                value: carbs != null ? '${carbs!.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFFFBBF24), // Amber
              ),
              _buildMacroItem(
                title: 'Fat',
                value: fat != null ? '${fat!.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFFF87171), // Coral
              ),
              if (fiber != null)
                _buildMacroItem(
                  title: 'Fiber',
                  value: fiber!.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFF34D399), // Emerald
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroItem({
    required String title,
    required String value,
    required String unit,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 4),
        Row(
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(width: 2),
            Text(
              unit,
              style: const TextStyle(
                color: Color(0xFF64748B),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
