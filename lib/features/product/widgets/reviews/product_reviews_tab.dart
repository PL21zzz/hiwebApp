import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/screens/shop_detail_screen.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import '../overview/fullscreen_video_modal.dart';
import 'horizontal_product_list_section.dart';

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

  void _openReviewMedia(ProductReviewMediaModel item) {
    if (item.isVideo && item.videoUrl != null) {
      showDialog(
        context: context,
        useSafeArea: false,
        builder:
            (_) => FullscreenVideoModal(
              mediaList: [
                ProductMediaModel(
                  type: 'video',
                  url: item.videoUrl!,
                  thumb: item.url,
                  title: 'Video đánh giá',
                ),
              ],
              initialIndex: 0,
            ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(12),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.url.startsWith('http')
                    ? Image.network(item.url, fit: BoxFit.contain)
                    : Image.asset(item.url, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  Widget _buildReviewCard(ProductReviewModel review) {
    final media =
        review.media.isNotEmpty
            ? review.media
            : review.photos
                .map((url) => ProductReviewMediaModel(url: url))
                .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFE879F9),
                backgroundImage:
                    review.userAvatar.isNotEmpty
                        ? (review.userAvatar.startsWith('http')
                            ? NetworkImage(review.userAvatar)
                            : AssetImage(review.userAvatar) as ImageProvider)
                        : null,
                child:
                    review.userAvatar.isEmpty
                        ? Text(
                          review.userName.isNotEmpty
                              ? review.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
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
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        if (review.isVerifiedPurchase) ...[
                          const SizedBox(width: 5),
                          const Text(
                            'Đã mua hàng',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 11,
                            color:
                                index < review.rating
                                    ? const Color(0xFFEAB308)
                                    : const Color(0xFFCBD5E1),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          review.variant,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.date,
                style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF334155),
                height: 1.35,
              ),
            ),

          if (media.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: media.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final item = media[index];
                  return GestureDetector(
                    onTap: () => _openReviewMedia(item),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: item.url.startsWith('http')
                              ? Image.network(
                                item.url,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFE2E8F0),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                              : Image.asset(
                                item.url,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFE2E8F0),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                        ),
                        if (item.isVideo)
                          const Positioned.fill(
                            child: Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
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
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            children: [
              CircleAvatar(
                radius: 17,
                backgroundColor: AppColors.primary,
                child: Text(
                  _detail.shopProfile.name.isNotEmpty
                      ? _detail.shopProfile.name[0].toUpperCase()
                      : 'P',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _detail.shopProfile.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          '${_detail.shopProfile.followerCount} Theo dõi  ·  ${_detail.shopProfile.totalSold} Đã bán  ·  ${_detail.shopProfile.rating.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: Color(0xFFEAB308),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 10,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Tham gia: ${_detail.shopProfile.joinedDuration}',
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ShopDetailScreen(shop: _detail.shopProfile),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  minimumSize: Size.zero,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 5,
                  ),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'Xem Shop',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
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
                children: [
                  Text(
                    _detail.rating.toStringAsFixed(1),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(width: 5),
                  ...List.generate(
                    5,
                    (index) => const Icon(
                      Icons.star,
                      size: 11,
                      color: Color(0xFFF59E0B),
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '(${_detail.reviewCount})',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const Spacer(),
                  const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: Color(0xFF94A3B8),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              const Row(
                children: [
                  Icon(Icons.check_circle, size: 11, color: Color(0xFF0284C7)),
                  SizedBox(width: 4),
                  Text(
                    'Tất cả đánh giá đều từ người đã mua hàng',
                    style: TextStyle(fontSize: 9.5, color: Color(0xFF0284C7)),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 9),
                child: Divider(height: 1, color: Color(0xFFE2E8F0)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Đánh giá mới nhất',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    'Hiển thị 3 đánh giá',
                    style: const TextStyle(
                      fontSize: 9.5,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),

              Column(
                children:
                    _detail.reviews
                        .take(3)
                        .map((review) => _buildReviewCard(review))
                        .toList(),
              ),

              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 32,
                child: OutlinedButton(
                  onPressed: widget.onViewAllReviews,
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Xem tất cả ${_detail.reviewCount} đánh giá',
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF0284C7),
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.chevron_right,
                        size: 14,
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
