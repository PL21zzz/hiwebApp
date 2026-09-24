import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';

class ShippingInfoCard extends StatelessWidget {
  final bool isLoggedIn;
  final bool hideProductName;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;
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
    this.selectedCountryCode = '+84',
    required this.onCountryCodeChanged,
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
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'Bạn chưa đăng nhập. Nhập thông tin bên dưới để thanh toán. Khi bấm Đặt hàng, hệ thống sẽ tạo tài khoản tự động và giữ phiên đăng nhập trên thiết bị này.',
              style: TextStyle(fontSize: 11.5, color: Color(0xFF64748B), height: 1.35),
            ),
          ),
          _Input(controller: nameController, hint: 'Họ và tên *', onChanged: onChanged),
          const SizedBox(height: 10),
          _Input(
            controller: emailController,
            hint: 'Email *',
            keyboardType: TextInputType.emailAddress,
            onChanged: onChanged,
          ),
          const SizedBox(height: 10),
          _PhoneInputWithCountryCode(
            controller: phoneController,
            selectedCountryCode: selectedCountryCode,
            onCountryCodeChanged: onCountryCodeChanged,
            onChanged: onChanged,
          ),
          const SizedBox(height: 10),
          _Input(
            controller: addressController,
            hint: 'Địa chỉ nhận hàng *',
            maxLines: 2,
            onChanged: onChanged,
          ),
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

  String _formatDisplayPhone(String rawPhone) {
    var clean = rawPhone.replaceAll(RegExp(r'\s+'), '');
    if (clean.startsWith('+84')) {
      clean = clean.substring(3);
    }
    if (clean.startsWith('0')) {
      clean = clean.substring(1);
    }
    return '(+84) $clean';
  }

  @override
  Widget build(BuildContext context) {
    final hasAddress = address != null;
    final currentUser = AuthService.instance.currentUser;
    final userName = hasAddress
        ? address!.fullName
        : (currentUser != null ? currentUser.fullName : '');
    final rawPhone = hasAddress
        ? address!.phone
        : (currentUser != null ? currentUser.phoneNumber : '');
    final displayPhone = rawPhone.isNotEmpty ? _formatDisplayPhone(rawPhone) : '';
    final email = hasAddress
        ? address!.email
        : (currentUser != null ? currentUser.email : '');

    return _CardShell(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon Location in a 24px box to align with Checkbox below
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: Center(
                      child: Icon(
                        LucideIcons.mapPin,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Text Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (userName.isNotEmpty)
                          Text(
                            '$userName  $displayPhone',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                        if (email.isNotEmpty) ...[
                          const SizedBox(height: 3),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          hasAddress
                              ? address!.fullAddress
                              : 'Chưa thiết lập địa chỉ nhận hàng',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.5,
                            fontWeight: hasAddress ? FontWeight.normal : FontWeight.w600,
                            color: hasAddress ? const Color(0xFF64748B) : const Color(0xFFEF4444),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      LucideIcons.chevronRight,
                      size: 18,
                      color: Color(0xFF94A3B8),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 8),
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
              const Text(
                'Che tên sản phẩm khi giao hàng',
                style: TextStyle(fontSize: 12.5, color: Color(0xFF1E293B)),
              ),
              const SizedBox(width: 4),
              const Icon(LucideIcons.helpCircle, size: 14, color: Color(0xFF94A3B8)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PhoneInputWithCountryCode extends StatelessWidget {
  final TextEditingController controller;
  final String selectedCountryCode;
  final ValueChanged<String> onCountryCodeChanged;
  final VoidCallback onChanged;

  const _PhoneInputWithCountryCode({
    required this.controller,
    required this.selectedCountryCode,
    required this.onCountryCodeChanged,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          // Country Code Selector Prefix Button
          PopupMenuButton<String>(
            initialValue: selectedCountryCode,
            onSelected: onCountryCodeChanged,
            itemBuilder: (context) => const [
              PopupMenuItem(value: '+84', child: Text('🇻🇳  +84 (Việt Nam)')),
              PopupMenuItem(value: '+1', child: Text('🇺🇸  +1 (Mỹ)')),
              PopupMenuItem(value: '+86', child: Text('🇨🇳  +86 (Trung Quốc)')),
              PopupMenuItem(value: '+81', child: Text('🇯🇵  +81 (Nhật Bản)')),
              PopupMenuItem(value: '+82', child: Text('🇰🇷  +82 (Hàn Quốc)')),
            ],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                border: Border(right: BorderSide(color: Color(0xFFE2E8F0))),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    selectedCountryCode == '+84'
                        ? '🇻🇳'
                        : selectedCountryCode == '+1'
                            ? '🇺🇸'
                            : selectedCountryCode == '+86'
                                ? '🇨🇳'
                                : selectedCountryCode == '+81'
                                    ? '🇯🇵'
                                    : '🇰🇷',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    selectedCountryCode,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const Icon(Icons.arrow_drop_down, size: 18, color: Color(0xFF64748B)),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Phone TextField (9 or 10 digits)
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              onChanged: (_) => onChanged(),
              style: const TextStyle(fontSize: 13, color: Color(0xFF0F172A)),
              decoration: const InputDecoration(
                hintText: 'Số điện thoại (9 hoặc 10 số) *',
                hintStyle: TextStyle(fontSize: 12.5, color: Color(0xFF94A3B8)),
                contentPadding: EdgeInsets.symmetric(horizontal: 4, vertical: 11),
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
            ),
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

  const _Input({
    required this.controller,
    required this.hint,
    required this.onChanged,
    this.keyboardType,
    this.maxLines = 1,
  });

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
