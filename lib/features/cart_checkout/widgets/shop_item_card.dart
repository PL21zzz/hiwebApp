import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/cards/voucher_select_chip.dart';

class ShopItemCard extends StatelessWidget {
  final ProductDetailModel productDetail;
  final String? selectedVariant;
  final int quantity;
  final String imageUrl;
  final String Function(double) formatCurrency;
  final VoidCallback? onShopVoucherPressed;

  const ShopItemCard({
    super.key,
    required this.productDetail,
    required this.selectedVariant,
    required this.quantity,
    required this.imageUrl,
    required this.formatCurrency,
    this.onShopVoucherPressed,
  });

  @override
  Widget build(BuildContext context) {
    return _CheckoutCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _TitleRow(
            icon: LucideIcons.store,
            title: productDetail.shopProfile.name.isNotEmpty
                ? productDetail.shopProfile.name
                : const StaticContentRepository().shopName,
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ProductImage(imageUrl: imageUrl),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(productDetail.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B), height: 1.25)),
                    const SizedBox(height: 3),
                    Text('${const StaticContentRepository().productVariantPrefix}${selectedVariant ?? 'Chưa chọn'}', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B))),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(formatCurrency(productDetail.price), style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                        const SizedBox(width: 6),
                        Text(formatCurrency(productDetail.originalPrice), style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8), decoration: TextDecoration.lineThrough)),
                        const Spacer(),
                        _QuantityBadge(quantity: quantity),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          InkWell(
            onTap: onShopVoucherPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(LucideIcons.ticket, color: AppColors.primary, size: 16),
                    SizedBox(width: 8),
                    Text('Mã giảm giá của shop', style: TextStyle(fontSize: 12.5, color: Color(0xFF334155))),
                  ],
                ),
                const VoucherSelectChip(),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 10),
          _ActionRow(icon: LucideIcons.truck, title: 'Phương thức vận chuyển', trailing: 'Xem tất cả'),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: const Color(0xFFF0F9FF), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0xFF38BDF8), width: 1.2)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(const StaticContentRepository().shippingMethod, style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
                const SizedBox(height: 4),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(const StaticContentRepository().shippingDate, style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                  RichText(
                    text: TextSpan(
                      style: const TextStyle(fontSize: 11, color: Color(0xFF0F172A)),
                      children: [
                        TextSpan(text: '${const StaticContentRepository().shippingFee}đ    '),
                        const TextSpan(
                          text: 'Miễn phí',
                          style: TextStyle(color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const _ActionRow(icon: LucideIcons.shieldCheck, title: 'Được đồng kiểm'),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final String imageUrl;
  const _ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) => Container(
        width: 58,
        height: 58,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          image: DecorationImage(
            image: (imageUrl.startsWith('http')
                ? NetworkImage(imageUrl)
                : AssetImage(imageUrl)) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      );
}

class _QuantityBadge extends StatelessWidget {
  final int quantity;
  const _QuantityBadge({required this.quantity});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(border: Border.all(color: const Color(0xFFCBD5E1)), borderRadius: BorderRadius.circular(4)), child: Text('x$quantity', style: const TextStyle(fontSize: 11, color: Color(0xFF64748B))));
}

class _TitleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  const _TitleRow({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) => Row(children: [Icon(icon, color: AppColors.primary, size: 18), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)))]);
}

class _ActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? trailing;
  const _ActionRow({required this.icon, required this.title, this.trailing});
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Row(children: [Icon(icon, color: AppColors.primary, size: 16), const SizedBox(width: 8), Text(title, style: const TextStyle(fontSize: 12.5, color: Color(0xFF334155)))]), if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 11, color: AppColors.primary))]);
}

class _CheckoutCard extends StatelessWidget {
  final Widget child;
  const _CheckoutCard({required this.child});
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: child);
}
