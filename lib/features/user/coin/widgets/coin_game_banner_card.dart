import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class CoinGameBannerCard extends StatelessWidget {
  const CoinGameBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 270,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0C52A7), Color(0xFF032656)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 1. Top Center Badge: "100% TRÚNG XU"
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF007DFE).withValues(alpha: 0.85),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      '100%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'TRÚNG',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      'XU',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13.5,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 2. Top Right White Cart Icon Button
          Positioned(
            top: 14,
            right: 14,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  LucideIcons.shoppingCart,
                  color: Color(0xFF0097B2),
                  size: 20,
                ),
              ),
            ),
          ),

          // 3. Center Glowing Gift Box Illustration
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 130,
                    height: 130,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFFFD700).withValues(alpha: 0.35),
                        width: 1.5,
                      ),
                    ),
                  ),
                  const Icon(
                    LucideIcons.gift,
                    color: Color(0xFFFFCC00),
                    size: 60,
                  ),
                  const Positioned(
                    top: 24,
                    right: 26,
                    child: Icon(
                      LucideIcons.sparkles,
                      color: Color(0xFFFFE066),
                      size: 22,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 4. Bottom Action Button: "Chạm để nhận xu"
          Positioned(
            bottom: 16,
            left: 36,
            right: 36,
            child: Container(
              height: 42,
              decoration: BoxDecoration(
                color: const Color(0xFFFFB800),
                borderRadius: BorderRadius.circular(21),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  'Chạm để nhận xu',
                  style: TextStyle(
                    color: Color(0xFFB45309),
                    fontSize: 14.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
