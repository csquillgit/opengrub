enum FlagSeverity {
  info,
  warning,
  alert,
}

enum FlagCategory {
  seedOil,
  artificialDye,
  refinedSugar,
  artificialSweetener,
  preservative,
  emulsifier,
}

class FoodFlag {
  final FlagCategory category;
  final String title;
  final List<String> matchedTerms;
  final FlagSeverity severity;
  final String description;

  const FoodFlag({
    required this.category,
    required this.title,
    required this.matchedTerms,
    required this.severity,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'category': category.name,
      'title': title,
      'matchedTerms': matchedTerms,
      'severity': severity.name,
      'description': description,
    };
  }

  factory FoodFlag.fromMap(Map<String, dynamic> map) {
    return FoodFlag(
      category: FlagCategory.values.firstWhere(
        (e) => e.name == map['category'],
        orElse: () => FlagCategory.seedOil,
      ),
      title: map['title'] as String,
      matchedTerms: List<String>.from(map['matchedTerms'] as List),
      severity: FlagSeverity.values.firstWhere(
        (e) => e.name == map['severity'],
        orElse: () => FlagSeverity.warning,
      ),
      description: map['description'] as String,
    );
  }
}
