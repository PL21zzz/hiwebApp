import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';

class OverviewProductInfoSection extends StatefulWidget {
  final ProductDetailModel detail;

  const OverviewProductInfoSection({super.key, required this.detail});

  @override
  State<OverviewProductInfoSection> createState() => _OverviewProductInfoSectionState();
}

class _OverviewProductInfoSectionState extends State<OverviewProductInfoSection> {
  late bool _isFavorite;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.detail.isFavorite;
  }

  String _formatPrice(double value) => value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]}.',
      );

  @override
  Widget build(BuildContext context) {
    final detail = widget.detail;
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const _TrophyIcon(size: 16, color: Color(0xFF087A34)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  detail.bestSellerBadge.replaceAll('🌳 ', ''),
                  style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF087A34)),
                ),
              ),
              const Icon(LucideIcons.chevronRight, size: 16, color: Color(0xFF087A34)),
            ],
          ),
          const SizedBox(height: 8),
          RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  alignment: PlaceholderAlignment.middle,
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(4)),
                    child: const Text('Yêu thích', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
                TextSpan(text: detail.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF1E293B), height: 1.35)),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('${_formatPrice(detail.price)}đ', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
              const SizedBox(width: 8),
              Text('${_formatPrice(detail.originalPrice)}đ', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFEF4444), borderRadius: BorderRadius.circular(4)),
                child: Text('-${detail.discountPercent}%', style: const TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text('Đã bán ${detail.soldCount}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
              const SizedBox(width: 4),
              const CircleAvatar(radius: 7, backgroundColor: Color(0xFFCBD5E1), child: Text('?', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white))),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () => setState(() => _isFavorite = !_isFavorite),
                child: Icon(_isFavorite ? Icons.favorite : LucideIcons.heart, size: 18, color: _isFavorite ? const Color(0xFFEF4444) : const Color(0xFF94A3B8)),
              ),
              const Spacer(),
              Text('${detail.rating} ', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF334155))),
              Row(children: List.generate(5, (_) => const Icon(Icons.star, size: 14, color: Color(0xFFEAB308))),),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrophyIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _TrophyIcon({this.size = 17, this.color = const Color(0xFF087A34)});

  @override
  Widget build(BuildContext context) => SizedBox(width: size, height: size, child: CustomPaint(painter: _TrophyPainter(color: color)));
}

class _TrophyPainter extends CustomPainter {
  final Color color;

  _TrophyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24;
    final scaleY = size.height / 24;
    canvas.scale(scaleX, scaleY);
    final fillPaint = Paint()..color = color..style = PaintingStyle.fill;
    final strokePaint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.4..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round;
    final cup = Path()..moveTo(7, 4)..lineTo(17, 4)..lineTo(17, 8)..arcToPoint(const Offset(7, 8), radius: const Radius.circular(5), clockwise: true)..close();
    canvas.drawPath(cup, fillPaint);
    canvas.drawPath(cup, strokePaint);
    final base = Path()..moveTo(8, 21)..lineTo(16, 21)..moveTo(12, 17)..lineTo(12, 21);
    canvas.drawPath(base, strokePaint);
    final handles = Path()..moveTo(7, 6)..lineTo(4, 6)..lineTo(4, 8)..arcToPoint(const Offset(8, 12), radius: const Radius.circular(4), clockwise: false)..moveTo(17, 6)..lineTo(20, 6)..lineTo(20, 8)..arcToPoint(const Offset(16, 12), radius: const Radius.circular(4), clockwise: true);
    canvas.drawPath(handles, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _TrophyPainter oldDelegate) => oldDelegate.color != color;
}
