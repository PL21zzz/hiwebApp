import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_footer.dart';
import 'similar_product_card.dart';

class ProductDetailsTab extends StatefulWidget {
  final ScrollController? scrollController;
  final ProductDetailModel? productDetail;
  final Key? similarProductsKey;

  const ProductDetailsTab({
    super.key,
    this.scrollController,
    this.productDetail,
    this.similarProductsKey,
  });

  @override
  State<ProductDetailsTab> createState() => _ProductDetailsTabState();
}

class _ProductDetailsTabState extends State<ProductDetailsTab> {
  bool _isDescriptionExpanded = false;

  ProductDetailModel get _detail =>
      widget.productDetail ?? MockProductRepository().getFallbackDetail();

  @override
  Widget build(BuildContext context) {
    final detail = _detail;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Chi tiết sản phẩm Card matching media_1789700293149.png
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Chi tiết sản phẩm   ♡ Yêu thích  |  ⚑ Báo cáo
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Chi tiết sản phẩm',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Row(
                    children: const [
                      Icon(
                        LucideIcons.heart,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Yêu thích',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text(
                          '|',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                      Icon(
                        LucideIcons.flag,
                        size: 14,
                        color: Color(0xFF64748B),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'Báo cáo',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // Specifications Table
              Column(
                children: detail.specifications.entries.map((entry) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 155,
                          child: Text(
                            entry.key,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            entry.value,
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Color(0xFFF1F5F9),
                ),
              ),

              // Product Description Content
              AnimatedCrossFade(
                firstChild: Text(
                  detail.shortDescription,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF334155),
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                secondChild: Text(
                  detail.fullDescription,
                  style: const TextStyle(
                    fontSize: 12.5,
                    height: 1.5,
                    color: Color(0xFF334155),
                  ),
                ),
                crossFadeState: _isDescriptionExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 250),
              ),

              const SizedBox(height: 12),

              // Bottom Expand/Collapse toggle button
              Center(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isDescriptionExpanded = !_isDescriptionExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4, horizontal: 12),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _isDescriptionExpanded ? 'Thu gọn ' : 'Xem thêm ',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                        Icon(
                          _isDescriptionExpanded
                              ? LucideIcons.chevronUp
                              : LucideIcons.chevronDown,
                          size: 16,
                          color: const Color(0xFF0284C7),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // 80px Grey Gap before "Sản phẩm tương tự"
        Container(
          key: widget.similarProductsKey,
          height: 80,
          color: const Color(0xFFF5F7FA),
        ),

        // 2. Section: Sản phẩm tương tự (4 products grid using SimilarProductCard)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Sản phẩm tương tự',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Xem tất cả ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 1,
                color: Colors.black.withValues(alpha: 0.08),
              ),
              const SizedBox(height: 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 10) / 2;
                  final textSectionHeight =
                      MediaQuery.textScalerOf(context).scale(172.0);
                  final childAspectRatio =
                      cardWidth / (cardWidth + textSectionHeight);

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return SimilarProductCard(
                        product: MockProductRepository().getProducts()[
                          index % MockProductRepository().getProducts().length],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 3. Section: Sản phẩm bạn đã xem (4 products grid using SimilarProductCard)
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Sản phẩm bạn đã xem',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Xem tất cả ',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronRight,
                        size: 14,
                        color: Color(0xFF0284C7),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                height: 1,
                color: Colors.black.withValues(alpha: 0.08),
              ),
              const SizedBox(height: 4),
              LayoutBuilder(
                builder: (context, constraints) {
                  final cardWidth = (constraints.maxWidth - 10) / 2;
                  final textSectionHeight =
                      MediaQuery.textScalerOf(context).scale(172.0);
                  final childAspectRatio =
                      cardWidth / (cardWidth + textSectionHeight);

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: childAspectRatio,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                        final products = MockProductRepository().getProducts();
                        final p = products[(index + 2) % products.length];
                      return SimilarProductCard(product: p);
                    },
                  );
                },
              ),
            ],
          ),
        ),

        // 80px Grey Gap before VietMade Footer
        Container(
          height: 80,
          color: const Color(0xFFF5F7FA),
        ),

        // 4. VietMade Footer
        const VietmadeFooter(),
      ],
    );

    if (widget.scrollController != null) {
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: content,
      );
    }

    return content;
  }
}
