import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'horizontal_product_list_section.dart';
import 'shop_profile_summary_card.dart';
import 'customer_reviews_summary_section.dart';

class ProductReviewsTab extends StatefulWidget {
  final ScrollController? scrollController;
  final ProductDetailModel? productDetail;
  final VoidCallback? onViewAllReviews;

  const ProductReviewsTab({
    super.key,
    this.scrollController,
    this.productDetail,
    this.onViewAllReviews,
  });

  @override
  State<ProductReviewsTab> createState() => _ProductReviewsTabState();
}

class _ProductReviewsTabState extends State<ProductReviewsTab> {
  ProductDetailModel get _detail =>
      widget.productDetail ?? MockProductRepository().getFallbackDetail();

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Shop Profile Card ---
        ShopProfileSummaryCard(
          shopProfile: _detail.shopProfile,
        ),

        const SizedBox(height: 8),

        // --- 2. Customer Reviews Section ---
        CustomerReviewsSummarySection(
          detail: _detail,
          onViewAllReviews: widget.onViewAllReviews,
        ),

        const SizedBox(height: 8),

        // --- 3. Related Products from Shop ("Sản phẩm cùng Shop") ---
        HorizontalProductListSection(
          title: 'Sản phẩm cùng Shop',
          products: MockProductRepository().getProducts(),
        ),

        const SizedBox(height: 12),
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
