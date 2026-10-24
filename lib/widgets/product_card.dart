import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/food_product.dart';
import 'nova_chip.dart';

class ProductCard extends StatelessWidget {
  final FoodProduct product;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final hasFlags = product.flags.isNotEmpty;
    final cal = product.caloriesServing ?? product.calories100g;
    final calText = cal != null ? '${cal.round()} kcal' : null;
    final timeText = _formatDate(product.scannedAt);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: hasFlags && product.novaGroup == 4
              ? const Color(0xFFEF4444).withOpacity(0.4)
              : const Color(0xFF334155),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Product Thumbnail Image or Food Icon
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    width: 56,
                    height: 56,
                    color: const Color(0xFF0F172A),
                    child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                        ? Image.network(
                            product.imageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(
                              Icons.fastfood_rounded,
                              color: Color(0xFF64748B),
                              size: 26,
                            ),
                          )
                        : const Icon(
                            Icons.fastfood_rounded,
                            color: Color(0xFF64748B),
                            size: 26,
                          ),
                  ),
                ),
                const SizedBox(width: 14),

                // Center Information
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // NOVA and Flags row
                      Row(
                        children: [
                          NovaChip(novaGroup: product.novaGroup, compact: true),
                          if (hasFlags) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444).withOpacity(0.18),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      size: 11, color: Color(0xFFEF4444)),
                                  const SizedBox(width: 3),
                                  Text(
                                    '${product.flags.length} ${product.flags.length == 1 ? 'flag' : 'flags'}',
                                    style: const TextStyle(
                                      color: Color(0xFFEF4444),
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 5),

                      // Product Name
                      Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          height: 1.25,
                        ),
                      ),

                      if (product.brand.isNotEmpty) ...[
                        const SizedBox(height: 2),
                        Text(
                          product.brand,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                          ),
                        ),
                      ],

                      const SizedBox(height: 5),

                      // Calories & Timestamp Row
                      Row(
                        children: [
                          if (calText != null) ...[
                            Text(
                              calText,
                              style: const TextStyle(
                                color: Color(0xFF38BDF8),
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(' • ', style: TextStyle(color: Color(0xFF64748B))),
                          ],
                          Text(
                            timeText,
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 4),

                // Trailing 3-dots Menu
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF94A3B8),
                    size: 20,
                  ),
                  splashRadius: 18,
                  tooltip: 'Options',
                  color: const Color(0xFF1E293B),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFF334155)),
                  ),
                  onSelected: (val) {
                    if (val == 'delete') {
                      onDelete();
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                          SizedBox(width: 10),
                          Text('Remove', style: TextStyle(color: Color(0xFFEF4444), fontSize: 14)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) {
      return diff.inMinutes <= 1 ? 'Just now' : '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24 && dt.day == now.day) {
      return DateFormat('h:mm a').format(dt);
    } else {
      return DateFormat('MMM d').format(dt);
    }
  }
}
