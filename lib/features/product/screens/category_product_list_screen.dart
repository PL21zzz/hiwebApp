import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/home/models/category_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_grid.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_footer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/category_drawer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_bottom_nav_bar.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/filter_drawer.dart';

import 'package:hiweb_app_management/core/widgets/common/loading/product_card_skeleton.dart';

class CategoryProductListScreen extends StatefulWidget {
  final String categoryTitle;

  const CategoryProductListScreen({
    super.key,
    this.categoryTitle = 'Thực phẩm chức năng',
  });

  @override
  State<CategoryProductListScreen> createState() => _CategoryProductListScreenState();
}

class _CategoryProductListScreenState extends State<CategoryProductListScreen> {
  final GlobalKey _sortButtonKey = GlobalKey();
  String _selectedSortOption = 'Mới nhất';
  OverlayEntry? _sortOverlayEntry;
  bool _isSortMenuOpen = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  static const List<String> _sortOptions = CategoryModel.sortOptions;

  @override
  void dispose() {
    _removeSortMenu();
    super.dispose();
  }

  void _removeSortMenu() {
    _sortOverlayEntry?.remove();
    _sortOverlayEntry = null;
    if (mounted) {
      setState(() {
        _isSortMenuOpen = false;
      });
    }
  }

  void _toggleSortMenu() {
    if (_isSortMenuOpen) {
      _removeSortMenu();
      return;
    }

    final RenderBox? renderBox =
        _sortButtonKey.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;

    _sortOverlayEntry = OverlayEntry(
      builder: (context) {
        return Stack(
          children: [
            // Barrier to catch taps outside and dismiss instantly
            GestureDetector(
              onTap: _removeSortMenu,
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent,
              ),
            ),

            // Instant Dropdown Overlay Box
            Positioned(
              top: offset.dy + size.height + 4,
              left: offset.dx,
              width: size.width,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: _sortOptions.map((option) {
                        final isSelected = option == _selectedSortOption;
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedSortOption = option;
                            });
                            _removeSortMenu();
                            _simulateLoading();
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 10,
                            ),
                            color: isSelected
                                ? const Color(0xFFF0F9FF)
                                : Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? const Color(0xFF0284C7)
                                        : const Color(0xFF334155),
                                  ),
                                ),
                                if (isSelected)
                                  const Icon(
                                    LucideIcons.check,
                                    size: 16,
                                    color: Color(0xFF0284C7),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    Overlay.of(context).insert(_sortOverlayEntry!);
    setState(() {
      _isSortMenuOpen = true;
    });
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
        backgroundColor: Colors.white,
        appBar: const VietmadeHeader(),
        drawer: const CategoryDrawer(),
        bottomNavigationBar: const VietmadeBottomNavBar(),
        body: Column(
          children: [
            // Fixed Header Sub-Bar & Filter/Sort Bar
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  // 1. Back button + Category Title dropdown
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () => Navigator.of(context).pop(),
                          borderRadius: BorderRadius.circular(4),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              LucideIcons.chevronLeft,
                              color: Color(0xFF475569),
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.categoryTitle,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(
                              LucideIcons.chevronDown,
                              color: Color(0xFF475569),
                              size: 16,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // 2. Fixed Filter & Sort Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                    child: Row(
                      children: [
                        // Bộ lọc Button
                        Expanded(
                          child: Container(
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: InkWell(
                              onTap: () => FilterDrawer.show(context),
                              borderRadius: BorderRadius.circular(6),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.slidersHorizontal,
                                    size: 15,
                                    color: Color(0xFF475569),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Bộ lọc',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),

                        // Sắp xếp Button (sổ ra menu trực tiếp tức thì)
                        Expanded(
                          child: Container(
                            key: _sortButtonKey,
                            height: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: const Color(0xFFE2E8F0)),
                            ),
                            child: InkWell(
                              onTap: _toggleSortMenu,
                              borderRadius: BorderRadius.circular(6),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    LucideIcons.arrowUpDown,
                                    size: 15,
                                    color: Color(0xFF475569),
                                  ),
                                  SizedBox(width: 6),
                                  Text(
                                    'Sắp xếp',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFF1F5F9)),

            // Scrollable Content Area: Product Grid 2 + Grey Gap + Footer
            Expanded(
              child: RefreshIndicator(
                onRefresh: _simulateLoading,
                color: AppColors.primary,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    children: [
                      // Product Grid 2 (6 items, blue box background #BCEDF4)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(6),
                        color: AppColors.productBoxBg,
                        child: _isLoading
                            ? const ProductGridSkeleton(itemCount: 6)
                            : const ProductGrid(itemCount: 6),
                      ),

                      // Grey spacer (60px) before footer
                      Container(
                        height: 60,
                        color: AppColors.background,
                      ),

                      // VietmadeFooter
                      const VietmadeFooter(),
                    ],
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
