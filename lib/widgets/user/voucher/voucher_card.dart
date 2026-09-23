import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/user/voucher/voucher_model.dart';
import '../../../theme/app_colors.dart';
import '../../common/top_notification.dart';

class VoucherCard extends StatelessWidget {
  final VoucherItemModel voucher;
  final VoidCallback onChanged;

  const VoucherCard({
    super.key,
    required this.voucher,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 0.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: Color(0xFFE0F2FE),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  LucideIcons.ticket,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voucher.shopName,
                      style: const TextStyle(
                        fontSize: 11.5,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      voucher.discountTitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    if (voucher.minSpend != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        voucher.minSpend!,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          'HSD: ${voucher.expiryDate}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Điều Kiện',
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: SizedBox(
                  height: 36,
                  child: ElevatedButton(
                    onPressed: () {
                      TopNotification.show(
                        context,
                        message: 'Đã áp dụng mã voucher cho đơn hàng!',
                        isError: false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Dùng ngay',
                      style: TextStyle(
                        fontSize: 12.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      voucher.isSaved = !voucher.isSaved;
                      onChanged();
                      TopNotification.show(
                        context,
                        message: voucher.isSaved
                            ? 'Đã lưu voucher vào kho'
                            : 'Đã bỏ lưu voucher',
                        isError: false,
                      );
                    },
                    icon: Icon(
                      voucher.isSaved ? Icons.bookmark : LucideIcons.bookmark,
                      size: 14,
                      color: voucher.isSaved
                          ? AppColors.primary
                          : const Color(0xFF475569),
                    ),
                    label: Text(
                      voucher.isSaved ? 'Đã lưu' : 'Lưu',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: voucher.isSaved
                            ? AppColors.primary
                            : const Color(0xFF475569),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: voucher.isSaved
                            ? AppColors.primary
                            : const Color(0xFFCBD5E1),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 36,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: voucher.discountTitle));
                      TopNotification.show(
                        context,
                        message: 'Đã sao chép mã voucher!',
                        isError: false,
                      );
                    },
                    icon: const Icon(
                      LucideIcons.copy,
                      size: 14,
                      color: Color(0xFF475569),
                    ),
                    label: const Text(
                      'Copy',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
