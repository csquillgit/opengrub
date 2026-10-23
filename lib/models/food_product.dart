import 'dart:convert';
import 'food_flag.dart';

class FoodProduct {
  final String barcode;
  final String name;
  final String brand;
  final String? imageUrl;
  final String? ingredientsText;
  final int? novaGroup; // 1 to 4
  final String? nutriScore; // 'a', 'b', 'c', 'd', 'e'
  final double? calories100g;
  final double? caloriesServing;
  final double? protein100g;
  final double? carbs100g;
  final double? fat100g;
  final double? fiber100g;
  final double? sodium100g;
  final String? servingSize;
  final DateTime scannedAt;
  final List<FoodFlag> flags;

  const FoodProduct({
    required this.barcode,
    required this.name,
    required this.brand,
    this.imageUrl,
    this.ingredientsText,
    this.novaGroup,
    this.nutriScore,
    this.calories100g,
    this.caloriesServing,
    this.protein100g,
    this.carbs100g,
    this.fat100g,
    this.fiber100g,
    this.sodium100g,
    this.servingSize,
    required this.scannedAt,
    this.flags = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'barcode': barcode,
      'name': name,
      'brand': brand,
      'imageUrl': imageUrl,
      'ingredientsText': ingredientsText,
      'novaGroup': novaGroup,
      'nutriScore': nutriScore,
      'calories100g': calories100g,
      'caloriesServing': caloriesServing,
      'protein100g': protein100g,
      'carbs100g': carbs100g,
      'fat100g': fat100g,
      'fiber100g': fiber100g,
      'sodium100g': sodium100g,
      'servingSize': servingSize,
      'scannedAt': scannedAt.toIso8601String(),
      'flags': flags.map((f) => f.toMap()).toList(),
    };
  }

  factory FoodProduct.fromMap(Map<String, dynamic> map) {
    return FoodProduct(
      barcode: map['barcode'] as String,
      name: map['name'] as String? ?? 'Unknown Product',
      brand: map['brand'] as String? ?? '',
      imageUrl: map['imageUrl'] as String?,
      ingredientsText: map['ingredientsText'] as String?,
      novaGroup: map['novaGroup'] as int?,
      nutriScore: map['nutriScore'] as String?,
      calories100g: (map['calories100g'] as num?)?.toDouble(),
      caloriesServing: (map['caloriesServing'] as num?)?.toDouble(),
      protein100g: (map['protein100g'] as num?)?.toDouble(),
      carbs100g: (map['carbs100g'] as num?)?.toDouble(),
      fat100g: (map['fat100g'] as num?)?.toDouble(),
      fiber100g: (map['fiber100g'] as num?)?.toDouble(),
      sodium100g: (map['sodium100g'] as num?)?.toDouble(),
      servingSize: map['servingSize'] as String?,
      scannedAt: map['scannedAt'] != null
          ? DateTime.parse(map['scannedAt'] as String)
          : DateTime.now(),
      flags: map['flags'] != null
          ? (map['flags'] as List)
              .map((f) => FoodFlag.fromMap(f as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }

  String toJson() => json.encode(toMap());

  factory FoodProduct.fromJson(String source) =>
      FoodProduct.fromMap(json.decode(source) as Map<String, dynamic>);
}
