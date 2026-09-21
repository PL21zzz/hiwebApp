import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/product/product_detail_model.dart';
import '../../models/product/product_model.dart';
import '../../widgets/common/vietmade_footer.dart';
import '../../widgets/shop_detail/shop_banner_header.dart';
import '../../widgets/shop_detail/shop_product_card.dart';

class ShopDetailScreen extends StatefulWidget {
  final ShopProfileModel shop;

  const ShopDetailScreen({
    super.key,
    required this.shop,
  });

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _rankBadges = ShopProfileModel.mockRankBadges;
  final List<String> _categoryNames = ShopProfileModel.mockCategoryNames;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8FAFC),
        body: SafeArea(
          top: false,
          child: NestedScrollView(
            key: const PageStorageKey<String>('shop_detail_nested_scroll'),
            physics: const ClampingScrollPhysics(),
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // 1. Top Shop Banner Header Widget
                SliverToBoxAdapter(
                  child: ShopBannerHeader(shop: widget.shop),
                ),

                // 2. TabBar Header (Not Pinned)
                SliverPersistentHeader(
                  pinned: false,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      isScrollable: false,
                      indicatorColor: const Color(0xFF0284C7),
                      indicatorWeight: 3.0,
                      indicatorSize: TabBarIndicatorSize.tab,
                      labelPadding: EdgeInsets.zero,
                      labelColor: const Color(0xFF0284C7),
                      unselectedLabelColor: const Color(0xFF475569),
                      labelStyle: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.bold,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                      ),
                      tabs: const [
                        Tab(text: 'Shop'),
                        Tab(text: 'Sản phẩm'),
                        Tab(text: 'Danh mục hàng'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              physics: const ClampingScrollPhysics(),
              children: [
                // Tab 1: Shop ("| Gợi ý cho bạn")
                _buildProductGridTab(
                  key: const PageStorageKey<String>('tab_shop'),
                  title: 'Gợi ý cho bạn',
                ),

                // Tab 2: Sản phẩm ("| Tất cả sản phẩm")
                _buildProductGridTab(
                  key: const PageStorageKey<String>('tab_products'),
                  title: 'Tất cả sản phẩm',
                ),

                // Tab 3: Danh mục hàng
                _buildCategoriesTab(
                  key: const PageStorageKey<String>('tab_categories'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REUSABLE PRODUCT GRID TAB ("Gợi ý cho bạn" / "Tất cả sản phẩm")
  // ---------------------------------------------------------------------------
  Widget _buildProductGridTab({required Key key, required String title}) {
    final products = ProductModel.mockProducts;

    return SingleChildScrollView(
      key: key,
      physics: const ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Header: "| Gợi ý cho bạn" or "| Tất cả sản phẩm"
          Padding(
            padding: const EdgeInsets.only(
              left: 12,
              right: 12,
              top: 12,
              bottom: 6,
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 16,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0284C7),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),

          // Product Grid (2 Columns)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.64,
                crossAxisSpacing: 8,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final product = products[index];
                final rankText = index < _rankBadges.length
                    ? _rankBadges[index]
                    : '#${index + 1} Bán chạy';

                return ShopProductCard(
                  product: product,
                  rankText: rankText,
                );
              },
            ),
          ),

          // 80px Top Margin for Footer
          const SizedBox(height: 80),

          // Footer
          const VietmadeFooter(),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TAB 3: DANH MỤC HÀNG CONTENT (Matching media_1789714554710.png)
  // ---------------------------------------------------------------------------
  Widget _buildCategoriesTab({required Key key}) {
    return SingleChildScrollView(
      key: key,
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 12),

          // 2-Column Category Cards Grid
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GridView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _categoryNames.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final name = _categoryNames[index];
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _tabController.animateTo(1);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 0.8,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 3,
                          offset: const Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            name,
                            style: const TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          color: Color(0xFF94A3B8),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 80px Top Margin for Footer
          const SizedBox(height: 80),
          const VietmadeFooter(),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// SLIVER TABBAR DELEGATE
// -----------------------------------------------------------------------------
class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverTabBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(covariant _SliverTabBarDelegate oldDelegate) {
    return oldDelegate._tabBar != _tabBar;
  }
}
