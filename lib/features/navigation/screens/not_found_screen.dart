import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:hiweb_app_management/core/theme/app_colors.dart';

class NotFoundScreen extends StatefulWidget {
  final String? title;
  final String? message;

  const NotFoundScreen({
    super.key,
    this.title,
    this.message,
  });

  @override
  State<NotFoundScreen> createState() => _NotFoundScreenState();
}

class _NotFoundScreenState extends State<NotFoundScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _floatingAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat(reverse: true);

    _floatingAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: Curves.easeInOutSine,
      ),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final outerCircleSize = math.min(screenSize.width * 0.82, 320.0);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary,
                AppColors.primaryDark,
              ],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Top App Bar with back button
                Positioned(
                  top: 8,
                  left: 12,
                  child: IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      LucideIcons.arrowLeft,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),

                // Center Content
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Background White Circle with Floating Mascot
                        SizedBox(
                          width: outerCircleSize + 40,
                          height: outerCircleSize + 40,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer Glow White Circle
                              Container(
                                width: outerCircleSize,
                                height: outerCircleSize,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.22),
                                  shape: BoxShape.circle,
                                ),
                              ),

                              // Inner Pure White Circle
                              Container(
                                width: outerCircleSize * 0.85,
                                height: outerCircleSize * 0.85,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                              ),

                              // Floating Mascot Cat with 404 Sign
                              AnimatedBuilder(
                                animation: _floatingAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(0, _floatingAnimation.value),
                                    child: child,
                                  );
                                },
                                child: SizedBox(
                                  width: outerCircleSize * 0.75,
                                  height: outerCircleSize * 0.75,
                                  child: CustomPaint(
                                    painter: _MascotCatPainter(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 28),

                        // Title Text: "Error!"
                        Text(
                          widget.title ?? 'Error!',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),

                        const SizedBox(height: 10),

                        // Message Subtitle
                        Text(
                          widget.message ??
                              'Mục hoặc trang bạn tìm kiếm\nhiện tại chưa khả dụng...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14.5,
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 36),

                        // Pill Button: "GO BACK"
                        SizedBox(
                          width: 170,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () => Navigator.of(context).pop(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF334155),
                              foregroundColor: Colors.white,
                              elevation: 4,
                              shadowColor: Colors.black38,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'GO BACK',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MascotCatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final scale = w / 200.0;

    final darkPaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.fill;

    final whitePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final yellowPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    final pinkPaint = Paint()
      ..color = const Color(0xFFF472B6)
      ..style = PaintingStyle.fill;

    // 1. Tail
    final tailPath = Path();
    tailPath.moveTo(140 * scale, 160 * scale);
    tailPath.cubicTo(
      180 * scale, 175 * scale,
      170 * scale, 190 * scale,
      130 * scale, 185 * scale,
    );
    tailPath.cubicTo(
      100 * scale, 182 * scale,
      110 * scale, 168 * scale,
      140 * scale, 160 * scale,
    );
    canvas.drawPath(tailPath, darkPaint);

    // 2. Ears
    final leftEar = Path()
      ..moveTo(65 * scale, 55 * scale)
      ..lineTo(50 * scale, 20 * scale)
      ..lineTo(85 * scale, 42 * scale)
      ..close();
    canvas.drawPath(leftEar, darkPaint);

    final leftEarInner = Path()
      ..moveTo(66 * scale, 50 * scale)
      ..lineTo(55 * scale, 28 * scale)
      ..lineTo(80 * scale, 42 * scale)
      ..close();
    canvas.drawPath(leftEarInner, pinkPaint);

    final rightEar = Path()
      ..moveTo(135 * scale, 55 * scale)
      ..lineTo(150 * scale, 20 * scale)
      ..lineTo(115 * scale, 42 * scale)
      ..close();
    canvas.drawPath(rightEar, darkPaint);

    final rightEarInner = Path()
      ..moveTo(134 * scale, 50 * scale)
      ..lineTo(145 * scale, 28 * scale)
      ..lineTo(120 * scale, 42 * scale)
      ..close();
    canvas.drawPath(rightEarInner, pinkPaint);

    // 3. Body base & Head Shape
    final bodyPath = Path();
    bodyPath.moveTo(60 * scale, 70 * scale);
    bodyPath.cubicTo(
      40 * scale, 120 * scale,
      45 * scale, 170 * scale,
      80 * scale, 175 * scale,
    );
    bodyPath.lineTo(120 * scale, 175 * scale);
    bodyPath.cubicTo(
      155 * scale, 170 * scale,
      160 * scale, 120 * scale,
      140 * scale, 70 * scale,
    );
    bodyPath.cubicTo(
      130 * scale, 40 * scale,
      70 * scale, 40 * scale,
      60 * scale, 70 * scale,
    );
    canvas.drawPath(bodyPath, darkPaint);

    // White chest & face patch
    final chestPath = Path();
    chestPath.moveTo(75 * scale, 65 * scale);
    chestPath.cubicTo(
      60 * scale, 110 * scale,
      65 * scale, 165 * scale,
      100 * scale, 170 * scale,
    );
    chestPath.cubicTo(
      135 * scale, 165 * scale,
      140 * scale, 110 * scale,
      125 * scale, 65 * scale,
    );
    chestPath.cubicTo(
      115 * scale, 45 * scale,
      85 * scale, 45 * scale,
      75 * scale, 65 * scale,
    );
    canvas.drawPath(chestPath, whitePaint);

    // 4. Eyes (Sleepy / Bored 404 eyes)
    final eyePaint = Paint()
      ..color = const Color(0xFF334155)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.5 * scale
      ..strokeCap = StrokeCap.round;

    final leftEye = Path()
      ..moveTo(76 * scale, 65 * scale)
      ..cubicTo(
        82 * scale, 60 * scale,
        88 * scale, 60 * scale,
        92 * scale, 66 * scale,
      );
    canvas.drawPath(leftEye, eyePaint);

    final rightEye = Path()
      ..moveTo(108 * scale, 66 * scale)
      ..cubicTo(
        112 * scale, 60 * scale,
        118 * scale, 60 * scale,
        124 * scale, 65 * scale,
      );
    canvas.drawPath(rightEye, eyePaint);

    // Nose & Mouth
    final nosePath = Path()
      ..moveTo(97 * scale, 72 * scale)
      ..lineTo(103 * scale, 72 * scale)
      ..lineTo(100 * scale, 76 * scale)
      ..close();
    canvas.drawPath(nosePath, pinkPaint);

    final mouthPath = Path()
      ..moveTo(100 * scale, 76 * scale)
      ..lineTo(100 * scale, 80 * scale)
      ..moveTo(95 * scale, 82 * scale)
      ..cubicTo(
        97 * scale, 85 * scale,
        100 * scale, 84 * scale,
        100 * scale, 80 * scale,
      )
      ..cubicTo(
        100 * scale, 84 * scale,
        103 * scale, 85 * scale,
        105 * scale, 82 * scale,
      );
    canvas.drawPath(mouthPath, eyePaint);

    // Paws (Feet) at bottom
    canvas.drawCircle(Offset(50 * scale, 155 * scale), 14 * scale, darkPaint);
    canvas.drawCircle(Offset(50 * scale, 155 * scale), 10 * scale, pinkPaint);

    canvas.drawCircle(Offset(150 * scale, 155 * scale), 14 * scale, darkPaint);
    canvas.drawCircle(Offset(150 * scale, 155 * scale), 10 * scale, pinkPaint);

    // 5. 404 Yellow Signboard held by cat
    final signRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(62 * scale, 92 * scale, 76 * scale, 48 * scale),
      Radius.circular(8 * scale),
    );

    // Signboard shadow
    canvas.drawRRect(
      signRect.shift(Offset(0, 3 * scale)),
      Paint()..color = const Color(0xFFD97706),
    );
    // Signboard fill
    canvas.drawRRect(signRect, yellowPaint);
    // Signboard border
    canvas.drawRRect(
      signRect,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5 * scale,
    );

    // Draw "404" Text on Signboard
    final textPainter = TextPainter(
      text: TextSpan(
        text: '404',
        style: TextStyle(
          color: Colors.white,
          fontSize: 26 * scale,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5 * scale,
          shadows: [
            Shadow(
              color: const Color(0xFFB45309),
              offset: Offset(1.5 * scale, 1.5 * scale),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        62 * scale + (76 * scale - textPainter.width) / 2,
        92 * scale + (48 * scale - textPainter.height) / 2,
      ),
    );

    // Front Paws holding the board
    canvas.drawCircle(Offset(64 * scale, 114 * scale), 8 * scale, darkPaint);
    canvas.drawCircle(Offset(64 * scale, 114 * scale), 6 * scale, whitePaint);

    canvas.drawCircle(Offset(136 * scale, 114 * scale), 8 * scale, darkPaint);
    canvas.drawCircle(Offset(136 * scale, 114 * scale), 6 * scale, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
