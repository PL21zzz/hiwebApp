import 'package:flutter/material.dart';
import '../../../models/product/product_detail_model.dart';
import '../../../models/product/product_model.dart';
import '../../../screens/product/shop_detail_screen.dart';
import 'horizontal_product_list_section.dart';

class ProductReviewsTab extends StatefulWidget {
  final ScrollController? scrollController;
  final ProductDetailModel? productDetail;

  const ProductReviewsTab({
    super.key,
    this.scrollController,
    this.productDetail,
  });

  @override
  State<ProductReviewsTab> createState() => _ProductReviewsTabState();
}

class _ProductReviewsTabState extends State<ProductReviewsTab> {
  int _selectedFilterIndex = 0;

  ProductDetailModel get _detail =>
      widget.productDetail ?? ProductDetailModel.mockSample;

  List<ProductReviewModel> get _filteredReviews {
    if (_selectedFilterIndex == 1) {
      return _detail.reviews.where((r) => r.rating == 5).toList();
    }
    if (_selectedFilterIndex == 2) {
      return _detail.reviews.where((r) => r.photos.isNotEmpty).toList();
    }
    return _detail.reviews;
  }

  Widget _buildFilterChip(String label, int index) {
    final isSelected = _selectedFilterIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilterIndex = index;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFF0F9FF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0284C7) : const Color(0xFFE2E8F0),
            width: isSelected ? 1.2 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? const Color(0xFF0284C7) : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildReviewCard(ProductReviewModel review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Header
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF0284C7),
                backgroundImage: review.userAvatar.isNotEmpty
                    ? NetworkImage(review.userAvatar)
                    : null,
                child: review.userAvatar.isEmpty
                    ? Text(
                        review.userName.isNotEmpty
                            ? review.userName[0].toUpperCase()
                            : 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: const TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          Icons.star,
                          size: 11,
                          color: index < review.rating
                              ? const Color(0xFFEAB308)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                review.date,
                style: const TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Comment Text
          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF334155),
                height: 1.35,
              ),
            ),

          // Photos Grid
          if (review.photos.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: review.photos.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final photoUrl = review.photos[index];
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      photoUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- 1. Shop Profile Card ---
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: const Color(0xFF0284C7),
                    child: Text(
                      _detail.shopProfile.name.isNotEmpty
                          ? _detail.shopProfile.name[0].toUpperCase()
                          : 'P',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _detail.shopProfile.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE0F2FE),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: const Text(
                                'Chính hãng',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0284C7),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Đánh giá ${_detail.shopProfile.rating}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => ShopDetailScreen(
                            shop: _detail.shopProfile,
                          ),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0284C7)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                    ),
                    child: const Text(
                      'Xem Shop',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0284C7),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // --- 2. Customer Reviews Section ---
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đánh giá sản phẩm',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 15,
                        color: Color(0xFFEAB308),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${_detail.rating}/5 (${_detail.reviews.length})',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Filter Chips Row
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                child: Row(
                  children: [
                    _buildFilterChip('Tất cả (${_detail.reviews.length})', 0),
                    _buildFilterChip('5 Sao', 1),
                    _buildFilterChip('Có hình ảnh/Video', 2),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Reviews List
              Column(
                children: _filteredReviews
                    .map((review) => _buildReviewCard(review))
                    .toList(),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // --- 3. Related Products from Shop ("Sản phẩm cùng Shop") ---
        HorizontalProductListSection(
          title: 'Sản phẩm cùng Shop',
          products: ProductModel.mockProducts,
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
