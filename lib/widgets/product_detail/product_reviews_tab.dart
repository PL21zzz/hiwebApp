import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/product_detail_model.dart';
import '../../models/product_model.dart';
import 'fullscreen_video_modal.dart';
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
  ProductDetailModel get _detail =>
      widget.productDetail ?? ProductDetailModel.mockSample;

  void _openReviewImageFullscreen(List<String> photos, int initialIndex) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => FullscreenVideoModal(
        mediaList: photos
            .map((url) => ProductMediaModel(
                  type: 'image',
                  url: url,
                  thumb: url,
                  title: 'Ảnh đánh giá',
                ))
            .toList(),
        initialIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = _detail;
    final shop = detail.shopProfile;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Rating Summary Header Card matching sample media_1789697247037.png
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Rating row: 4.9 ★★★★★ (16) >
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${detail.rating}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Padding(
                        padding: EdgeInsets.only(right: 2),
                        child: Icon(
                          Icons.star,
                          size: 15,
                          color: Color(0xFFEAB308),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${detail.reviewCount})',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    LucideIcons.chevronRight,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Light Cyan Badge Banner: ✓ Tất cả đánh giá đến từ người đã mua hàng
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0284C7),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        size: 9,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Tất cả đánh giá đến từ người đã mua hàng',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Thin divider line separating rating header and first review item
              const Padding(
                padding: EdgeInsets.only(top: 12, bottom: 4),
                child: Divider(
                  height: 1,
                  thickness: 0.8,
                  color: Color(0xFFF1F5F9),
                ),
              ),

              // Reviews List
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: detail.reviews.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 24,
                  color: Color(0xFFF1F5F9),
                ),
                itemBuilder: (context, index) {
                  final review = detail.reviews[index];
                  final hasNetworkAvatar = review.userAvatar.startsWith('http');

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Header Row (Avatar, Name, Date, Thumbs Up "Cảm ơn")
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 18,
                            backgroundColor: review.userName.startsWith('Lâm')
                                ? const Color(0xFF3B82F6)
                                : const Color(0xFFA855F7),
                            backgroundImage: hasNetworkAvatar
                                ? NetworkImage(review.userAvatar)
                                : null,
                            child: !hasNetworkAvatar
                                ? Text(
                                    review.userName.isNotEmpty
                                        ? review.userName[0].toUpperCase()
                                        : 'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.userName,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  review.date,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Like / Thank action button matching sample
                          Row(
                            children: [
                              const Icon(
                                LucideIcons.thumbsUp,
                                size: 14,
                                color: Color(0xFF64748B),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                review.userName.startsWith('Lâm')
                                    ? 'Cảm ơn (5)'
                                    : 'Cảm ơn',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // User Star Rating Row (e.g. 3 yellow stars + 2 grey stars)
                      Row(
                        children: List.generate(
                          5,
                          (i) => Icon(
                            Icons.star,
                            size: 14,
                            color: i < review.rating
                                ? const Color(0xFFEAB308)
                                : const Color(0xFFCBD5E1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Comment Text (Image icon ONLY shown if review has photos)
                      if (review.comment.isNotEmpty) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (review.photos.isNotEmpty) ...[
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(
                                  LucideIcons.image,
                                  size: 14,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Expanded(
                              child: Text(
                                review.comment,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFF334155),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                      // Review Photo Thumbnails with Magnifier Icon & Fullscreen Viewer
                      if (review.photos.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Row(
                          children: List.generate(
                            review.photos.length,
                            (photoIndex) {
                              final imgUrl = review.photos[photoIndex];
                              return GestureDetector(
                                onTap: () => _openReviewImageFullscreen(
                                  review.photos,
                                  photoIndex,
                                ),
                                child: Container(
                                  margin: const EdgeInsets.only(right: 8),
                                  width: 66,
                                  height: 66,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: const Color(0xFFE2E8F0),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: Image.network(
                                            imgUrl,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stack) =>
                                                    Container(
                                              color: const Color(0xFFE2E8F0),
                                              child: const Icon(
                                                LucideIcons.image,
                                                size: 24,
                                                color: Color(0xFF94A3B8),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 4,
                                          bottom: 4,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: const BoxDecoration(
                                              color: Colors.black45,
                                              shape: BoxShape.circle,
                                            ),
                                            child: const Icon(
                                              LucideIcons.search,
                                              size: 10,
                                              color: Colors.white,
                                            ),
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
                      ],

                      // Shop Response Section (Indented reply to specific user review)
                      if (review.shopResponse != null) ...[
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.only(left: 4),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                radius: 14,
                                backgroundColor: Color(0xFFE11D48),
                                child: Text(
                                  'P',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      shop.name,
                                      style: const TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF0284C7),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      review.shopResponse!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF334155),
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  );
                },
              ),

              const SizedBox(height: 16),

              // Full-width Xem thêm đánh giá Button matching sample media_1789698087217.png
              SizedBox(
                width: double.infinity,
                height: 40,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Xem thêm đánh giá ',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      Icon(
                        LucideIcons.chevronDown,
                        size: 16,
                        color: Color(0xFF0284C7),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 3. Shop Profile Card matching sample media_1789698087217.png
        Container(
          color: Colors.white,
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundColor: Color(0xFF0284C7),
                child: Text(
                  'P',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      shop.name,
                      style: const TextStyle(
                        fontSize: 14.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Text(
                          '50 ',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Theo dõi  •  ',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Text(
                          '2.3K ',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Đã bán  •  ',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        Icon(Icons.star, size: 12, color: Color(0xFFEAB308)),
                        SizedBox(width: 2),
                        Text(
                          '5',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: const [
                        Icon(
                          LucideIcons.clock,
                          size: 12,
                          color: Color(0xFF94A3B8),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Tham gia: 1 năm trước',
                          style: TextStyle(
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
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF0284C7)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 4,
                  ),
                ),
                child: const Text(
                  'Xem Shop',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // 4. Other Products of the Shop section matching sample media_1789699092583.png
        HorizontalProductListSection(
          title: 'Các sản phẩm khác của shop',
          products: detail.otherShopProducts.isNotEmpty
              ? detail.otherShopProducts
              : ProductModel.mockProducts,
        ),

        const SizedBox(height: 8),
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
