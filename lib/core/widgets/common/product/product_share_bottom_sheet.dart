import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';
import 'share/share_summary_card.dart';
import 'share/share_social_grid.dart';
import 'share/share_actions_grid.dart';

class ProductShareBottomSheet extends StatelessWidget {
  final VideoItemModel? video;
  final ProductDetailModel? productDetail;
  final ProductModel? product;
  final String? customTitle;
  final String? customImageUrl;
  final double? customPrice;
  final double? customOriginalPrice;

  const ProductShareBottomSheet({
    super.key,
    this.video,
    this.productDetail,
    this.product,
    this.customTitle,
    this.customImageUrl,
    this.customPrice,
    this.customOriginalPrice,
  });

  bool get isVideoMode => video != null;

  // Static helper to launch product share sheet
  static Future<void> show(
    BuildContext context, {
    ProductDetailModel? productDetail,
    ProductModel? product,
    String? title,
    String? imageUrl,
    double? price,
    double? originalPrice,
  }) {
    return AppBottomSheet.show(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder:
          (context) => ProductShareBottomSheet(
            productDetail: productDetail,
            product: product,
            customTitle: title,
            customImageUrl: imageUrl,
            customPrice: price,
            customOriginalPrice: originalPrice,
          ),
    );
  }

  // Static helper to launch video share sheet
  static Future<void> showVideo(
    BuildContext context, {
    required VideoItemModel video,
  }) {
    return AppBottomSheet.show(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => ProductShareBottomSheet(video: video),
    );
  }

  String get _title {
    if (isVideoMode) return video!.authorName;
    if (customTitle != null && customTitle!.isNotEmpty) return customTitle!;
    if (productDetail != null) return productDetail!.name;
    if (product != null) return product!.name;
    return 'Sản phẩm VietMade';
  }

  String get _imageUrl {
    if (isVideoMode) return video!.thumbnailUrl;
    if (customImageUrl != null && customImageUrl!.isNotEmpty) {
      return customImageUrl!;
    }
    if (productDetail != null && productDetail!.mediaList.isNotEmpty) {
      final imgMedia = productDetail!.mediaList.firstWhere(
        (m) => m.isImage,
        orElse: () => productDetail!.mediaList.first,
      );
      return imgMedia.url;
    }
    if (product != null) return product!.imageUrl;
    return 'assets/images/prd1.webp';
  }

  double get _price {
    if (customPrice != null) return customPrice!;
    if (productDetail != null) return productDetail!.price;
    if (product != null) return product!.price;
    return 0;
  }

  double get _originalPrice {
    if (customOriginalPrice != null) return customOriginalPrice!;
    if (productDetail != null) return productDetail!.originalPrice;
    if (product != null) return product!.originalPrice;
    return 0;
  }

  String _formatCurrency(double amount) {
    return '${amount.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: EdgeInsets.only(
        top: 8,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle pill
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 6),

          // Header Title + Close button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 32),
                Text(
                  isVideoMode ? 'Chia sẻ video' : 'Chia sẻ sản phẩm',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  borderRadius: BorderRadius.circular(16),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      LucideIcons.x,
                      color: Color(0xFF64748B),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 12),

          // Mini Summary Card (Product or Video)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ShareSummaryCard(
              isVideoMode: isVideoMode,
              video: video,
              title: _title,
              imageUrl: _imageUrl,
              price: _price,
              originalPrice: _originalPrice,
              formatCurrency: _formatCurrency,
            ),
          ),

          const SizedBox(height: 16),

          // Section 1: Social Share Channels
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Chia sẻ qua',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ShareSocialGrid(
            isVideoMode: isVideoMode,
            videoId: video?.id ?? '',
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          const SizedBox(height: 14),

          // Section 2: VietMade Tools & Actions
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Thao tác khác',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 10),
          ShareActionsGrid(
            isVideoMode: isVideoMode,
            title: _title,
            price: _price,
            formatCurrency: _formatCurrency,
          ),

          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Divider(height: 1, color: Color(0xFFF1F5F9)),
          ),
          const SizedBox(height: 10),

          // Cancel Button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              height: 42,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFFF1F5F9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Hủy',
                  style: TextStyle(
                    color: Color(0xFF475569),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
