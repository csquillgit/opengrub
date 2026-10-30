import 'package:flutter/material.dart';
import '../services/pantry_storage_service.dart';
import 'guide_screen.dart';
import 'pantry_history_screen.dart';
import 'scanner_screen.dart';

class HomeScreen extends StatefulWidget {
  final PantryStorageService storageService;

  const HomeScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0F19),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          ScannerScreen(
            storageService: widget.storageService,
            isActive: _currentIndex == 0,
          ),
          PantryHistoryScreen(storageService: widget.storageService),
          const GuideScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F172A),
          border: Border(
            top: BorderSide(color: Color(0xFF1E293B), width: 1),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF10B981), // Emerald
          unselectedItemColor: const Color(0xFF64748B),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          unselectedLabelStyle: const TextStyle(fontSize: 11),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code_scanner_rounded),
              activeIcon: Icon(Icons.qr_code_scanner_rounded, size: 26),
              label: 'Scanner',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.kitchen_outlined),
              activeIcon: Icon(Icons.kitchen_rounded, size: 26),
              label: 'Pantry',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded),
              activeIcon: Icon(Icons.menu_book_rounded, size: 26),
              label: 'Food Guide',
            ),
          ],
        ),
      ),
    );
  }
}
