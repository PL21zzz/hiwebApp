import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/checkout/checkout_mock_data.dart';
import '../../models/product/product_detail_model.dart';
import '../../services/auth_service.dart';
import '../../services/user/address_service.dart';
import '../../theme/app_colors.dart';
import '../../widgets/checkout/checkout_bottom_bar.dart';
import '../../widgets/checkout/payment_method_card.dart';
import '../../widgets/checkout/shipping_info_card.dart';
import '../../widgets/checkout/shop_item_card.dart';
import '../../widgets/checkout/voucher_coins_card.dart';
import '../../widgets/common/top_notification.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductDetailModel productDetail;
  final String? selectedVariant;
  final int quantity;

  const CheckoutScreen({
    super.key,
    required this.productDetail,
    required this.selectedVariant,
    required this.quantity,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _hideProductName = true;
  bool _useCoins = false;
  String _paymentMethod = 'cod';

  @override
  void initState() {
    super.initState();
    _autoFillUserInfo();
  }

  void _autoFillUserInfo() {
    final user = AuthService.instance.currentUser;
    final address = AddressService.instance.defaultAddress;
    if (address != null) {
      _nameController.text = address.fullName;
      _phoneController.text = address.phone;
      _addressController.text = address.fullAddress;
      _emailController.text = address.email;
    } else if (user != null) {
      _nameController.text = user.fullName;
      _phoneController.text = user.phoneNumber;
      _emailController.text = user.email;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  String _formatCurrency(double value) {
    final text = value.toInt().toString();
    final buffer = StringBuffer();
    for (var i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) buffer.write('.');
      buffer.write(text[i]);
    }
    return '$bufferđ';
  }

  double get _totalPrice {
    final total = widget.productDetail.price * widget.quantity;
    return _useCoins
        ? (total - CheckoutMockData.coinsBalance).clamp(0, double.infinity)
        : total;
  }

  double get _savedAmount =>
      (widget.productDetail.originalPrice * widget.quantity - _totalPrice)
          .clamp(0, double.infinity);

  bool get _isFormValid =>
      _nameController.text.trim().isNotEmpty &&
      _emailController.text.trim().isNotEmpty &&
      _phoneController.text.trim().isNotEmpty &&
      _addressController.text.trim().isNotEmpty;

  String _imageUrl() {
    final media = widget.productDetail.mediaList;
    final images = media.where((item) => !item.isVideo).toList();
    if (images.isNotEmpty) return images.first.url;
    if (media.isNotEmpty && media.first.thumb.isNotEmpty) return media.first.thumb;
    return CheckoutMockData.fallbackImage;
  }

  void _handlePlaceOrder() {
    if (!_isFormValid) {
      TopNotification.show(context, message: 'Vui lòng điền đầy đủ các thông tin nhận hàng có dấu *', isError: true);
      return;
    }

    if (!AuthService.instance.isLoggedIn) {
      final names = _nameController.text.trim().split(' ');
      final email = _emailController.text.trim();
      final phone = _phoneController.text.trim();
      final username = email.split('@').first;
      if (!AuthService.instance.isUserNameTaken(username) &&
          !AuthService.instance.isEmailTaken(email) &&
          !AuthService.instance.isPhoneTaken(phone)) {
        AuthService.instance.register(
          userName: username,
          password: 'Password@123',
          firstName: names.isNotEmpty ? names.last : 'Khách',
          lastName: names.length > 1 ? names.sublist(0, names.length - 1).join(' ') : '',
          phoneNumber: phone,
          email: email,
        );
      }
    }

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(children: [Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28), SizedBox(width: 8), Text('Đặt hàng thành công!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
        content: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Cảm ơn ${_nameController.text.trim()} đã mua sắm tại VietMade.'),
          const SizedBox(height: 8),
          Text('Sản phẩm: ${widget.productDetail.name}', style: const TextStyle(fontWeight: FontWeight.w600)),
          Text('${CheckoutMockData.productVariantPrefix}${widget.selectedVariant ?? 'Chưa chọn'} | SL: ${widget.quantity}', style: const TextStyle(color: Color(0xFF64748B))),
          Text('Tổng thanh toán: ${_formatCurrency(_totalPrice)}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
          const SizedBox(height: 8),
          Text('Địa chỉ giao: ${_addressController.text.trim()}', style: const TextStyle(color: Color(0xFF64748B))),
        ]),
        actions: [TextButton(onPressed: () { Navigator.of(context).pop(); Navigator.of(context).pop(); }, child: const Text('VỀ TRANG CHỦ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(icon: const Icon(LucideIcons.chevronLeft, color: Colors.white), onPressed: () => Navigator.of(context).pop()),
        title: const Text('Thanh toán', style: TextStyle(color: Colors.white, fontSize: 17, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(children: [
          ShippingInfoCard(
            isLoggedIn: AuthService.instance.isLoggedIn,
            hideProductName: _hideProductName,
            nameController: _nameController,
            emailController: _emailController,
            phoneController: _phoneController,
            addressController: _addressController,
            onHideProductNameChanged: (value) => setState(() => _hideProductName = value),
            onChanged: () => setState(() {}),
          ),
          const SizedBox(height: 12),
          ShopItemCard(productDetail: widget.productDetail, selectedVariant: widget.selectedVariant, quantity: widget.quantity, imageUrl: _imageUrl(), formatCurrency: _formatCurrency),
          const SizedBox(height: 12),
          VoucherCoinsCard(useCoins: _useCoins, onUseCoinsChanged: (value) => setState(() => _useCoins = value)),
          const SizedBox(height: 12),
          PaymentMethodCard(paymentMethod: _paymentMethod, onPaymentMethodChanged: (value) => setState(() => _paymentMethod = value)),
          const SizedBox(height: 90),
        ]),
      ),
      bottomNavigationBar: CheckoutBottomBar(totalLabel: _formatCurrency(_totalPrice), savingsLabel: 'Tiết kiệm ${_formatCurrency(_savedAmount)}', isValid: _isFormValid, onPlaceOrder: _handlePlaceOrder),
    );
  }
}
