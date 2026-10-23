import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/food_product.dart';
import '../services/food_api_service.dart';
import '../services/pantry_storage_service.dart';
import '../widgets/scanner_hud_overlay.dart';
import 'product_detail_screen.dart';

class ScannerScreen extends StatefulWidget {
  final PantryStorageService storageService;

  const ScannerScreen({
    super.key,
    required this.storageService,
  });

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
    torchEnabled: false,
  );

  bool _isScanning = true;
  bool _isLoading = false;
  String? _lastScannedBarcode;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (!_isScanning || _isLoading) return;

    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      final code = barcode.rawValue;
      if (code != null && code.isNotEmpty && code != _lastScannedBarcode) {
        _handleBarcode(code);
        break;
      }
    }
  }

  Future<void> _handleBarcode(String code) async {
    setState(() {
      _isLoading = true;
      _isScanning = false;
      _lastScannedBarcode = code;
    });

    final product = await FoodApiService.fetchProduct(code);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    if (product != null) {
      await widget.storageService.saveProduct(product);
      if (!mounted) return;

      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(
            product: product,
            storageService: widget.storageService,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFEF4444),
          content: Text('Product not found for barcode: $code'),
          action: SnackBarAction(
            label: 'Try Again',
            textColor: Colors.white,
            onPressed: () {},
          ),
        ),
      );
    }

    // Resume scanning after brief cooldown
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _isScanning = true;
          _lastScannedBarcode = null;
        });
      }
    });
  }

  void _showManualEntryDialog() {
    final textController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E293B),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Enter Barcode (UPC)',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Type or paste any 8-14 digit food barcode:',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textController,
              keyboardType: TextInputType.number,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 16),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF0F172A),
                hintText: 'e.g. 044000032029 (Oreo)',
                hintStyle: const TextStyle(color: Color(0xFF475569)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF334155)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF10B981), width: 1.5),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _buildDemoBarcodeChip('Oreo', '044000032029', textController),
                _buildDemoBarcodeChip('Cheerios', '016000275263', textController),
                _buildDemoBarcodeChip('Coca-Cola', '049000028904', textController),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel', style: TextStyle(color: Color(0xFF94A3B8))),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              final code = textController.text.trim();
              if (code.isNotEmpty) {
                Navigator.of(ctx).pop();
                _handleBarcode(code);
              }
            },
            child: const Text('Lookup', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoBarcodeChip(
      String label, String code, TextEditingController controller) {
    return InkWell(
      onTap: () => controller.text = code,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Text(
          '$label ➔',
          style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Camera Viewfinder
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),

          // 2. Tactical HUD Reticle Overlay
          const ScannerHudOverlay(
            scanBoxWidth: 280,
            scanBoxHeight: 180,
          ),

          // 3. Top Controls Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.qr_code_scanner_rounded, color: Color(0xFF10B981), size: 16),
                        SizedBox(width: 6),
                        Text(
                          'OPENGRUB SCANNER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Torch and Switch Camera buttons
                  Row(
                    children: [
                      _buildHeaderButton(
                        icon: Icons.flash_on_rounded,
                        onPressed: () => _controller.toggleTorch(),
                      ),
                      const SizedBox(width: 8),
                      _buildHeaderButton(
                        icon: Icons.flip_camera_ios_rounded,
                        onPressed: () => _controller.switchCamera(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Manual Entry Action & Help
          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Column(
              children: [
                if (_isLoading) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF10B981), width: 1.5),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            color: Color(0xFF10B981),
                          ),
                        ),
                        SizedBox(width: 12),
                        Text(
                          'Fetching from Open Food Facts...',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E293B).withOpacity(0.9),
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFF334155)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onPressed: _showManualEntryDialog,
                  icon: const Icon(Icons.keyboard_alt_outlined, color: Color(0xFF38BDF8), size: 20),
                  label: const Text(
                    'Enter Barcode Manually',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required VoidCallback onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF334155)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
      ),
    );
  }
}
