import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/food_flag.dart';
import '../models/food_product.dart';

class FoodApiService {
  static const String _baseUrl = 'https://world.openfoodfacts.org/api/v2/product';
  static const String _userAgent = 'OpenGrubApp - Mobile Client - Version 1.0';

  // Seed oil keyword dictionary
  static const List<String> _seedOilTerms = [
    'canola oil',
    'rapeseed oil',
    'soybean oil',
    'corn oil',
    'cottonseed oil',
    'sunflower oil',
    'safflower oil',
    'palm oil',
    'palm kernel oil',
    'hydrogenated vegetable oil',
    'partially hydrogenated',
    'rice bran oil',
    'grapeseed oil',
  ];

  // Artificial food dyes
  static const List<String> _artificialDyeTerms = [
    'red 40',
    'allura red',
    'yellow 5',
    'tartrazine',
    'yellow 6',
    'sunset yellow',
    'blue 1',
    'brilliant blue',
    'blue 2',
    'green 3',
    'caramel color',
  ];

  // Refined sugars & HFCS
  static const List<String> _sugarTerms = [
    'high fructose corn syrup',
    'corn syrup',
    'corn syrup solids',
    'invert sugar',
    'maltodextrin',
    'dextrose',
  ];

  // Artificial Sweeteners
  static const List<String> _sweetenerTerms = [
    'sucralose',
    'aspartame',
    'acesulfame potassium',
    'acesulfame k',
    'saccharin',
    'erythritol',
  ];

  // Industrial Emulsifiers & Gums
  static const List<String> _emulsifierTerms = [
    'soy lecithin',
    'carrageenan',
    'polysorbate',
    'mono- and diglycerides',
    'monoglycerides',
    'diglycerides',
  ];

  // Chemical Preservatives
  static const List<String> _preservativeTerms = [
    'sodium benzoate',
    'potassium sorbate',
    'bht',
    'bha',
    'tbhq',
    'sodium nitrite',
    'sodium nitrate',
  ];

  static Future<FoodProduct?> fetchProduct(String barcode) async {
    final cleanedBarcode = barcode.trim();
    if (cleanedBarcode.isEmpty) return null;

    final url = Uri.parse('$_baseUrl/$cleanedBarcode.json');
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': _userAgent,
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        return null;
      }

      final data = json.decode(response.body) as Map<String, dynamic>;
      final status = data['status'];
      if (status != 1 && status != '1') {
        return null;
      }

      final productMap = data['product'] as Map<String, dynamic>?;
      if (productMap == null) return null;

