import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/checkout_mock_data.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/user/orders/models/order_model.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/user/address/services/address_service.dart';
import 'package:hiweb_app_management/features/user/orders/services/order_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/checkout_bottom_bar.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/payment_method_card.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/shipping_info_card.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/shop_item_card.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/voucher_coins_card.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'package:hiweb_app_management/features/cart_checkout/widgets/cart_voucher_bottom_sheet.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/vietmade_modal_container.dart';
import 'package:hiweb_app_management/features/user/voucher/repositories/voucher_repository.dart';
import '../widgets/checkout/checkout_address_selection_sheet.dart';
import '../widgets/checkout/checkout_success_dialog.dart';

class CheckoutScreen extends StatefulWidget {
  final ProductDetailModel productDetail;
  final String? selectedVariant;
  final int quantity;
  final String customizationText;
  final String? customizationImagePath;

  const CheckoutScreen({
    super.key,
    required this.productDetail,
    required this.selectedVariant,
    required this.quantity,
    this.customizationText = '',
    this.customizationImagePath,
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
  bool _isPlacingOrder = false;
  String _paymentMethod = 'cod';
  String _selectedCountryCode = '+84';

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_onFormChanged);
    _emailController.addListener(_onFormChanged);
    _phoneController.addListener(_onFormChanged);
    _addressController.addListener(_onFormChanged);
    AddressService.instance.addListener(_onAddressServiceChanged);
    _autoFillUserInfo();
  }

  void _onFormChanged() {
    if (mounted) setState(() {});
  }

  void _onAddressServiceChanged() {
    if (mounted) {
      _autoFillUserInfo();
      setState(() {});
    }
  }

  void _autoFillUserInfo() {
    _nameController.clear();
    _emailController.clear();
    _phoneController.clear();
    _addressController.clear();

    if (!AuthService.instance.isLoggedIn) {
      return;
    }

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
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    AddressService.instance.removeListener(_onAddressServiceChanged);
    _nameController.removeListener(_onFormChanged);
    _emailController.removeListener(_onFormChanged);
    _phoneController.removeListener(_onFormChanged);
    _addressController.removeListener(_onFormChanged);
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

  void _showVietMadeVouchers() {
    CartVoucherBottomSheet.show(
      context,
      title: 'VietMade Voucher',
      vouchers:
          MockVoucherRepository()
              .getVouchers()
              .where((voucher) => voucher.category == 'vietmade')
              .toList(),
    );
  }

  void _showShopVouchers() {
    CartVoucherBottomSheet.show(
      context,
      title: 'Voucher của shop',
      vouchers:
          MockVoucherRepository()
              .getVouchers()
              .where((voucher) => voucher.category == 'shop')
              .toList(),
    );
  }

  void _openAddressSelection() {
    final addresses = AddressService.instance.addresses;
    VietmadeModalContainer.show<void>(
      context: context,
      title: 'Chọn địa chỉ nhận hàng',
      maxHeightRatio: 0.85,
      child: CheckoutAddressSelectionSheet(
        addresses: addresses,
        onSelected: _selectAddress,
      ),
    );
  }

  void _selectAddress(AddressModel address) {
    _nameController.text = address.fullName;
    _emailController.text = address.email;
    _phoneController.text = address.phone;
    _addressController.text = address.fullAddress;
    setState(() {});
  }

  String _imageUrl() {
    final media = widget.productDetail.mediaList;
    final images = media.where((item) => !item.isVideo).toList();
    if (images.isNotEmpty) return images.first.url;
    if (media.isNotEmpty && media.first.thumb.isNotEmpty) {
      return media.first.thumb;
    }
    return CheckoutMockData.fallbackImage;
  }

  String _normalizePhone(String input) {
    var digits = input.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 9) {
      return '0$digits';
    }
    return digits;
  }

