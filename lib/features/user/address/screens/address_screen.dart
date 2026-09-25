import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/user/address/services/address_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/user/address/widgets/add_address_modal.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/confirm_dialog.dart';
import 'package:hiweb_app_management/core/widgets/common/cards/reusable_info_card.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';

class AddressScreen extends StatelessWidget {
  final bool isSelectMode;
  final ValueChanged<AddressModel>? onSelectAddress;

  const AddressScreen({
    super.key,
    this.isSelectMode = false,
    this.onSelectAddress,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const VietmadeHeader(showMenu: false),
      body: Column(
        children: [
          // 1. Navigation Sub-Header ("< Địa chỉ")
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: 22,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Địa chỉ',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // 2. Main Content Card
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ListenableBuilder(
                      listenable: AddressService.instance,
                      builder: (context, child) {
                        final addresses =
                          AddressService.instance.state.data ?? const [];
                        final isEmpty = addresses.isEmpty;

                        return ReusableInfoCard(
                        title: 'Địa chỉ của tôi',
                        titleIcon: LucideIcons.mapPin,
                        headerNote: 'Bạn có thể tạo tối đa 50 địa chỉ',
                        emptyTitle: 'Bạn chưa có địa chỉ nào',
                        emptySubtitle: 'Thêm địa chỉ để VietMade giao hàng nhanh chóng và chính xác hơn.',
                        buttonText: 'Thêm địa chỉ mới',
                        onButtonPressed: () => AddAddressModal.show(context),
                        isEmpty: isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...addresses.map((address) => _buildAddressItem(context, address)),
                            const SizedBox(height: 14),

                            // Bottom Add New Address Button when list is not empty
                            ElevatedButton(
                              onPressed: () => AddAddressModal.show(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 44),
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
                          ],
                        ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressItem(BuildContext context, AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: address.isDefault ? AppColors.primary : const Color(0xFFE2E8F0),
          width: address.isDefault ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: isSelectMode
            ? () {
                onSelectAddress?.call(address);
                Navigator.of(context).pop();
              }
            : null,
        borderRadius: BorderRadius.circular(10),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${address.fullName}  |  ${address.phone}',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              if (address.isDefault)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0F2FE),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF38BDF8)),
                  ),
                  child: const Text(
                    'Mặc định',
                    style: TextStyle(
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            address.fullAddress,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF475569),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (!address.isDefault)
                TextButton(
                  onPressed: () {
                    AddressService.instance.setDefaultAddress(address.id);
                  },
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'Thiết lập mặc định',
                    style: TextStyle(fontSize: 11.5, color: AppColors.primary),
                  ),
                ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  AddAddressModal.show(context, addressToEdit: address);
                },
                child: const Text(
                  'Sửa',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0284C7)),
                ),
              ),
              const SizedBox(width: 14),
              GestureDetector(
                onTap: () {
                  _showDeleteConfirm(context, address.id);
                },
                child: const Text(
                  'Xóa',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFFEF4444)),
                ),
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  void _showDeleteConfirm(BuildContext context, String id) {
    ConfirmDialog.show(
      context,
      title: 'Xóa địa chỉ?',
      message: 'Bạn có chắc chắn muốn xóa địa chỉ này khỏi danh sách?',
      icon: LucideIcons.trash2,
      confirmText: 'Xóa',
      cancelText: 'Hủy',
      isDangerous: true,
      onConfirm: () {
        AddressService.instance.deleteAddress(id);
      },
    );
  }
}
