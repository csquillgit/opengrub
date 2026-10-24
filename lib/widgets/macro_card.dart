import 'package:flutter/material.dart';
import '../models/food_product.dart';

class MacroCard extends StatefulWidget {
  final FoodProduct product;

  const MacroCard({
    super.key,
    required this.product,
  });

  @override
  State<MacroCard> createState() => _MacroCardState();
}

class _MacroCardState extends State<MacroCard> {
  late bool _showServing;

  @override
  void initState() {
    super.initState();
    // Default to serving if serving data exists, else 100g
    _showServing = widget.product.caloriesServing != null ||
        widget.product.carbsServing != null ||
        widget.product.proteinServing != null;
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;

    final hasServingData = p.caloriesServing != null ||
        p.carbsServing != null ||
        p.proteinServing != null ||
        p.servingSize != null;

    final calories = _showServing
        ? (p.caloriesServing ?? p.calories100g)
        : p.calories100g;

    final protein = _showServing
        ? (p.proteinServing ?? p.protein100g)
        : p.protein100g;

    final carbs = _showServing
        ? (p.carbsServing ?? p.carbs100g)
        : p.carbs100g;

    final fat = _showServing
        ? (p.fatServing ?? p.fat100g)
        : p.fat100g;

    final fiber = _showServing
        ? (p.fiberServing ?? p.fiber100g)
        : p.fiber100g;

    final subtitle = _showServing
        ? (p.servingSize != null && p.servingSize!.isNotEmpty
            ? 'Serving: ${p.servingSize}'
            : 'Per Serving')
        : 'Per 100g';

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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Segmented Toggle Pill (Serving vs 100g)
              if (hasServingData)
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildToggleButton('Serving', _showServing, () {
                        setState(() => _showServing = true);
                      }),
                      _buildToggleButton('100g', !_showServing, () {
                        setState(() => _showServing = false);
                      }),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroItem(
                title: 'Calories',
                value: calories != null ? '${calories.round()}' : '--',
                unit: 'kcal',
                color: Colors.white,
              ),
              _buildMacroItem(
                title: 'Protein',
                value: protein != null ? '${protein.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFF38BDF8), // Cyan
              ),
              _buildMacroItem(
                title: 'Carbs',
                value: carbs != null ? '${carbs.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFFFBBF24), // Amber
              ),
              _buildMacroItem(
                title: 'Fat',
                value: fat != null ? '${fat.toStringAsFixed(1)}' : '--',
                unit: 'g',
                color: const Color(0xFFF87171), // Coral
              ),
              if (fiber != null)
                _buildMacroItem(
                  title: 'Fiber',
                  value: fiber.toStringAsFixed(1),
                  unit: 'g',
                  color: const Color(0xFF34D399), // Emerald
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF10B981) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : const Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
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
