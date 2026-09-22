import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/product/product_model.dart';
import '../../../screens/product/product_detail_screen.dart';

class HorizontalProductListSection extends StatefulWidget {
  final String? title;
  final List<String>? tabs;
  final List<ProductModel> products;
  final bool showExtraBadges;

  const HorizontalProductListSection({
    super.key,
    this.title,
    this.tabs,
    required this.products,
    this.showExtraBadges = false,
  });

  @override
  State<HorizontalProductListSection> createState() =>
      _HorizontalProductListSectionState();
}

class _HorizontalProductListSectionState
    extends State<HorizontalProductListSection> {
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<ProductModel> displayedProducts = widget.products;

    if (widget.tabs != null && widget.tabs!.isNotEmpty) {
      if (_selectedTabIndex == 1) {
        // TPCN filter
        displayedProducts = widget.products
            .where((p) => p.category == 'Y tế' || p.category == 'TPCN')
            .toList();
        if (displayedProducts.isEmpty) displayedProducts = widget.products;
      } else if (_selectedTabIndex == 2) {
        // Mỹ phẩm filter
        displayedProducts = widget.products
            .where((p) => p.category == 'Dưỡng da' || p.category == 'Mỹ phẩm')
            .toList();
        if (displayedProducts.isEmpty) displayedProducts = widget.products;
      }
    }

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Either single Title OR Interactive Tab Row
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
            child: widget.tabs != null && widget.tabs!.isNotEmpty
                ? Row(
                    children: List.generate(widget.tabs!.length, (index) {
                      final isSelected = _selectedTabIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 18),
                          child: Text(
                            widget.tabs![index],
                            style: TextStyle(
                              fontSize: isSelected ? 15 : 14.5,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w600,
                              color: isSelected
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      );
                    }),
                  )
                : Text(
                    widget.title ?? '',
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
          ),

          // Horizontal Products ListView
          SizedBox(
            height: 245,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: displayedProducts.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final product = displayedProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (context, anim1, anim2) =>
                            ProductDetailScreen(product: product),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    );
                  },
                  child: Container(
                  width: 138,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFF1F5F9),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
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
                        // Image & Badges Stack (Discount Badge top-right, Extra Badges bottom-left)
                        Stack(
                          children: [
                            AspectRatio(
                              aspectRatio: 1.0,
                              child: Image.network(
                                product.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            if (product.discountPercent > 0)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                    vertical: 3,
                                  ),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE53935),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(6),
                                    ),
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
                            // Optional Extra Badges Overlaid on top of image (Bottom-Left)
                            if (widget.showExtraBadges)
                              Positioned(
                                left: 4,
                                bottom: 4,
                                child: Row(
                                  children: [
                                    // Voucher Xtra Badge (Orange)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF9800),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        'VOUCHER XTRA',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 3),
                                    // VietMade Badge (Cyan/Blue)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00ACC1),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Text(
                                        'VietMade',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        // Product Details
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Yêu thích badge + Name inline
                              SizedBox(
                                height: 32,
                                child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(
                                    children: [
                                      if (product.isFavorite)
                                        WidgetSpan(
                                          alignment:
                                              PlaceholderAlignment.middle,
                                          child: Container(
                                            margin: const EdgeInsets.only(
                                                right: 4),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                              vertical: 1,
                                            ),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFE53935),
                                              borderRadius:
                                                  BorderRadius.circular(3),
                                            ),
                                            child: const Text(
                                              'Yêu thích',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 9,
                                                fontWeight: FontWeight.bold,
                                                height: 1.1,
                                              ),
                                            ),
                                          ),
                                        ),
                                      TextSpan(
                                        text: product.name,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF334155),
                                          fontWeight: FontWeight.w400,
                                          height: 1.25,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              // Price row (Red current price + grey original price with centered horizontal strikethrough line)
                              SizedBox(
                                height: 20,
                                child: Row(
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
                              ),
                              const SizedBox(height: 2),
                              // Rating & Sold Row
                              SizedBox(
                                height: 16,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.star,
                                      size: 11,
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
                                      '| Đã bán ${product.soldCount}',
                                      style: const TextStyle(
                                        fontSize: 9.5,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 2),
                              // Location Row
                              SizedBox(
                                height: 16,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      LucideIcons.mapPin,
                                      size: 10,
                                      color: Color(0xFF94A3B8),
                                    ),
                                    const SizedBox(width: 2),
                                    Expanded(
                                      child: Text(
                                        product.location,
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          color: Color(0xFF64748B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
