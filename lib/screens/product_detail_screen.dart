import 'package:flutter/material.dart';
import '../models/food_product.dart';
import '../services/pantry_storage_service.dart';
import '../widgets/flag_badge.dart';
import '../widgets/macro_card.dart';
import '../widgets/nova_chip.dart';

class ProductDetailScreen extends StatefulWidget {
  final FoodProduct product;
  final PantryStorageService storageService;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.storageService,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late FoodProduct _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final hasFlags = _product.flags.isNotEmpty;
    final isUltraProcessed = _product.novaGroup == 4;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B0F19),
        elevation: 0,
        title: const Text(
          'FOOD ANALYSIS',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444)),
            tooltip: 'Remove from Pantry',
            onPressed: () async {
              await widget.storageService.deleteProduct(_product.barcode);
              if (mounted) Navigator.of(context).pop();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Hero Card: Image + Title + Brand
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isUltraProcessed
                      ? const Color(0xFFEF4444).withOpacity(0.5)
                      : const Color(0xFF334155),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 80,
                      height: 80,
                      color: const Color(0xFF0F172A),
                      child: _product.imageUrl != null && _product.imageUrl!.isNotEmpty
                          ? Image.network(
                              _product.imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => const Icon(
                                Icons.fastfood_rounded,
                                color: Color(0xFF64748B),
                                size: 36,
                              ),
                            )
                          : const Icon(
                              Icons.fastfood_rounded,
                              color: Color(0xFF64748B),
                              size: 36,
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        NovaChip(novaGroup: _product.novaGroup),
                        const SizedBox(height: 8),
                        Text(
                          _product.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            height: 1.25,
                          ),
                        ),
                        if (_product.brand.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            _product.brand,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                        const SizedBox(height: 6),
                        Text(
                          'UPC: ${_product.barcode}',
                          style: const TextStyle(
                            color: Color(0xFF64748B),
                            fontSize: 11,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // NOVA Verdict Banner
            _buildVerdictBanner(isUltraProcessed),
            const SizedBox(height: 16),

            // Flagged Ingredients Section
            if (hasFlags) ...[
              const Text(
                'FLAGGED INGREDIENTS',
                style: TextStyle(
                  color: Color(0xFFEF4444),
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 8),
              ..._product.flags.map((flag) => FlagBadge(flag: flag)),
              const SizedBox(height: 16),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF10B981).withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle_outline_rounded, color: Color(0xFF10B981), size: 22),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Clean Ingredients: No seed oils, artificial dyes, or HFCS detected.',
                        style: TextStyle(
                          color: Color(0xFF10B981),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Macro Nutrients Card with interactive Serving / 100g toggle
            MacroCard(product: _product),
            const SizedBox(height: 20),

            // Ingredients Text Section
            const Text(
              'INGREDIENT LIST',
              style: TextStyle(
                color: Color(0xFF94A3B8),
                fontSize: 11,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Text(
                _product.ingredientsText != null && _product.ingredientsText!.isNotEmpty
                    ? _product.ingredientsText!
                    : 'No detailed ingredient list available from open database.',
                style: const TextStyle(
                  color: Color(0xFFCBD5E1),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildVerdictBanner(bool isUltra) {
    if (_product.novaGroup == 1) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF10B981).withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.eco_rounded, color: Color(0xFF10B981), size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'NOVA 1: Whole Food / Minimal Processing. Real, single-ingredient or natural food state.',
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
              ),
            ),
          ],
        ),
      );
    } else if (isUltra) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEF4444).withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Color(0xFFEF4444), size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'NOVA 4: Ultra-Processed Formulation. Made using industrial extractions, additives, and high-intensity processing.',
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
              ),
            ),
          ],
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF59E0B).withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFF59E0B).withOpacity(0.5)),
        ),
        child: const Row(
          children: [
            Icon(Icons.tune_rounded, color: Color(0xFFF59E0B), size: 24),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                'Moderately Processed: Culinary ingredients or simple preservation applied.',
                style: TextStyle(color: Colors.white, fontSize: 13, height: 1.3),
              ),
            ),
          ],
        ),
      );
    }
  }
}
