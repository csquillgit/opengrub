import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/food_flag.dart';
import '../models/food_product.dart';

class PantryStorageService extends ChangeNotifier {
  static const String _pantryKey = 'opengrub_scanned_history_v1';
  final SharedPreferences _prefs;

  PantryStorageService(this._prefs) {
    _ensureInitialSamples();
  }

  static Future<PantryStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return PantryStorageService(prefs);
  }

  List<FoodProduct> getProducts() {
    final raw = _prefs.getString(_pantryKey);
    if (raw == null || raw.isEmpty) return [];

    try {
      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      final list = decoded
          .map((item) => FoodProduct.fromMap(item as Map<String, dynamic>))
          .toList();
      list.sort((a, b) => b.scannedAt.compareTo(a.scannedAt));
      return list;
    } catch (_) {
      return [];
    }
  }

  Future<void> saveProduct(FoodProduct product) async {
    final list = getProducts();
    list.removeWhere((p) => p.barcode == product.barcode);
    list.insert(0, product);
    await _save(list);
    notifyListeners();
  }

  Future<void> deleteProduct(String barcode) async {
    final list = getProducts();
    list.removeWhere((p) => p.barcode == barcode);
    await _save(list);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    await _prefs.remove(_pantryKey);
    notifyListeners();
  }

  Future<void> _save(List<FoodProduct> list) async {
    final jsonList = list.map((e) => e.toMap()).toList();
    await _prefs.setString(_pantryKey, json.encode(jsonList));
  }

  // Pre-seed 2 demo items so first launch has immediate data to explore
  void _ensureInitialSamples() {
    if (_prefs.containsKey(_pantryKey)) return;

    final samples = [
      FoodProduct(
        barcode: '044000032029',
        name: 'Oreo Chocolate Sandwich Cookies',
        brand: 'Nabisco',
        novaGroup: 4,
        nutriScore: 'e',
        calories100g: 480,
        caloriesServing: 160,
        protein100g: 4.8,
        proteinServing: 1.6,
        carbs100g: 71.4,
        carbsServing: 24.3,
        fat100g: 21.4,
        fatServing: 7.3,
        fiber100g: 2.4,
        fiberServing: 0.8,
        sodium100g: 380,
        sodiumServing: 129,
        servingSize: '3 cookies (34g)',
        scannedAt: DateTime.now().subtract(const Duration(minutes: 15)),
        ingredientsText:
            'Unbleached enriched flour, sugar, palm and/or canola oil, cocoa, high fructose corn syrup, leavening, salt, soy lecithin, chocolate, artificial flavor.',
        flags: [
          const FoodFlag(
            category: FlagCategory.seedOil,
            title: 'Seed / Industrial Oils',
            matchedTerms: ['palm oil', 'canola oil'],
            severity: FlagSeverity.warning,
            description: 'Refined vegetable/seed oils high in omega-6 linoleic acid.',
          ),
          const FoodFlag(
            category: FlagCategory.refinedSugar,
            title: 'High Fructose Corn Syrup',
            matchedTerms: ['high fructose corn syrup'],
            severity: FlagSeverity.alert,
            description: 'Highly concentrated industrial fructose sweetener.',
          ),
          const FoodFlag(
            category: FlagCategory.emulsifier,
            title: 'Emulsifiers & Stabilizers',
            matchedTerms: ['soy lecithin'],
            severity: FlagSeverity.info,
            description: 'Used for texture suspension and long shelf life.',
          ),
        ],
      ),
      FoodProduct(
        barcode: '016000275263',
        name: 'Original Whole Grain Cheerios',
        brand: 'General Mills',
        novaGroup: 3,
        nutriScore: 'c',
        calories100g: 359,
        caloriesServing: 140,
        protein100g: 12.8,
        proteinServing: 5.0,
        carbs100g: 74.4,
        carbsServing: 29.0,
        fat100g: 6.4,
        fatServing: 2.5,
        fiber100g: 10.3,
        fiberServing: 4.0,
        sodium100g: 487,
        sodiumServing: 190,
        servingSize: '1.5 cups (39g)',
        scannedAt: DateTime.now().subtract(const Duration(hours: 2)),
        ingredientsText:
            'Whole grain oats, corn starch, sugar, salt, tripotassium phosphate, vitamin E.',
        flags: const [],
      ),
    ];

    _save(samples);
  }
}
