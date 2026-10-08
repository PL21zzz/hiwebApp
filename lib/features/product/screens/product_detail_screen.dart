import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'package:hiweb_app_management/core/core.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/features/cart_checkout/cart_checkout.dart';
import 'package:hiweb_app_management/features/product/product.dart';

class ProductDetailScreen extends StatefulWidget {
  final int initialTabIndex;
  final ProductDetailModel? productDetail;
  final ProductModel? product;

  const ProductDetailScreen({
    super.key,
    this.initialTabIndex = 0,
    this.productDetail,
    this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ScrollController _mainScrollController = ScrollController();

  final GlobalKey _overviewKey = GlobalKey();
  final GlobalKey _reviewsKey = GlobalKey();
  final GlobalKey _detailsKey = GlobalKey();
  final GlobalKey _similarProductsKey = GlobalKey();
  final ProductRepository _productRepository = MockProductRepository();
  late final AsyncState<ProductDetailModel> _detailState;

  late int _selectedTabIndex;
  bool _isProgrammaticScroll = false;
  bool _isLoading = true;
  String? _selectedCapacity; // Initially null (unselected)
  String _customizationText = '';
  String? _customizationImagePath;

  ProductDetailModel get _detail => _detailState.data!;

  ProductDetailModel _resolveDetail() {
    if (widget.productDetail != null) return widget.productDetail!;
    if (widget.product != null) {
      return _productRepository.getProductDetail(widget.product!.id);
    }
    return _productRepository.getFallbackDetail();
  }

  @override
  void initState() {
    super.initState();
    _detailState = AsyncState.success(_resolveDetail());
    _selectedTabIndex = widget.initialTabIndex;
    _mainScrollController.addListener(_onScroll);
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _mainScrollController.removeListener(_onScroll);
    _mainScrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_mainScrollController.hasClients) return;
    if (_isProgrammaticScroll) return;

    // Scroll-Spy detection via section keys
    final detailsBox =
        _detailsKey.currentContext?.findRenderObject() as RenderBox?;
    final reviewsBox =
        _reviewsKey.currentContext?.findRenderObject() as RenderBox?;

    int newIndex = 0;
    if (detailsBox != null && detailsBox.attached) {
      final detailsPos = detailsBox.localToGlobal(Offset.zero);
      if (detailsPos.dy <= 150) {
        newIndex = 2;
      } else if (reviewsBox != null && reviewsBox.attached) {
        final reviewsPos = reviewsBox.localToGlobal(Offset.zero);
        if (reviewsPos.dy <= 150) {
          newIndex = 1;
        } else {
          newIndex = 0;
        }
      }
    } else if (reviewsBox != null && reviewsBox.attached) {
      final reviewsPos = reviewsBox.localToGlobal(Offset.zero);
      if (reviewsPos.dy <= 150) {
        newIndex = 1;
      } else {
        newIndex = 0;
      }
    }

    if (newIndex != _selectedTabIndex) {
      setState(() {
        _selectedTabIndex = newIndex;
      });
    }
  }

  void _onTabHeaderTapped(int tabIndex) {
    setState(() {
      _selectedTabIndex = tabIndex;
      _isProgrammaticScroll = true;
    });

    GlobalKey targetKey;
    switch (tabIndex) {
      case 1:
        targetKey = _reviewsKey;
        break;
      case 2:
        targetKey = _detailsKey;
        break;
      case 0:
      default:
        targetKey = _overviewKey;
        break;
    }

    final targetContext = targetKey.currentContext;
    if (targetContext != null) {
      Scrollable.ensureVisible(
        targetContext,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      ).then((_) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _isProgrammaticScroll = false;
          }
        });
      });
    } else {
      _isProgrammaticScroll = false;
    }
  }

  void _handlePurchaseAction(String actionLabel) {
    if (actionLabel == 'Mua ngay') {
      BuyNowBottomSheet.show(
        context,
        productDetail: _detail,
        initialCapacity: _selectedCapacity,
        initialCustomizationText: _customizationText,
        initialCustomizationImagePath: _customizationImagePath,
        onConfirm: (
          selectedVariant,
          quantity,
          customizationText,
          customizationImagePath,
        ) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder:
                  (context, animation, secondaryAnimation) => CheckoutScreen(
                    productDetail: _detail,
                    selectedVariant: selectedVariant,
                    quantity: quantity,
                    customizationText: customizationText,
                    customizationImagePath: customizationImagePath,
                  ),
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
            ),
          );
        },
      );
      return;
    }

    if (!AuthService.instance.isLoggedIn) {
      TopNotification.show(
        context,
        message: 'Bạn chưa đăng nhập!',
        isError: true,
      );
      return;
    }

    final cartItem = CartItemModel(
      id: _detail.id,
      shopName:
          _detail.shopProfile.name.isNotEmpty
              ? _detail.shopProfile.name
              : 'VietMade Store',
      name: _detail.name,
      imageUrl:
          _detail.mediaList.isNotEmpty &&
                  _detail.mediaList.first.isVideo &&
                  _detail.mediaList.first.thumb.isNotEmpty
              ? _detail.mediaList.first.thumb
              : _detail.mediaList.isNotEmpty
              ? _detail.mediaList.first.url
              : 'assets/images/flash-sale1.webp',
      brand: 'VietMade',
      variantInfo:
          _selectedCapacity != null
              ? 'Đã chọn: $_selectedCapacity'
              : 'Đã chọn: Mặc định',
      price: _detail.price.toInt(),
      originalPrice: _detail.originalPrice.toInt(),
      quantity: 1,
      isSelected: true,
    );

    CartService.instance.addToCart(cartItem);

    TopNotification.show(
      context,
      message: 'Đã thêm "${cartItem.name}" vào giỏ hàng',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: _isLoading
            ? const ProductDetailSkeleton()
            : Column(
          children: [
            // 1. Fixed Header Bar (Teal Primary fixed at top)
            ProductDetailHeaderBar(
              selectedTabIndex: _selectedTabIndex,
              onTabHeaderTapped: _onTabHeaderTapped,
              productDetail: _detail,
            ),

            // 2. Continuous Scroll View across Overview, Reviews, Details sections
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _mainScrollController,
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        // Section 1: Overview
                        Container(
                          key: _overviewKey,
                          child: ProductOverviewTab(
                            productDetail: _detail,
                            selectedCapacity: _selectedCapacity,
                            onCapacitySelected: (cap) {
                              setState(() {
                                _selectedCapacity = cap;
                              });
                            },
                            customizationText: _customizationText,
                            customizationImagePath: _customizationImagePath,
                            onCustomizationTextChanged: (value) {
                              setState(() => _customizationText = value);
                            },
                            onCustomizationImageChanged: (value) {
                              setState(() => _customizationImagePath = value);
                            },
                          ),
                        ),

                        // Section 2: Reviews
                        Container(
                          key: _reviewsKey,
                          child: ProductReviewsTab(
                            productDetail: _detail,
                            onViewAllReviews: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (_) => ProductReviewsScreen(
                                        productDetail: _detail,
                                      ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Standard grey section divider bar before Section 3
                        Container(height: 8, color: const Color(0xFFF8FAFC)),

                        // Section 3: Details & Related Products
                        Container(
                          key: _detailsKey,
                          child: ProductDetailsTab(
                            productDetail: _detail,
                            similarProductsKey: _similarProductsKey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Floating Shopping Cart Button
                  Positioned(
                    right: 14,
                    bottom: 14,
                    child: GestureDetector(
                      onTap: () {
                        if (!AuthService.instance.isLoggedIn) {
                          TopNotification.show(
                            context,
                            message: 'Bạn chưa đăng nhập!',
                            isError: true,
                          );
                          return;
                        }
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) =>
                                    const CartScreen(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: ListenableBuilder(
                        listenable: Listenable.merge([
                          CartService.instance,
                          AuthService.instance,
                        ]),
                        builder: (context, _) {
                          final cartCount = AuthService.instance.isLoggedIn
                              ? CartService.instance.totalItemCount
                              : 0;
                          return Stack(
                            clipBehavior: Clip.none,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.12,
                                      ),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  LucideIcons.shoppingCart,
                                  color: AppColors.primary,
                                  size: 21,
                                ),
                              ),
                              if (cartCount > 0)
                                Positioned(
                                  top: -4,
                                  right: -4,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 5,
                                      vertical: 2,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFEF4444),
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Center(
                                      child: Text(
                                        '$cartCount',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 3. Fixed Bottom Action Bar (Chat, Thêm vào giỏ, Mua ngay)
            ProductDetailBottomBar(onPurchaseAction: _handlePurchaseAction),
          ],
        ),
      ),
    );
  }
}
