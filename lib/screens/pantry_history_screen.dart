import 'package:flutter/material.dart';
import '../models/food_product.dart';
import '../services/pantry_storage_service.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class PantryHistoryScreen extends StatefulWidget {
  final PantryStorageService storageService;

  const PantryHistoryScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<PantryHistoryScreen> createState() => _PantryHistoryScreenState();
}

class _PantryHistoryScreenState extends State<PantryHistoryScreen> {
  String _searchQuery = '';
  String _selectedFilter = 'All'; // 'All', 'NOVA 4', 'NOVA 1', 'Flagged'

  @override
  void initState() {
    super.initState();
    widget.storageService.addListener(_onStorageChanged);
  }

  @override
  void dispose() {
    widget.storageService.removeListener(_onStorageChanged);
    super.dispose();
  }

  void _onStorageChanged() {
    if (mounted) setState(() {});
  }

  List<FoodProduct> _getFilteredProducts() {
    final all = widget.storageService.getProducts();
    return all.where((p) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = p.name.toLowerCase().contains(q);
        final matchBrand = p.brand.toLowerCase().contains(q);
        final matchBarcode = p.barcode.contains(q);
        if (!matchName && !matchBrand && !matchBarcode) return false;
      }

      // Category filter
      if (_selectedFilter == 'NOVA 4') {
        return p.novaGroup == 4;
      } else if (_selectedFilter == 'NOVA 1') {
        return p.novaGroup == 1;
      } else if (_selectedFilter == 'Flagged') {
        return p.flags.isNotEmpty;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final all = widget.storageService.getProducts();
    final filtered = _getFilteredProducts();

    // Stats
    final total = all.length;
    final ultraCount = all.where((p) => p.novaGroup == 4).length;
    final cleanCount = all.where((p) => p.novaGroup == 1).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'SCANNED PANTRY',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.5,
            fontSize: 16,
          ),
        ),
        actions: [
          if (all.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded, color: Color(0xFF94A3B8)),
              tooltip: 'Clear History',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: const Color(0xFF1E293B),
                    title: const Text('Clear Pantry History?',
                        style: TextStyle(color: Colors.white)),
                    content: const Text(
                      'Are you sure you want to remove all scanned items?',
                      style: TextStyle(color: Color(0xFF94A3B8)),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEF4444)),
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Clear All'),
                      ),
                    ],
                  ),
                );
                if (confirm == true) {
                  await widget.storageService.clearHistory();
                }
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              style: const TextStyle(color: Colors.white, fontSize: 14),
              onChanged: (val) => setState(() => _searchQuery = val.trim()),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                hintText: 'Search scanned items or brands...',
                hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 14),
                prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B), size: 20),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                ),
              ),
            ),
          ),

          // 2. Overview Stats Dashboard Bar (Balanced 3-column layout)
          if (total > 0)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSummaryMetric(
                      count: total.toString(),
                      label: 'Scanned',
                      color: const Color(0xFF38BDF8),
                    ),
                  ),
                  Container(width: 1, height: 26, color: const Color(0xFF334155)),
                  Expanded(
                    child: _buildSummaryMetric(
                      count: ultraCount.toString(),
                      label: 'NOVA 4',
                      color: const Color(0xFFEF4444),
                    ),
                  ),
                  Container(width: 1, height: 26, color: const Color(0xFF334155)),
                  Expanded(
                    child: _buildSummaryMetric(
                      count: cleanCount.toString(),
                      label: 'Whole Food',
                      color: const Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
            ),

          // 3. Filter Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildFilterChip('All'),
                _buildFilterChip('NOVA 4'),
                _buildFilterChip('NOVA 1'),
                _buildFilterChip('Flagged'),
              ],
            ),
          ),

          // 4. Product List
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E293B),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.kitchen_outlined,
                            size: 44,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No items found',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Scan barcodes to build your offline pantry history.',
                          style: TextStyle(color: Color(0xFF64748B), fontSize: 13),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 4, bottom: 84),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final product = filtered[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => ProductDetailScreen(
                                product: product,
                                storageService: widget.storageService,
                              ),
                            ),
                          );
                        },
                        onDelete: () => widget.storageService.deleteProduct(product.barcode),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryMetric({
    required String count,
    required String label,
    required Color color,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          count,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF94A3B8),
            fontSize: 11,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => setState(() => _selectedFilter = label),
        selectedColor: const Color(0xFF10B981),
        backgroundColor: const Color(0xFF1E293B),
        labelStyle: TextStyle(
          color: isSelected ? Colors.black : const Color(0xFF94A3B8),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
        side: BorderSide(
          color: isSelected ? const Color(0xFF10B981) : const Color(0xFF334155),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
