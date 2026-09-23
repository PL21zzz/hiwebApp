import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/user/address/address_model.dart';
import '../../theme/app_colors.dart';

class ShippingInfoCard extends StatelessWidget {
  final bool isLoggedIn;
  final bool hideProductName;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final ValueChanged<bool> onHideProductNameChanged;
  final VoidCallback onChanged;
  final AddressModel? selectedAddress;
  final VoidCallback? onAddressPressed;

  const ShippingInfoCard({
    super.key,
    required this.isLoggedIn,
    required this.hideProductName,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.addressController,
    required this.onHideProductNameChanged,
    required this.onChanged,
    this.selectedAddress,
    this.onAddressPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn) {
      return _LoggedInAddressCard(
        address: selectedAddress,
        onPressed: onAddressPressed,
        hideProductName: hideProductName,
        onHideProductNameChanged: onHideProductNameChanged,
      );
    }

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(icon: LucideIcons.mapPin, title: 'Thông tin nhận hàng'),
          const SizedBox(height: 8),
          if (!isLoggedIn)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Bạn chưa đăng nhập. Nhập thông tin bên dưới để thanh toán. Khi bấm Đặt hàng, hệ thống sẽ tạo tài khoản tự động và giữ phiên đăng nhập trên thiết bị này.',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.35),
              ),
            ),
          _Input(controller: nameController, hint: 'Họ và tên *', onChanged: onChanged),
          const SizedBox(height: 10),
          _Input(controller: emailController, hint: 'Email *', keyboardType: TextInputType.emailAddress, onChanged: onChanged),
          const SizedBox(height: 10),
          _Input(controller: phoneController, hint: 'Số điện thoại *', keyboardType: TextInputType.phone, onChanged: onChanged),
          const SizedBox(height: 10),
          _Input(controller: addressController, hint: 'Địa chỉ nhận hàng *', maxLines: 2, onChanged: onChanged),
          const SizedBox(height: 10),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: hideProductName,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) => onHideProductNameChanged(value ?? false),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Che tên sản phẩm khi giao hàng', style: TextStyle(fontSize: 12.5, color: Color(0xFF1E293B))),
              const SizedBox(width: 4),
              const Icon(LucideIcons.helpCircle, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoggedInAddressCard extends StatelessWidget {
  final AddressModel? address;
  final VoidCallback? onPressed;
  final bool hideProductName;
  final ValueChanged<bool> onHideProductNameChanged;

  const _LoggedInAddressCard({
    required this.address,
    required this.onPressed,
    required this.hideProductName,
    required this.onHideProductNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null;
    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Row(
              children: [
                const Icon(LucideIcons.mapPin, size: 16, color: AppColors.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: hasAddress
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${address!.fullName}  (+84) ${address!.phone}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
                            const SizedBox(height: 4),
                            Text(address!.email, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                            const SizedBox(height: 3),
                            Text(address!.fullAddress, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10.5, color: Color(0xFF64748B))),
                          ],
                        )
                      : const Text('Chưa thiết lập địa chỉ', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                ),
                const Icon(LucideIcons.chevronRight, size: 18, color: Color(0xFF94A3B8)),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: Checkbox(
                  value: hideProductName,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (value) => onHideProductNameChanged(value ?? false),
                ),
              ),
              const SizedBox(width: 8),
              const Text('Che tên sản phẩm khi giao hàng', style: TextStyle(fontSize: 12.5, color: Color(0xFF1E293B))),
              const SizedBox(width: 4),
              const Icon(LucideIcons.helpCircle, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Input extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;
  final int maxLines;
  final VoidCallback onChanged;

  const _Input({required this.controller, required this.hint, required this.onChanged, this.keyboardType, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      onChanged: (_) => onChanged(),
      style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
        border: _border(),
        enabledBorder: _border(),
        focusedBorder: _border(color: AppColors.primary, width: 1.5),
      ),
    );
  }

  OutlineInputBorder _border({Color color = const Color(0xFFE2E8F0), double width = 1}) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: color, width: width));
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        const SizedBox(width: 8),
        Text(title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold, color: Color(0xFF0F172A))),
      ],
    );
  }
}

class _CardShell extends StatelessWidget {
  final Widget child;

  const _CardShell({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: child,
    );
  }
}
