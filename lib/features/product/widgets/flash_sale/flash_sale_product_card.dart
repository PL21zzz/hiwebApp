import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/product/screens/product_detail_screen.dart';
import 'package:hiweb_app_management/core/widgets/common/images/app_image.dart';
import 'package:hiweb_app_management/core/utils/currency_formatter.dart';

class FlashSaleProductCard extends StatelessWidget {
  final ProductModel item;
  final bool isLive;
  final VoidCallback onPurchaseTap;

  const FlashSaleProductCard({
    super.key,
    required this.item,
    required this.isLive,
    required this.onPurchaseTap,
  });

  String _formatPrice(double price) => CurrencyFormatter.format(price);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Image (Discount Badge ONLY shown if isLive == true)
            SizedBox(
              width: 95,
              height: 95,
              child: Stack(
                children: [
                  AppImage(
                    imageUrl: item.imageUrl,
                    width: 95,
                    height: 95,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  if (isLive)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          '-${item.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right: Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // BÁN CHẠY Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'BÁN CHẠY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price Section
                  if (isLive) ...[
                    // Original Price
                    Text(
                      _formatPrice(item.originalPrice),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFFA1A1AA),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    // Flash Sale Price
                    Text(
                      _formatPrice(item.price),
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ] else ...[
                    // Hidden Price for Upcoming Slot
                    const Text(
                      '???.000đ',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),

                  // Bottom Row: Progress / Status Bar & Action Button
                  Row(
                    children: [
                      // Progress Bar
                      Expanded(
                        child: Container(
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFED7AA),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: isLive ? 0.75 : 0.45,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6A00),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  isLive
                                      ? 'ĐÃ BÁN ${item.soldCount}'
                                      : 'SẮP MỞ BÁN',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Button: Mua ngay (live) vs Chi tiết (upcoming)
                      ElevatedButton(
                        onPressed: () {
                          if (isLive) {
                            onPurchaseTap();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: item),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLive
                              ? const Color(0xFFE53935)
                              : const Color(0xFFFF7300),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          isLive ? 'Mua ngay' : 'Chi tiết',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
