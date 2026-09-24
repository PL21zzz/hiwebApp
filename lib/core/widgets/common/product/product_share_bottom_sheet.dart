import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';
import 'package:hiweb_app_management/features/chat/screens/messages_screen.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';

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
    return 'https://via.placeholder.com/150';
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

  void _showQrCodeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isVideoMode ? 'Mã QR Video' : 'Mã QR Sản Phẩm',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.x, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: const Center(
                      child: Icon(
                        LucideIcons.qrCode,
                        size: 130,
                        color: Color(0xFF0F5A6E),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  if (!isVideoMode) ...[
                    const SizedBox(height: 8),
                    Text(
                      _formatCurrency(_price),
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              isVideoMode
                                  ? 'Đã tải mã QR video về thiết bị'
                                  : 'Đã tải mã QR về thiết bị',
                            ),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      },
                      icon: const Icon(LucideIcons.download, size: 16),
                      label: const Text('Lưu mã QR'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildShareItem({
    required Widget iconWidget,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(shape: BoxShape.circle),
              child: Center(child: iconWidget),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF475569),
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCircleButton({
    required Color bgColor,
    required IconData icon,
    Color iconColor = Colors.white,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  Widget _buildTextCircleButton({
    required Color bgColor,
    required String text,
    Color textColor = Colors.white,
  }) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
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
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child:
                  isVideoMode
                      ? Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(6),
                                child: Image.network(
                                  _imageUrl,
                                  width: 52,
                                  height: 52,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (_, __, ___) => Container(
                                        width: 52,
                                        height: 52,
                                        color: Colors.grey.shade200,
                                        child: const Icon(
                                          LucideIcons.video,
                                          size: 20,
                                        ),
                                      ),
                                ),
                              ),
                              Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  video!.authorName,
                                  style: const TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  video!.caption,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                      : Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(6),
                            child: Image.network(
                              _imageUrl,
                              width: 52,
                              height: 52,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) => Container(
                                    width: 52,
                                    height: 52,
                                    color: Colors.grey.shade200,
                                    child: const Icon(
                                      LucideIcons.image,
                                      size: 20,
                                    ),
                                  ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF1E293B),
                                    height: 1.25,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      _formatCurrency(_price),
                                      style: const TextStyle(
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFE53935),
                                      ),
                                    ),
                                    if (_originalPrice > _price) ...[
                                      const SizedBox(width: 6),
                                      Text(
                                        _formatCurrency(_originalPrice),
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                          decoration:
                                              TextDecoration.lineThrough,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShareItem(
                  iconWidget: _buildTextCircleButton(
                    bgColor: const Color(0xFF0068FF),
                    text: 'Zalo',
                  ),
                  label: 'Zalo',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isVideoMode
                              ? 'Mở Zalo chia sẻ video...'
                              : 'Mở ứng dụng Zalo...',
                        ),
                      ),
                    );
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFF1877F2),
                    icon: LucideIcons.facebook,
                  ),
                  label: 'Facebook',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isVideoMode
                              ? 'Đăng video lên Facebook...'
                              : 'Mở ứng dụng Facebook...',
                        ),
                      ),
                    );
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFF0084FF),
                    icon: LucideIcons.messageCircle,
                  ),
                  label: 'Messenger',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Mở Messenger...')),
                    );
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFFF1F5F9),
                    icon: LucideIcons.copy,
                    iconColor: const Color(0xFF0F5A6E),
                  ),
                  label: 'Sao chép',
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text:
                            isVideoMode
                                ? 'https://vietmade.vn/video/${video!.id}'
                                : 'https://vietmade.vn/product/share',
                      ),
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isVideoMode
                              ? 'Đã sao chép liên kết video'
                              : 'Đã sao chép liên kết sản phẩm',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFFF1F5F9),
                    icon: LucideIcons.download,
                    iconColor: const Color(0xFF0F5A6E),
                  ),
                  label: isVideoMode ? 'Tải video' : 'Lưu ảnh',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isVideoMode
                              ? 'Đang tải video MP4 về thiết bị...'
                              : 'Đã tải ảnh sản phẩm về thư viện',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFF10B981),
                    icon: LucideIcons.mail,
                  ),
                  label: 'Tin nhắn/SMS',
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gửi qua SMS...')),
                    );
                  },
                ),
              ],
            ),
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
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFF0F5A6E),
                    icon: LucideIcons.qrCode,
                  ),
                  label: 'Mã QR',
                  onTap: () {
                    Navigator.pop(context);
                    _showQrCodeDialog(context);
                  },
                ),
                _buildShareItem(
                  iconWidget: _buildCircleButton(
                    bgColor: const Color(0xFF0284C7),
                    icon: LucideIcons.send,
                  ),
                  label: 'VietMade Chat',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MessagesScreen()),
                    );
                  },
                ),
                if (isVideoMode) ...[
                  _buildShareItem(
                    iconWidget: _buildCircleButton(
                      bgColor: const Color(0xFF64748B),
                      icon: LucideIcons.eyeOff,
                    ),
                    label: 'Không thích',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã ẩn các video tương tự'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                  _buildShareItem(
                    iconWidget: _buildCircleButton(
                      bgColor: const Color(0xFFEF4444),
                      icon: LucideIcons.flag,
                    ),
                    label: 'Báo cáo',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đã gửi báo cáo nội dung video'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ] else ...[
                  _buildShareItem(
                    iconWidget: _buildCircleButton(
                      bgColor: const Color(0xFFF59E0B),
                      icon: LucideIcons.gift,
                    ),
                    label: 'Thưởng 20K',
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Link tiếp thị thưởng 20k đã tạo!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ],
              ],
            ),
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
