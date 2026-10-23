# OpenGrub 🥦🔍

> **Zero-BS Barcode Food Scanner & Ultra-Processed Food Intelligence**  
> Powered by the global [Open Food Facts](https://world.openfoodfacts.org/) open database (~3M+ products worldwide). 100% Free. No subscriptions, no sponsored products, and no paywalled barcode scans.

---

## ⚡ Features

* **Instant Barcode Scanning**: Powered by `mobile_scanner` (MLKit) with real-time HUD viewfinder, torch toggle, and camera flip.
* **NOVA Processing Classification**: Automatically grades foods from **NOVA 1** (Unprocessed whole foods) to **NOVA 4** (Industrial ultra-processed formulations).
* **Flagged Ingredient Detection Engine**:
  * 🛑 **Seed & Industrial Oils**: Canola, soybean, corn, cottonseed, palm oil.
  * 🛑 **Synthetic Petroleum Dyes**: Red 40, Yellow 5/6, Blue 1.
  * 🛑 **High Fructose Corn Syrup & Refined Syrups**.
  * 🛑 **Artificial Sweeteners**: Sucralose, aspartame, acesulfame K, erythritol.
  * 🛑 **Industrial Emulsifiers & Gums**: Soy lecithin, carrageenan, polysorbates.
* **Macronutrient Breakdown**: Calories, Protein, Carbs, Fat, and Fiber per serving & per 100g.
* **Offline Scanned Pantry**: Automatically caches products locally so your scan history is available with zero cell connection.
* **Food Intelligence Guide**: Learn the science behind NOVA food classification and industrial additives.

---

## 🚀 Getting Started

### Prerequisites
* Flutter SDK (3.0.0+)
* Xcode / iOS device or Android Studio / Android device

### Running the App
```bash
git clone https://github.com/csquillgit/opengrub.git
cd opengrub
flutter pub get
flutter run --release
```

---

## 🛠️ Architecture
```
lib/
├── main.dart
├── models/
│   ├── food_flag.dart
│   └── food_product.dart
├── services/
│   ├── food_api_service.dart
│   └── pantry_storage_service.dart
├── screens/
│   ├── guide_screen.dart
│   ├── home_screen.dart
│   ├── pantry_history_screen.dart
│   ├── product_detail_screen.dart
│   └── scanner_screen.dart
└── widgets/
    ├── flag_badge.dart
    ├── macro_card.dart
    ├── nova_chip.dart
    ├── product_card.dart
    └── scanner_hud_overlay.dart
```

---

## 📄 License
MIT License. Data courtesy of Open Food Facts (ODbL).
