import 'package:flutter/material.dart';

class ScannerHudOverlay extends StatefulWidget {
  final double scanBoxWidth;
  final double scanBoxHeight;

  const ScannerHudOverlay({
    super.key,
    this.scanBoxWidth = 280,
    this.scanBoxHeight = 180,
  });

  @override
  State<ScannerHudOverlay> createState() => _ScannerHudOverlayState();
}

class _ScannerHudOverlayState extends State<ScannerHudOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, _) {
        return CustomPaint(
          painter: _HudPainter(
            scanBoxWidth: widget.scanBoxWidth,
            scanBoxHeight: widget.scanBoxHeight,
            laserProgress: _animController.value,
          ),
          child: Container(),
        );
      },
    );
  }
}

class _HudPainter extends CustomPainter {
  final double scanBoxWidth;
  final double scanBoxHeight;
  final double laserProgress;

  _HudPainter({
    required this.scanBoxWidth,
    required this.scanBoxHeight,
    required this.laserProgress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;

    final boxRect = Rect.fromCenter(
      center: Offset(cx, cy),
      width: scanBoxWidth,
      height: scanBoxHeight,
    );

    // 1. Darkened outer background mask with cutout
    final bgPaint = Paint()..color = Colors.black.withOpacity(0.55);
    final bgPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRRect(RRect.fromRectAndRadius(boxRect, const Radius.circular(16)))
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(bgPath, bgPaint);

    // 2. Tactical Corner Brackets (Neon Emerald #10B981)
    final bracketPaint = Paint()
      ..color = const Color(0xFF10B981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5
      ..strokeCap = StrokeCap.round;

    const cornerLen = 28.0;

    // Top-Left
    canvas.drawLine(boxRect.topLeft, boxRect.topLeft + const Offset(cornerLen, 0), bracketPaint);
    canvas.drawLine(boxRect.topLeft, boxRect.topLeft + const Offset(0, cornerLen), bracketPaint);

    // Top-Right
    canvas.drawLine(boxRect.topRight, boxRect.topRight + const Offset(-cornerLen, 0), bracketPaint);
    canvas.drawLine(boxRect.topRight, boxRect.topRight + const Offset(0, cornerLen), bracketPaint);

    // Bottom-Left
    canvas.drawLine(boxRect.bottomLeft, boxRect.bottomLeft + const Offset(cornerLen, 0), bracketPaint);
    canvas.drawLine(boxRect.bottomLeft, boxRect.bottomLeft + const Offset(0, -cornerLen), bracketPaint);

    // Bottom-Right
    canvas.drawLine(boxRect.bottomRight, boxRect.bottomRight + const Offset(-cornerLen, 0), bracketPaint);
    canvas.drawLine(boxRect.bottomRight, boxRect.bottomRight + const Offset(0, -cornerLen), bracketPaint);

    // 3. Sweeping Laser Beam
    final laserY = boxRect.top + (boxRect.height * laserProgress);
    final laserPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          const Color(0xFF10B981).withOpacity(0.0),
          const Color(0xFF10B981).withOpacity(0.9),
          const Color(0xFF10B981).withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(boxRect.left, laserY - 1, boxRect.width, 2))
      ..strokeWidth = 2.0;

    canvas.drawLine(
      Offset(boxRect.left + 8, laserY),
      Offset(boxRect.right - 8, laserY),
      laserPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HudPainter oldDelegate) {
    return oldDelegate.laserProgress != laserProgress;
  }
}
