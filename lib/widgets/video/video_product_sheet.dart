import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/video/video_product_sheet_model.dart';
import '../../models/user/cart/cart_item_model.dart';
import '../../services/user/cart_service.dart';
import '../../theme/app_colors.dart';
import '../common/dialogs/top_notification.dart';

class VideoProductSheet extends StatefulWidget {
  final List<VideoProductSheetItemModel> items;

  const VideoProductSheet({super.key, this.items = const []});

  static Future<void> show(
    BuildContext context, {
    List<VideoProductSheetItemModel>? items,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => VideoProductSheet(
            items: items ?? VideoProductSheetData.mockItems,
          ),
    );
  }

  @override
  State<VideoProductSheet> createState() => _VideoProductSheetState();
}

class _VideoProductSheetState extends State<VideoProductSheet> {
  @override
  Widget build(BuildContext context) {
    final items =
        widget.items.isEmpty ? VideoProductSheetData.mockItems : widget.items;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.82,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                left: 14,
                right: 10,
                top: 12,
                bottom: 9,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Xem sản phẩm (${items.length})',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const SizedBox(
                      width: 26,
                      height: 30,
                      child: Icon(
                        LucideIcons.x,
                        size: 18,
                        color: Color(0xFF334155),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
            const _VoucherStrip(),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 14),
                itemCount: items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 5),
                itemBuilder: (context, index) {
                  final item = items[index];
                  return _ProductCardItem(item: item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VoucherStrip extends StatelessWidget {
  const _VoucherStrip();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 57,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(10, 7, 10, 5),
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        separatorBuilder: (_, __) => const SizedBox(width: 5),
        itemBuilder:
            (_, index) => const SizedBox(
              width: 126,
              child: _VoucherChip(label: 'Giảm 25%', code: 'FREESHIP'),
            ),
      ),
    );
  }
}

class _VoucherChip extends StatelessWidget {
  final String label;
  final String code;

  const _VoucherChip({required this.label, required this.code});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 39,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFB8E5F0)),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.horizontal(left: Radius.circular(4)),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(LucideIcons.ticket, color: Colors.white, size: 15),
                SizedBox(height: 2),
                Text(
                  'VOUCHER',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                      ),
                      const Text(
                        'Lưu',
                        style: TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    code,
                    style: const TextStyle(
                      fontSize: 7,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const Text(
                    'Độc quyền',
                    style: TextStyle(fontSize: 7, color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCardItem extends StatelessWidget {
  final VideoProductSheetItemModel item;

  const _ProductCardItem({required this.item});

  void _addToCart(BuildContext context) {
    CartService.instance.addToCart(
      CartItemModel(
        id: item.id,
        shopName: 'VietMade Official',
        name: item.title,
        imageUrl: item.imageUrl,
        brand: 'VietMade Official',
        variantInfo: 'Đã chọn: ${item.subtitle}',
        price: item.price,
        originalPrice: item.originalPrice,
      ),
    );
    TopNotification.show(
      context,
      message: 'Đã thêm "${item.title}" vào giỏ hàng!',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: _buildImage(item.imageUrl),
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
                    '-${item.discountPercent}%',
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
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.5,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF9C3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, size: 9.5, color: Color(0xFFEAB308)),
                          SizedBox(width: 2),
                          Text(
                            '4.9',
                            style: TextStyle(
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
                    const SizedBox(width: 6),
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
                        item.badgeText,
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
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            item.formattedPrice,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            item.formattedOriginalPrice,
                            style: const TextStyle(
                              color: Color(0xFF94A3B8),
                              fontSize: 8,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () => _addToCart(context),
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
                    SizedBox(
                      width: 82,
                      height: 26,
                      child: Container(
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
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImage(String source) {
    if (source.startsWith('assets/')) {
      return Image.asset(source, width: 56, height: 56, fit: BoxFit.cover);
    }

    return Image.network(
      source,
      width: 56,
      height: 56,
      fit: BoxFit.cover,
      errorBuilder:
          (_, __, ___) => Container(
            width: 56,
            height: 56,
            color: const Color(0xFFF1F5F9),
            child: const Icon(
              LucideIcons.package,
              color: Color(0xFF94A3B8),
              size: 26,
            ),
          ),
    );
  }
}
