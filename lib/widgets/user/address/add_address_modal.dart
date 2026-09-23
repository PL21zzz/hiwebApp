import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../data/vietnam_divisions_data.dart';
import '../../../models/user/address/address_model.dart';
import '../../../services/user/address_service.dart';
import '../../../services/auth_service.dart';
import '../../../theme/app_colors.dart';
import '../../common/dialogs/top_notification.dart';
import 'location_search_picker_modal.dart';

class AddAddressModal extends StatefulWidget {
  final AddressModel? addressToEdit;

  const AddAddressModal({
    super.key,
    this.addressToEdit,
  });

  static Future<void> show(BuildContext context, {AddressModel? addressToEdit}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: AddAddressModal(addressToEdit: addressToEdit),
      ),
    );
  }

  @override
  State<AddAddressModal> createState() => _AddAddressModalState();
}

class _AddAddressModalState extends State<AddAddressModal> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _streetController;

  String? _selectedProvince;
  String? _selectedWard;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final user = AuthService.instance.currentUser;
    final edit = widget.addressToEdit;

    _nameController = TextEditingController(
      text: edit?.fullName ?? user?.fullName ?? '',
    );
    _phoneController = TextEditingController(
      text: edit?.phone ?? user?.phoneNumber ?? '',
    );
    _emailController = TextEditingController(
      text: edit?.email ?? user?.email ?? '',
    );
    _streetController = TextEditingController(
      text: edit?.streetAddress ?? '',
    );

    _selectedProvince = edit?.province;
    _selectedWard = edit?.ward;
    _isDefault = edit?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _streetController.dispose();
    super.dispose();
  }

  void _resetForm() {
    final user = AuthService.instance.currentUser;
    setState(() {
      _nameController.text = user?.fullName ?? '';
      _phoneController.text = user?.phoneNumber ?? '';
      _emailController.text = user?.email ?? '';
      _streetController.text = '';
      _selectedProvince = null;
      _selectedWard = null;
      _isDefault = false;
    });
  }

  void _submitForm() {
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final street = _streetController.text.trim();

    if (name.isEmpty) {
      TopNotification.show(context, message: 'Vui lòng nhập Họ và tên', isError: true);
      return;
    }
    if (phone.isEmpty) {
      TopNotification.show(context, message: 'Vui lòng nhập Số điện thoại', isError: true);
      return;
    }
    if (_selectedProvince == null || _selectedProvince!.isEmpty) {
      TopNotification.show(context, message: 'Vui lòng chọn Tỉnh / Thành phố', isError: true);
      return;
    }
    if (_selectedWard == null || _selectedWard!.isEmpty) {
      TopNotification.show(context, message: 'Vui lòng chọn Phường / Xã', isError: true);
      return;
    }
    if (street.isEmpty) {
      TopNotification.show(context, message: 'Vui lòng nhập Địa chỉ chi tiết', isError: true);
      return;
    }

    final isEditing = widget.addressToEdit != null;
    final addressModel = AddressModel(
      id: isEditing ? widget.addressToEdit!.id : 'addr_${DateTime.now().millisecondsSinceEpoch}',
      fullName: name,
      phone: phone,
      email: email,
      province: _selectedProvince!,
      ward: _selectedWard!,
      streetAddress: street,
      isDefault: _isDefault,
    );

    if (isEditing) {
      AddressService.instance.updateAddress(addressModel);
    } else {
      AddressService.instance.addAddress(addressModel);
    }

    Navigator.of(context).pop();
    TopNotification.show(
      context,
      message: isEditing ? 'Đã cập nhật địa chỉ thành công!' : 'Đã thêm địa chỉ mới thành công!',
      isError: false,
    );
  }

  Future<void> _openProvincePicker() async {
    final selected = await LocationSearchPickerModal.show(
      context,
      title: 'Chọn Tỉnh / Thành phố',
      items: VietnamDivisionsData.provinces,
      selectedValue: _selectedProvince,
    );

    if (selected != null && selected != _selectedProvince) {
      setState(() {
        _selectedProvince = selected;
        _selectedWard = null;
      });
    }
  }

  Future<void> _openWardPicker() async {
    if (_selectedProvince == null || _selectedProvince!.isEmpty) {
      TopNotification.show(
        context,
        message: 'Vui lòng chọn Tỉnh / Thành phố trước',
        isError: true,
      );
      return;
    }

    final wards = VietnamDivisionsData.getWardsForProvince(_selectedProvince!);
    final selected = await LocationSearchPickerModal.show(
      context,
      title: 'Chọn Phường / Xã',
      items: wards,
      selectedValue: _selectedWard,
    );

    if (selected != null) {
      setState(() {
        _selectedWard = selected;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    String? hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              style: const TextStyle(
                fontSize: 13.5,
                color: Color(0xFF1E293B),
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  Widget _buildSelectField({
    required String label,
    required String? value,
    required String hintText,
    required VoidCallback onTap,
  }) {
    final hasValue = value != null && value.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: onTap,
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  hasValue ? value : hintText,
                  style: TextStyle(
                    fontSize: 13.5,
                    color: hasValue ? const Color(0xFF1E293B) : const Color(0xFF64748B),
                    fontWeight: hasValue ? FontWeight.w500 : FontWeight.normal,
                  ),
                ),
                const Icon(
                  LucideIcons.chevronDown,
                  size: 18,
                  color: Color(0xFF64748B),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    return Container(
      margin: isAndroid ? const EdgeInsets.only(top: 44.0) : EdgeInsets.zero,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * (isAndroid ? 0.82 : 0.9),
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Header with title and close X button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.addressToEdit != null ? 'Chỉnh sửa địa chỉ' : 'Thêm mới địa chỉ',
                  style: const TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Red note text italic
            const Text(
              '* Lưu ý: Vui lòng cập nhật dùng địa chỉ hành chính 2 cấp mới (Tỉnh/Thành phố, Phường/Xã) nếu hệ thống chưa tự động cập nhật.',
              style: TextStyle(
                fontSize: 11.5,
                fontStyle: FontStyle.italic,
                color: Color(0xFFEF4444),
                height: 1.3,
              ),
            ),
            const SizedBox(height: 16),

            // Form inputs
            _buildTextField(
              label: 'Họ và tên',
              controller: _nameController,
            ),
            _buildTextField(
              label: 'Số điện thoại',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            _buildTextField(
              label: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _buildSelectField(
              label: 'Tỉnh / Thành phố',
              value: _selectedProvince,
              hintText: '-- Tỉnh/thành phố --',
              onTap: _openProvincePicker,
            ),
            _buildSelectField(
              label: 'Phường / Xã',
              value: _selectedWard,
              hintText: '-- Phường/Xã --',
              onTap: _openWardPicker,
            ),
            _buildTextField(
              label: 'Địa chỉ chi tiết',
              controller: _streetController,
              hintText: 'Số nhà, tên đường...',
            ),

            // Checkbox: Đặt làm địa chỉ mặc định
            Row(
              children: [
                SizedBox(
                  width: 20,
                  height: 20,
                  child: Checkbox(
                    value: _isDefault,
                    onChanged: (val) {
                      setState(() {
                        _isDefault = val ?? false;
                      });
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    side: const BorderSide(color: Color(0xFF94A3B8), width: 1.2),
                    activeColor: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Đặt làm địa chỉ mặc định',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Bottom Buttons: "Đặt lại" & "Hoàn thành"
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetForm,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 42),
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      widget.addressToEdit != null ? 'Cập nhật' : 'Hoàn thành',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    ),
  );
}
}
