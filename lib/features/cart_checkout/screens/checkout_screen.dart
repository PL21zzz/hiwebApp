import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/checkout_mock_data.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/user/address/models/address_model.dart';
import 'package:hiweb_app_management/features/user/address/screens/address_screen.dart';
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
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';
import 'package:hiweb_app_management/features/user/voucher/repositories/voucher_repository.dart';

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
    AppBottomSheet.show<void>(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => _AddressSelectionSheet(
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
        message: 'Vui lòng điền đầy đủ các thông tin nhận hàng có dấu *',
        isError: true,
      );
      return;
    }

    setState(() => _isPlacingOrder = true);

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

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Color(0xFF10B981), size: 28),
                SizedBox(width: 8),
                Text(
                  'Đặt hàng thành công!',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Cảm ơn ${_nameController.text.trim()} đã mua sắm tại VietMade.',
                ),
                const SizedBox(height: 8),
                Text(
                  'Sản phẩm: ${widget.productDetail.name}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${CheckoutMockData.productVariantPrefix}${widget.selectedVariant ?? 'Chưa chọn'} | SL: ${widget.quantity}',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
                Text(
                  'Tổng thanh toán: ${_formatCurrency(_totalPrice)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF4444),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Mã đơn: ${order.id}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  'Địa chỉ giao: ${_addressController.text.trim()}',
                  style: const TextStyle(color: Color(0xFF64748B)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'VỀ TRANG CHỦ',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
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

class _AddressSelectionSheet extends StatelessWidget {
  final List<AddressModel> addresses;
  final ValueChanged<AddressModel> onSelected;

  const _AddressSelectionSheet({
    required this.addresses,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final sheetHeight = MediaQuery.sizeOf(context).height * 0.8;
    return SafeArea(
      top: false,
      child: Container(
        height: isAndroid ? sheetHeight : null,
        constraints: BoxConstraints(maxHeight: isAndroid ? sheetHeight : 560),
        margin:
            isAndroid
                ? EdgeInsets.only(top: MediaQuery.sizeOf(context).height * 0.2)
                : null,
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
        ),
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
                  const Expanded(
                    child: Text(
                      'Chọn địa chỉ nhận hàng',
                      style: TextStyle(
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
            const Divider(height: 1),
            if (addresses.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 28),
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
              )
            else
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(14),
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
              ),

            // Bottom Add New Address Button (Styled identically to AddressScreen button)
            Container(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 14),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
              ),
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
            ),
          ],
        ),
      ),
    );
  }
}
