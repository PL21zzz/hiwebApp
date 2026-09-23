import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/user/cart/cart_item_model.dart';
import '../../../services/user/cart_service.dart';
import '../../common/confirm_dialog.dart';
import '../../common/voucher_select_chip.dart';
import '../../../theme/app_colors.dart';

class CartShopGroupCard extends StatelessWidget {
  final String shopName;
  final List<CartItemModel> items;
  final bool isEditing;
  final VoidCallback? onShopVoucherPressed;

  const CartShopGroupCard({
    super.key,
    required this.shopName,
    required this.items,
    this.isEditing = false,
    this.onShopVoucherPressed,
  });

  String _formatPrice(int value) {
    return '${value.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match.group(1)}.')}đ';
  }

  void _showDeleteConfirmDialog(BuildContext context, CartItemModel item) {
    ConfirmDialog.show(
      context,
      title: 'Xóa sản phẩm',
      message: 'Bạn có chắc chắn muốn xóa "${item.name}" khỏi giỏ hàng?',
      icon: LucideIcons.trash2,
      cancelText: 'Quay lại',
      confirmText: 'Xóa',
      isDangerous: true,
      onConfirm: () {
        CartService.instance.removeItem(item.id);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isShopAllSelected = items.every((i) => i.isSelected);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Shop Header Row
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 14, 8),
            child: Row(
              children: [
                SizedBox(
                  width: 28,
                  height: 28,
                  child: Checkbox(
                    value: isShopAllSelected,
                    activeColor: AppColors.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (val) {
                      CartService.instance.toggleShopSelection(shopName, val ?? false);
                    },
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  shopName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 16,
                  color: Color(0xFF475569),
                ),
                const Spacer(),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // 2. Product Items List
          ...items.map((item) => _buildProductItemRow(context, item)),

          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // 3. Shop Voucher Row
          InkWell(
            onTap: onShopVoucherPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
              children: [
                const Icon(
                  LucideIcons.ticket,
                  size: 16,
                  color: AppColors.primary,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Mã giảm giá của shop',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF334155),
                  ),
                ),
                const Spacer(),
                const VoucherSelectChip(),
              ],
              ),
            ),
          ),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),

          // 4. Shipping Info Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      LucideIcons.truck,
                      size: 16,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 8),
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                        children: [
                          const TextSpan(text: 'Phí vận chuyển: '),
                          TextSpan(
                            text: _formatPrice(CartService.instance.shippingFee),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          children: [
                            const TextSpan(text: 'Giảm: '),
                            TextSpan(
                              text: '-${_formatPrice(CartService.instance.shippingDiscount)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Thời gian giao hàng: Dự kiến từ 15/09 - 17/09',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductItemRow(BuildContext context, CartItemModel item) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 10, 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Checkbox item
          SizedBox(
            width: 28,
            height: 28,
            child: Checkbox(
              value: item.isSelected,
              activeColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              onChanged: (_) {
                CartService.instance.toggleItemSelection(item.id);
              },
            ),
          ),
          const SizedBox(width: 4),

          // Thumbnail Image
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
            ),
            alignment: Alignment.center,
            child: Image.network(
              item.imageUrl,
              width: 52,
              height: 52,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const Icon(
                LucideIcons.package,
                size: 28,
                color: Color(0xFFCBD5E1),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Details Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500,
                    height: 1.3,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),

                // Brand Tag
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Text(
                    item.brand,
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 4),

                // Variant Info
                Text(
                  item.variantInfo,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 8),

                // Price & Quantity Stepper Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _formatPrice(item.price),
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEF4444),
                          ),
                        ),
                        if (item.originalPrice > item.price)
                          Text(
                            _formatPrice(item.originalPrice),
                            style: const TextStyle(
                              fontSize: 10.5,
                              color: Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),

                    // Quantity Stepper (- 1 +) & Delete Red Text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          height: 28,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
                          ),
                          child: Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  CartService.instance.updateQuantity(item.id, -1);
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: const Icon(LucideIcons.minus, size: 12, color: Color(0xFF64748B)),
                                ),
                              ),
                              Container(
                                width: 32,
                                alignment: Alignment.center,
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F172A),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  CartService.instance.updateQuantity(item.id, 1);
                                },
                                child: Container(
                                  width: 28,
                                  height: 28,
                                  alignment: Alignment.center,
                                  child: const Icon(LucideIcons.plus, size: 12, color: Color(0xFF64748B)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isEditing) ...[
                          const SizedBox(height: 6),
                          GestureDetector(
                            onTap: () => _showDeleteConfirmDialog(context, item),
                            child: const Text(
                              'Xóa',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                        ],
                      ],
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
}