  Future<void> _handlePlaceOrder() async {
    if (_isPlacingOrder) return;
    if (!_isFormValid) {
      TopNotification.show(
        context,
        message: 'Vui lòng điền đầy đủ các thông tin nhận hàng',
        isError: true,
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

    await Future.delayed(const Duration(milliseconds: 600));

    if (!AuthService.instance.isLoggedIn) {
      final names = _nameController.text.trim().split(' ');
      final email = _emailController.text.trim();
      final phone = _normalizePhone(_phoneController.text.trim());
      final username = email.split('@').first;
      if (!AuthService.instance.isUserNameTaken(username) &&
          !AuthService.instance.isEmailTaken(email) &&
          !AuthService.instance.isPhoneTaken(phone)) {
        AuthService.instance.register(
          userName: username,
          password: 'Password@123',
          firstName: names.isNotEmpty ? names.last : 'Khách',
          lastName:
              names.length > 1
                  ? names.sublist(0, names.length - 1).join(' ')
                  : '',
          phoneNumber: phone,
          email: email,
        );
      }
    }

    final order = OrderService.instance.createOrder(
      shopName: CheckoutMockData.shopName,
      recipient: _nameController.text.trim(),
      address: _addressController.text.trim(),
      total: _totalPrice.toInt(),
      items: [
        OrderItemModel(
          name: widget.productDetail.name,
          imageUrl: _imageUrl(),
          quantity: widget.quantity,
          price: widget.productDetail.price.toInt(),
        ),
      ],
    );
    if (!mounted) return;
    setState(() => _isPlacingOrder = false);

    CheckoutSuccessDialog.show(
      context,
      order: order,
      recipientName: _nameController.text.trim(),
      productName: widget.productDetail.name,
      selectedVariant: widget.selectedVariant,
      quantity: widget.quantity,
      formattedTotalPrice: _formatCurrency(_totalPrice),
      fullAddress: _addressController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.header,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(LucideIcons.chevronLeft, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Thanh toán',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Column(
          children: [
            ListenableBuilder(
              listenable: AddressService.instance,
              builder: (context, _) {
                final address = AddressService.instance.defaultAddress;
                if (address != null &&
                    _addressController.text != address.fullAddress) {
                  _nameController.text = address.fullName;
                  _emailController.text = address.email;
                  _phoneController.text = address.phone;
                  _addressController.text = address.fullAddress;
                }
                return ShippingInfoCard(
                  isLoggedIn: AuthService.instance.isLoggedIn,
                  selectedAddress: address,
                  onAddressPressed: _openAddressSelection,
                  hideProductName: _hideProductName,
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  addressController: _addressController,
                  selectedCountryCode: _selectedCountryCode,
                  onCountryCodeChanged:
                      (val) => setState(() => _selectedCountryCode = val),
                  onHideProductNameChanged:
                      (value) => setState(() => _hideProductName = value),
                  onChanged: () => setState(() {}),
                );
              },
            ),
            const SizedBox(height: 12),
            ShopItemCard(
              productDetail: widget.productDetail,
              selectedVariant: widget.selectedVariant,
              quantity: widget.quantity,
              imageUrl: _imageUrl(),
              formatCurrency: _formatCurrency,
              onShopVoucherPressed: _showShopVouchers,
            ),
            const SizedBox(height: 12),
            VoucherCoinsCard(
              useCoins: _useCoins,
              onUseCoinsChanged: (value) => setState(() => _useCoins = value),
              onVoucherPressed: _showVietMadeVouchers,
            ),
            const SizedBox(height: 12),
            PaymentMethodCard(
              paymentMethod: _paymentMethod,
              onPaymentMethodChanged:
                  (value) => setState(() => _paymentMethod = value),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
      bottomNavigationBar: CheckoutBottomBar(
        totalLabel: _formatCurrency(_totalPrice),
        savingsLabel: 'Tiết kiệm ${_formatCurrency(_savedAmount)}',
        isValid: _isFormValid,
        isSubmitting: _isPlacingOrder,
        onPlaceOrder: _handlePlaceOrder,
      ),
    );
  }
}
