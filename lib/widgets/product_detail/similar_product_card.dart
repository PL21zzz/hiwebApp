import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/product/product_model.dart';
import '../../screens/product/product_detail_screen.dart';

class SimilarProductCard extends StatelessWidget {
  final ProductModel product;

  const SimilarProductCard({
    super.key,
    required this.product,
  });

  String get _brandName {
    if (product.name.contains('Cetaphil')) return 'Cetaphil';
    if (product.name.contains('Healthy Care')) return 'Healthy Care';
    if (product.name.contains('Kirkland')) return 'Kirkland';
    if (product.name.contains('Obagi')) return 'Obagi';
    if (product.name.contains('Anessa')) return 'Anessa';
    if (product.name.contains('Ostelin')) return 'Ostelin';
    return product.category;
  }

  String get _brandInitial =>
      _brandName.isNotEmpty ? _brandName[0].toUpperCase() : 'P';

  Widget _buildCartButton() {
    return Container(
      width: 25,
      height: 25,
      decoration: const BoxDecoration(
        color: Color(0xFFE0F2FE),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Icon(
          LucideIcons.shoppingCart,
          size: 13,
          color: Color(0xFF0284C7),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) =>
                const ProductDetailScreen(),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image with Discount Badge Overlay
              AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.image, color: Colors.grey),
                        ),
                      ),
                    ),
                    if (product.discountPercent > 0)
                      Positioned(
                        top: 6,
                        right: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                              colors: [
                                Color(0xFFFF5200),
                                Color(0xFFEF0078),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '-${product.discountPercent}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              // Product Info Area
              Padding(
                padding: const EdgeInsets.all(7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Brand Logo Avatar & Brand Name Row
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 8,
                          backgroundColor: const Color(0xFF0284C7),
                          child: Text(
                            _brandInitial,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            _brandName,
                            style: const TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF475569),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Product Title (2 lines max)
                    SizedBox(
                      height: 30,
                      child: Text(
                        product.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF1E293B),
                          height: 1.25,
                        ),
                      ),
                    ),

                    const SizedBox(height: 3),

                    // Price Row (Current Red Price + Original Strikethrough Price)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${product.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFE53935),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Text(
                              '${product.originalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ',
                              style: const TextStyle(
                                fontSize: 9.5,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            Positioned(
                              left: 0,
                              right: 0,
                              child: Container(
                                height: 1.0,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 3),

                    // Rating & Sold Row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 12,
                          color: Color(0xFFEAB308),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          product.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF334155),
                          ),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          '| ${product.soldCount} Đã bán',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 4),

                    // 1. Badge "Trong ngày" image (bigger size)
                    Image.network(
                      'https://res.cloudinary.com/dypm5avrx/image/upload/v1789702201/badge_trong_ngay_taqn2t.webp',
                      height: 23,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const SizedBox.shrink(),
                    ),

                    const SizedBox(height: 4),

                    // 2. Location + Cart Button Row
                    Row(
                      children: [
                        const Icon(
                          LucideIcons.mapPin,
                          size: 9.5,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 2),
                        Expanded(
                          child: Text(
                            product.location,
                            style: const TextStyle(
                              fontSize: 9,
                              color: Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        _buildCartButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
