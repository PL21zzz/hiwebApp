import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/product/product_model.dart';
import '../../models/product/product_detail_model.dart';
import '../../theme/app_colors.dart';
import '../../widgets/common/top_notification.dart';
import '../../widgets/product_detail/details/product_details_tab.dart';
import '../../widgets/product_detail/overview/product_overview_tab.dart';
import '../../widgets/product_detail/product_detail_bottom_bar.dart';
import '../../widgets/product_detail/product_detail_header_bar.dart';
import '../../widgets/product_detail/reviews/product_reviews_tab.dart';
import '../auth/login_screen.dart';
import '../cart/cart_screen.dart';

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

  late int _selectedTabIndex;
  bool _isProgrammaticScroll = false;
  String? _selectedCapacity; // Initially null (unselected)

  ProductDetailModel get _detail =>
      widget.productDetail ??
      (widget.product != null
          ? ProductDetailModel.fromProduct(widget.product!)
          : ProductDetailModel.mockSample);

  @override
  void initState() {
    super.initState();
    _selectedTabIndex = widget.initialTabIndex;
    _mainScrollController.addListener(_onScroll);
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
    TopNotification.show(
      context,
      message: 'Bạn phải đăng nhập để thêm sản phẩm vào giỏ hàng!',
      isError: true,
    );

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
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
        body: Column(
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
                          ),
                        ),

                        // Section 2: Reviews
                        Container(
                          key: _reviewsKey,
                          child: ProductReviewsTab(
                            productDetail: _detail,
                          ),
                        ),

                        // Standard grey section divider bar before Section 3
                        Container(
                          height: 8,
                          color: const Color(0xFFF8FAFC),
                        ),

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
                      child: Container(
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
                              color: Colors.black.withValues(alpha: 0.12),
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
                    ),
                  ),
                ],
              ),
            ),

            // 3. Fixed Bottom Action Bar (Chat, Thêm vào giỏ, Mua ngay)
            ProductDetailBottomBar(
              onPurchaseAction: _handlePurchaseAction,
            ),
          ],
        ),
      ),
    );
  }
}
