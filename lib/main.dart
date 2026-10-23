import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/home_screen.dart';
import 'services/pantry_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Dark navigation & status bar
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Color(0xFF0F172A),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final storageService = await PantryStorageService.init();

  runApp(OpenGrubApp(storageService: storageService));
}

class OpenGrubApp extends StatelessWidget {
  final PantryStorageService storageService;

  const OpenGrubApp({
    super.key,
    required this.storageService,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenGrub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0F19),
        primaryColor: const Color(0xFF10B981),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF10B981),
          secondary: Color(0xFF38BDF8),
          surface: Color(0xFF1E293B),
          error: Color(0xFFEF4444),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0B0F19),
          elevation: 0,
          centerTitle: true,
        ),
        fontFamily: 'sans-serif',
      ),
      home: HomeScreen(storageService: storageService),
    );
  }
}
