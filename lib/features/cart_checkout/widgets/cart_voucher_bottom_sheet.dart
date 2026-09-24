import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/voucher/models/voucher_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';

class CartVoucherBottomSheet extends StatefulWidget {
  final String title;
  final String? shopName;
  final List<VoucherItemModel> vouchers;

  const CartVoucherBottomSheet({
    super.key,
    required this.title,
    required this.vouchers,
    this.shopName,
  });

  static Future<void> show(
    BuildContext context, {
    required String title,
    required List<VoucherItemModel> vouchers,
    String? shopName,
  }) {
    return AppBottomSheet.show<void>(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (_) => CartVoucherBottomSheet(
            title: title,
            vouchers: vouchers,
            shopName: shopName,
          ),
    );
  }

  @override
  State<CartVoucherBottomSheet> createState() => _CartVoucherBottomSheetState();
}

class _CartVoucherBottomSheetState extends State<CartVoucherBottomSheet> {
  final _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final availableHeight = MediaQuery.sizeOf(context).height - bottomInset;
    return Container(
      height: isAndroid ? availableHeight * 0.8 : null,
      constraints: BoxConstraints(
        maxHeight: isAndroid ? availableHeight * 0.8 : 600,
      ),
      margin: isAndroid ? EdgeInsets.only(top: availableHeight * 0.2) : null,
      decoration: const BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
      ),
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 10, 10),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(LucideIcons.x, size: 20),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _codeController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  hintText: 'Nhập mã voucher',
                  prefixIcon: const Icon(LucideIcons.ticket, size: 18),
                  suffixIcon: TextButton(
                    onPressed: _applyCode,
                    child: const Text('Áp dụng'),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            Flexible(
              child:
                  widget.vouchers.isEmpty
                      ? const Padding(
                        padding: EdgeInsets.all(28),
                        child: Text(
                          'Chưa có voucher phù hợp',
                          style: TextStyle(color: Color(0xFF64748B)),
                        ),
                      )
                      : ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.all(16),
                        itemCount: widget.vouchers.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder:
                            (context, index) => _VoucherOption(
                              voucher: widget.vouchers[index],
                              onUse: () {
                                TopNotification.show(
                                  context,
                                  message:
                                      'Đã áp dụng mã voucher cho đơn hàng!',
                                  isError: false,
                                );
                                Navigator.pop(context);
                              },
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }

  void _applyCode() {
    if (_codeController.text.trim().isEmpty) return;
    TopNotification.show(
      context,
      message: 'Đã kiểm tra mã voucher: ${_codeController.text.trim()}',
      isError: false,
    );
    Navigator.pop(context);
  }
}

class _VoucherOption extends StatelessWidget {
  final VoucherItemModel voucher;
  final VoidCallback onUse;

  const _VoucherOption({required this.voucher, required this.onUse});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(LucideIcons.ticket, color: AppColors.primary, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  voucher.shopName,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  voucher.discountTitle,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                if (voucher.minSpend != null)
                  Text(
                    voucher.minSpend!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                  ),
                Text(
                  'HSD: ${voucher.expiryDate}',
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF94A3B8),
                  ),
                ),
              ],
            ),
          ),
          OutlinedButton(
            onPressed: onUse,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(horizontal: 10),
            ),
            child: const Text('Dùng ngay', style: TextStyle(fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
