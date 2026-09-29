import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/screens/checkout_screen.dart';
import 'package:hiweb_app_management/features/cart_checkout/services/cart_service.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'video_product_sheet.dart';
import 'info/video_info_caption.dart';
import 'info/video_info_bottom_bar.dart';
import 'info/video_info_product_card.dart';

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
          if (_showProductCard)
            VideoInfoProductCard(
              video: widget.video,
              onOpenProductDetail: _openProductDetail,
              onCloseCard: () => setState(() => _showProductCard = false),
              onAddToCart: _addToCart,
              onBuyNow: _buyNow,
            ),
          if (_showProductCard) const SizedBox(height: 10),

          VideoInfoBottomBar(
            video: widget.video,
            onTap: _openProductDetail,
          ),
          const SizedBox(height: 8),

          VideoInfoCaption(
            authorName: widget.video.authorName,
            caption: widget.video.caption,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
