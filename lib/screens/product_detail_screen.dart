import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../models/product_detail_model.dart';
import '../theme/app_colors.dart';
import '../widgets/product_detail/product_details_tab.dart';
import '../widgets/product_detail/product_overview_tab.dart';
import '../widgets/product_detail/product_reviews_tab.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final int initialTabIndex;
  final ProductDetailModel? productDetail;

  const ProductDetailScreen({
    super.key,
    this.initialTabIndex = 0,
    this.productDetail,
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
      widget.productDetail ?? ProductDetailModel.mockSample;

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
    if (_selectedCapacity == null) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              Icon(LucideIcons.alertCircle, color: Colors.white, size: 18),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Vui lòng chọn Dung tích sản phẩm trước khi mua!',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFFEF4444),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$actionLabel thành công! (Dung tích: $_selectedCapacity)',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.primary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildTabHeaderItem(String title, int tabIndex) {
    final isSelected = _selectedTabIndex == tabIndex;
    return GestureDetector(
      onTap: () => _onTabHeaderTapped(tabIndex),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        height: 48,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: isSelected ? 13 : 12.5,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ),
            if (isSelected)
              Positioned(
                bottom: 4,
                child: Container(
                  height: 2.5,
                  width: 22,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
          ],
        ),
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
            Container(
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Back Button
                      InkWell(
                        onTap: () => Navigator.of(context).pop(),
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            LucideIcons.arrowLeft,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),

                      // 3 Header Tabs inside FittedBox (Vertically centered)
                      Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildTabHeaderItem('Tổng quan', 0),
                                const SizedBox(width: 2),
                                _buildTabHeaderItem('Đánh giá', 1),
                                const SizedBox(width: 2),
                                _buildTabHeaderItem('Sản phẩm', 2),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Search Button
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: Icon(
                            LucideIcons.search,
                            color: Colors.white,
                            size: 19,
                          ),
                        ),
                      ),

                      // Share Button (Custom Web SVG curved arrow share icon)
                      InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(20),
                        child: const Padding(
                          padding: EdgeInsets.all(6),
                          child: WebShareIcon(
                            size: 19,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Continuous Scroll View across Overview, Reviews, Details sections
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    controller: _mainScrollController,
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
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: SafeArea(
                top: false,
                minimum: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    // Chat Button
                    InkWell(
                      onTap: () {},
                      borderRadius: BorderRadius.circular(8),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              LucideIcons.messageSquare,
                              size: 19,
                              color: AppColors.primary,
                            ),
                            SizedBox(height: 2),
                            Text(
                              'Chat',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Add to Cart Button (Light Teal - Stacked Icon & Text matching sample)
                    Expanded(
                      flex: 4,
                      child: SizedBox(
                        height: 42,
                        child: Material(
                          color: const Color(0xFFE0F2FE),
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            onTap: () => _handlePurchaseAction('Thêm vào giỏ'),
                            borderRadius: BorderRadius.circular(22),
                            child: const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  LucideIcons.shoppingCart,
                                  size: 15,
                                  color: AppColors.primary,
                                ),
                                SizedBox(height: 1),
                                Text(
                                  'Thêm vào giỏ',
                                  style: TextStyle(
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Buy Now Button (Solid Teal - Validates Capacity Selection)
                    Expanded(
                      flex: 5,
                      child: SizedBox(
                        height: 42,
                        child: Material(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(22),
                          child: InkWell(
                            onTap: () => _handlePurchaseAction('Mua ngay'),
                            borderRadius: BorderRadius.circular(22),
                            child: const Center(
                              child: Text(
                                'Mua ngay',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WebShareIcon extends StatelessWidget {
  final double size;
  final Color color;

  const WebShareIcon({
    super.key,
    this.size = 20.0,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size),
      painter: _WebShareIconPainter(color: color),
    );
  }
}

class _WebShareIconPainter extends CustomPainter {
  final Color color;

  _WebShareIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 32.0;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4 * scale
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    path.moveTo(5 * scale, 26 * scale);
    path.cubicTo(
      5.7 * scale, 17.5 * scale,
      10.3 * scale, 11.8 * scale,
      19 * scale, 10.4 * scale,
    );
    path.lineTo(19 * scale, 5.7 * scale);
    path.cubicTo(
      19 * scale, 5.1 * scale,
      19.7 * scale, 4.8 * scale,
      20.2 * scale, 5.2 * scale,
    );
    path.lineTo(28.2 * scale, 11.3 * scale);
    path.cubicTo(
      28.7 * scale, 11.7 * scale,
      28.7 * scale, 12.4 * scale,
      28.2 * scale, 12.8 * scale,
    );
    path.lineTo(20.2 * scale, 19 * scale);
    path.cubicTo(
      19.7 * scale, 19.4 * scale,
      19 * scale, 19.1 * scale,
      19 * scale, 18.5 * scale,
    );
    path.lineTo(19 * scale, 13.9 * scale);
    path.cubicTo(
      12.2 * scale, 14.8 * scale,
      7.6 * scale, 18.7 * scale,
      5 * scale, 26 * scale,
    );
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WebShareIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
