import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/screens/checkout_screen.dart';
import 'package:hiweb_app_management/features/cart_checkout/services/cart_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'video_product_sheet.dart';

class VideoInfoSection extends StatefulWidget {
  final VideoItemModel video;
  final VoidCallback? onTapProductTag;

  const VideoInfoSection({
    super.key,
    required this.video,
    this.onTapProductTag,
  });

  @override
  State<VideoInfoSection> createState() => _VideoInfoSectionState();
}

class _VideoInfoSectionState extends State<VideoInfoSection> {
  bool _isExpanded = false;
  bool _showProductCard = true;

  void _openProductDetail() {
    if (widget.onTapProductTag != null) {
      widget.onTapProductTag!();
      return;
    }
    VideoProductSheet.show(
      context,
      items: const StaticContentRepository().videoProductItems,
    );
  }

  void _addToCart() {
    CartService.instance.addToCart(
      CartItemModel(
        id: 'cart_video_${DateTime.now().millisecondsSinceEpoch}',
        name: widget.video.productName,
        price: 15000,
        originalPrice: 20000,
        variantInfo: 'Đã chọn: Mẫu 01',
        imageUrl:
            widget.video.authorAvatar.isNotEmpty
                ? widget.video.authorAvatar
                : widget.video.thumbnailUrl,
        shopName: 'VietMade Official',
        quantity: 1,
        isSelected: true,
      ),
    );
    TopNotification.show(
      context,
      message: 'Đã thêm "${widget.video.productName}" vào giỏ hàng!',
      isError: false,
    );
  }

  void _buyNow() {
    final product = ProductDetailModel.fromProduct(
      MockProductRepository().getProducts().first,
    );
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (_) => CheckoutScreen(
              productDetail: product,
              selectedVariant: 'Mẫu 01',
              quantity: 1,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 12,
      right: 76,
      bottom: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_showProductCard) _buildProductCard(),
          if (_showProductCard) const SizedBox(height: 10),

          _buildBottomProductBar(),
          const SizedBox(height: 8),

          // 1. Author Name
          Text(
            widget.video.authorName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14.5,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          ),
          const SizedBox(height: 4),

          // 2. Expandable Caption
          GestureDetector(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.video.caption,
                  maxLines: _isExpanded ? null : 2,
                  overflow:
                      _isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 12.5,
                    height: 1.35,
                    shadows: const [
                      Shadow(color: Colors.black54, blurRadius: 4),
                    ],
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _isExpanded ? 'Thu gọn' : 'Xem thêm',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildProductCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Left Thumbnail with -48% Badge
          GestureDetector(
            onTap: _openProductDetail,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: () {
                    final imgUrl =
                        widget.video.authorAvatar.isNotEmpty
                            ? widget.video.authorAvatar
                            : widget.video.thumbnailUrl;
                    if (imgUrl.startsWith('http')) {
                      return Image.network(
                        imgUrl,
                        width: 72,
                        height: 72,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (_, __, ___) => Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F5F9),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Icon(
                                LucideIcons.package,
                                color: Color(0xFF94A3B8),
                                size: 26,
                              ),
                            ),
                      );
                    }
                    return Image.asset(
                      imgUrl,
                      width: 72,
                      height: 72,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Icon(
                              LucideIcons.package,
                              color: Color(0xFF94A3B8),
                              size: 26,
                            ),
                          ),
                    );
                  }(),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4.5,
                      vertical: 1.5,
                    ),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        bottomRight: Radius.circular(6),
                      ),
                    ),
                    child: Text(
                      widget.video.discountPercentage,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.bold,
                        height: 1.1,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // 2. Right Info & Action Buttons
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Line 1: MALL Badge + Title + Close Button
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 3.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                      child: const Text(
                        'MALL',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 7.5,
                          fontWeight: FontWeight.w900,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: _openProductDetail,
                        child: Text(
                          widget.video.productName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => setState(() => _showProductCard = false),
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        width: 18,
                        height: 18,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF1F5F9),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.x,
                            size: 10.5,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),

                // Line 2: Badges (Star 4.9 + Độc quyền + Giảm 25%)
                Row(
                  children: [
                    // Rating Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 9.5,
                            color: Color(0xFFEAB308),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            widget.video.rating,
                            style: const TextStyle(
                              fontSize: 8.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF854D0E),
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),

                    // "Độc quyền" Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE0F7FA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Độc quyền',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),

                    // "Giảm 25%" Outline Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 0.8,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary,
                          width: 0.7,
                        ),
                      ),
                      child: Text(
                        widget.video.voucherDiscount,
                        style: const TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                          height: 1.1,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2.5),

                // Line 3: Price & Sold Count
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      widget.video.price,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      widget.video.soldCount,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3.5),

                // Line 4: Cart Button + "Mua ngay" Button
                Row(
                  children: [
                    // Cart Button
                    InkWell(
                      onTap: _addToCart,
                      borderRadius: BorderRadius.circular(5),
                      child: Container(
                        height: 26,
                        width: 34,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                            width: 0.8,
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            LucideIcons.shoppingCart,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5),

                    // "Mua ngay" Button
                    Expanded(
                      child: InkWell(
                        onTap: _buyNow,
                        borderRadius: BorderRadius.circular(5),
                        child: Container(
                          height: 26,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          alignment: Alignment.center,
                          child: const Text(
                            'Mua ngay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
    );
  }

  Widget _buildBottomProductBar() {
    return GestureDetector(
      onTap: _openProductDetail,
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFF141414).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(4.5),
              ),
              child: const Center(
                child: Icon(LucideIcons.ticket, size: 12, color: Colors.white),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              widget.video.voucherDiscount,
              style: const TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 6),
            Container(width: 1, height: 11, color: Colors.white24),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Xem sản phẩm (${widget.video.productCount})',
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            const Icon(
              LucideIcons.chevronRight,
              size: 14,
              color: Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}
