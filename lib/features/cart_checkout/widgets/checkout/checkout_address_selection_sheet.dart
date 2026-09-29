import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/user/address/screens/address_screen.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class CheckoutAddressSelectionSheet extends StatelessWidget {
  final List<AddressModel> addresses;
  final ValueChanged<AddressModel> onSelected;

  const CheckoutAddressSelectionSheet({
    super.key,
    required this.addresses,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (addresses.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Center(
              child: Column(
                children: [
                  Icon(LucideIcons.mapPinOff, size: 36, color: Color(0xFF94A3B8)),
                  SizedBox(height: 10),
                  Text(
                    'Bạn chưa thiết lập địa chỉ nào',
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Thêm địa chỉ để VietMade giao hàng nhanh chóng và chính xác hơn.',
                    style: TextStyle(fontSize: 11.5, color: Color(0xFF94A3B8)),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addresses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final address = addresses[index];
              return InkWell(
                onTap: () {
                  onSelected(address);
                  Navigator.pop(context);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color:
                          address.isDefault
                              ? AppColors.primary
                              : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        LucideIcons.mapPin,
                        size: 17,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 9),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${address.fullName}  |  ${address.phone}',
                              style: const TextStyle(
                                fontSize: 12.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              address.fullAddress,
                              style: const TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF64748B),
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (address.isDefault)
                        const Text(
                          'Mặc định',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        const SizedBox(height: 16),

        // Bottom Add New Address Button
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const AddressScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '+ Thêm địa chỉ mới',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