      return _parseProduct(cleanedBarcode, productMap);
    } catch (_) {
      return null;
    }
  }

  static FoodProduct _parseProduct(String barcode, Map<String, dynamic> map) {
    final name = (map['product_name'] as String?)?.trim();
    final brand = (map['brands'] as String?)?.trim() ?? '';
    final imageUrl = map['image_url'] as String? ?? map['image_front_url'] as String?;
    final ingredients = map['ingredients_text'] as String?;
    final nova = (map['nova_group'] as num?)?.toInt();
    final nutri = (map['nutriscore_grade'] as String?)?.toLowerCase();

    final nutriments = map['nutriments'] as Map<String, dynamic>? ?? {};

    // Calories
    final cal100g = (nutriments['energy-kcal_100g'] as num?)?.toDouble() ??
        (nutriments['energy-kcal'] as num?)?.toDouble();
    var calServing = (nutriments['energy-kcal_serving'] as num?)?.toDouble();

    // Protein
    final protein100g = (nutriments['proteins_100g'] as num?)?.toDouble() ??
        (nutriments['proteins'] as num?)?.toDouble();
    var proteinServing = (nutriments['proteins_serving'] as num?)?.toDouble();

    // Carbs
    final carbs100g = (nutriments['carbohydrates_100g'] as num?)?.toDouble() ??
        (nutriments['carbohydrates'] as num?)?.toDouble();
    var carbsServing = (nutriments['carbohydrates_serving'] as num?)?.toDouble();

    // Fat
    final fat100g = (nutriments['fat_100g'] as num?)?.toDouble() ??
        (nutriments['fat'] as num?)?.toDouble();
    var fatServing = (nutriments['fat_serving'] as num?)?.toDouble();

    // Fiber
    final fiber100g = (nutriments['fiber_100g'] as num?)?.toDouble() ??
        (nutriments['fiber'] as num?)?.toDouble();
    var fiberServing = (nutriments['fiber_serving'] as num?)?.toDouble();

    // Sodium
    final sodium100g = (nutriments['sodium_100g'] as num?)?.toDouble() ??
        (nutriments['sodium'] as num?)?.toDouble();
    var sodiumServing = (nutriments['sodium_serving'] as num?)?.toDouble();

    final servingSize = map['serving_size'] as String?;
    final servingQuantity = (map['serving_quantity'] as num?)?.toDouble();

    // If serving-specific macros are missing, calculate them from 100g ratio if known
    double? ratio;
    if (servingQuantity != null && servingQuantity > 0) {
      ratio = servingQuantity / 100.0;
    } else if (calServing != null && cal100g != null && cal100g > 0) {
      ratio = calServing / cal100g;
    }

    if (ratio != null) {
      proteinServing ??= protein100g != null ? protein100g * ratio : null;
      carbsServing ??= carbs100g != null ? carbs100g * ratio : null;
      fatServing ??= fat100g != null ? fat100g * ratio : null;
      fiberServing ??= fiber100g != null ? fiber100g * ratio : null;
      sodiumServing ??= sodium100g != null ? sodium100g * ratio : null;
      calServing ??= cal100g != null ? cal100g * ratio : null;
    }

    // Analyze ingredients for flags
    final flags = analyzeIngredients(ingredients ?? '');

    return FoodProduct(
      barcode: barcode,
      name: (name != null && name.isNotEmpty) ? name : 'Scanned Product',
      brand: brand,
      imageUrl: imageUrl,
      ingredientsText: ingredients,
      novaGroup: nova,
      nutriScore: nutri,
      calories100g: cal100g,
      caloriesServing: calServing,
      protein100g: protein100g,
      proteinServing: proteinServing,
      carbs100g: carbs100g,
      carbsServing: carbsServing,
      fat100g: fat100g,
      fatServing: fatServing,
      fiber100g: fiber100g,
      fiberServing: fiberServing,
      sodium100g: sodium100g,
      sodiumServing: sodiumServing,
      servingSize: servingSize,
      scannedAt: DateTime.now(),
      flags: flags,
    );
  }

  static List<FoodFlag> analyzeIngredients(String text) {
    final lower = text.toLowerCase();
    if (lower.isEmpty) return [];

    final List<FoodFlag> flags = [];

    // 1. Seed Oils
    final matchedOils = _matchTerms(lower, _seedOilTerms);
    if (matchedOils.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.seedOil,
        title: 'Seed / Industrial Oils',
        matchedTerms: matchedOils,
        severity: FlagSeverity.warning,
        description: 'Refined vegetable/seed oils high in omega-6 linoleic acid.',
      ));
    }

    // 2. Artificial Dyes
    final matchedDyes = _matchTerms(lower, _artificialDyeTerms);
    if (matchedDyes.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.artificialDye,
        title: 'Synthetic Food Dyes',
        matchedTerms: matchedDyes,
        severity: FlagSeverity.alert,
        description: 'Artificial petroleum-based colorings linked to hyper-reactivity.',
      ));
    }

    // 3. High Fructose Corn Syrup & Refined Syrups
    final matchedSugars = _matchTerms(lower, _sugarTerms);
    if (matchedSugars.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.refinedSugar,
        title: 'High Fructose Corn Syrup / Refined Syrup',
        matchedTerms: matchedSugars,
        severity: FlagSeverity.alert,
        description: 'Highly concentrated industrial fructose and processed sweeteners.',
      ));
    }

    // 4. Artificial Sweeteners
    final matchedSweeteners = _matchTerms(lower, _sweetenerTerms);
    if (matchedSweeteners.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.artificialSweetener,
        title: 'Artificial Sweeteners',
        matchedTerms: matchedSweeteners,
        severity: FlagSeverity.warning,
        description: 'Non-nutritive synthetic sweeteners (e.g. sucralose, aspartame).',
      ));
    }

    // 5. Industrial Emulsifiers & Gums
    final matchedEmulsifiers = _matchTerms(lower, _emulsifierTerms);
    if (matchedEmulsifiers.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.emulsifier,
        title: 'Emulsifiers & Stabilizers',
        matchedTerms: matchedEmulsifiers,
        severity: FlagSeverity.info,
        description: 'Industrial additives used to maintain shelf texture and suspension.',
      ));
    }

    // 6. Chemical Preservatives
    final matchedPreservatives = _matchTerms(lower, _preservativeTerms);
    if (matchedPreservatives.isNotEmpty) {
      flags.add(FoodFlag(
        category: FlagCategory.preservative,
        title: 'Chemical Preservatives',
        matchedTerms: matchedPreservatives,
        severity: FlagSeverity.warning,
        description: 'Synthetic shelf-life extenders (e.g. BHT, sodium benzoate).',
      ));
    }

    return flags;
  }

  static List<String> _matchTerms(String text, List<String> dictionary) {
    final List<String> found = [];
    for (final term in dictionary) {
      if (text.contains(term)) {
        found.add(term);
      }
    }
    return found;
  }
}
