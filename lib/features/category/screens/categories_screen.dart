import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/category/services/category_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/category_drawer.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/common_loading.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';
import 'package:hiweb_app_management/features/product/screens/category_product_list_screen.dart';

import 'package:hiweb_app_management/core/widgets/common/loading/shimmer_box.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  int _selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _simulateLoading();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CategoryService.instance.fetchRootCategories();
    });
  }

  Future<void> _simulateLoading() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 450));
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CategoryService.instance,
      builder: (context, _) {
        final categories = CategoryService.instance.rootCategories;
        final rootState = CategoryService.instance.rootState;
        if (_isLoading || rootState.isLoading || (categories.isEmpty && !rootState.hasError)) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const VietmadeHeader(showMenu: false),
            body: Row(
              children: [
                // Skeleton Sidebar
                Expanded(
                  flex: 1,
                  child: Container(
                    color: const Color(0xFFF8FAFC),
                    child: ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: 8,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (_, __) => const Padding(
                        padding: EdgeInsets.all(12),
                        child: Row(
                          children: [
                            ShimmerBox(width: 20, height: 20, borderRadius: BorderRadius.all(Radius.circular(10))),
                            SizedBox(width: 8),
                            Expanded(child: ShimmerBox(height: 14)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Skeleton Subcategory Grid
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const ShimmerBox(width: 140, height: 20),
                        const SizedBox(height: 16),
                        Expanded(
                          child: GridView.builder(
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 12,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.8,
                            ),
                            itemCount: 6,
                            itemBuilder: (_, __) => const Column(
                              children: [
                                ShimmerBox(width: 50, height: 50, borderRadius: BorderRadius.all(Radius.circular(25))),
                                SizedBox(height: 8),
                                ShimmerBox(width: 60, height: 12),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (rootState.hasError && categories.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const VietmadeHeader(showMenu: false),
            drawer: const CategoryDrawer(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(LucideIcons.wifiOff, size: 48, color: Color(0xFF94A3B8)),
                    const SizedBox(height: 12),
                    Text(
                      rootState.errorMessage ?? 'Không thể tải danh sách danh mục',
                      style: const TextStyle(fontSize: 14, color: Color(0xFF475569)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: CategoryService.instance.fetchRootCategories,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      icon: const Icon(LucideIcons.refreshCw, size: 16),
                      label: const Text('Thử lại'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (categories.isEmpty) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: const VietmadeHeader(showMenu: false),
            drawer: const CategoryDrawer(),
            body: const Center(
              child: Text(
                'Không có dữ liệu danh mục',
                style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              ),
            ),
          );
        }

        final safeIndex = _selectedIndex < categories.length ? _selectedIndex : 0;
        final selectedCategory = categories[safeIndex];
        final subcategories =
            CategoryService.instance.getCategoryTreeFor(selectedCategory.id);
        final treeState =
          CategoryService.instance.treeStateFor(selectedCategory.id);

        return Scaffold(
          backgroundColor: Colors.white,
          appBar: const VietmadeHeader(showMenu: false),
          drawer: const CategoryDrawer(),
          body: Row(
            children: [
              // 1. Left Sidebar: Categories Navigation List (Ratio 1)
              Expanded(
                flex: 1,
                child: Container(
                  color: const Color(0xFFF8FAFC),
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: categories.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1,
                      thickness: 0.5,
                      color: Color(0xFFE2E8F0),
                    ),
                    itemBuilder: (context, index) {
                      final isSelected = safeIndex == index;
                      final item = categories[index];

                      return InkWell(
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          CategoryService.instance.fetchCategoryTree(item.id);
                        },
                        child: Container(
                          height: 56,
                          color: isSelected ? Colors.white : const Color(0xFFF8FAFC),
                          child: Row(
                            children: [
                              // Left Active Indicator Bar
                              Container(
                                width: 3,
                                height: double.infinity,
                                color: isSelected ? AppColors.primary : Colors.transparent,
                              ),
                              const SizedBox(width: 5),
                              // Category Title Text
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4),
                                  child: Text(
                                    item.title,
                                    style: TextStyle(
                                      fontSize: 11.5,
                                      fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                      color: isSelected ? AppColors.primary : const Color(0xFF475569),
                                      height: 1.2,
                                    ),
                                    maxLines: 3,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                },
              ),
            ),
          ),

          // Divider between sidebar and main panel
          Container(
            width: 1,
            color: const Color(0xFFE2E8F0),
          ),

          // 2. Right Main Panel: Subcategories Grid (Ratio 4)
          Expanded(
            flex: 4,
            child: Container(
              color: Colors.white,
                child: treeState.hasError
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(treeState.errorMessage ?? 'Không thể tải danh mục con'),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => CategoryService.instance
                                  .fetchCategoryTree(selectedCategory.id),
                              child: const Text('Thử lại'),
                            ),
                          ],
                        ),
                      )
                    : CategoryService.instance.isLoadingTree
                    ? const CommonLoading(message: 'Đang tải danh mục...')
                    : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category Header Title
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Text(
                      selectedCategory.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Grid of Subcategories
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.85,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: subcategories.length + 1, // 1 extra for "Xem Tất Cả"
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          // First Item: "Xem Tất Cả"
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) =>
                                      CategoryProductListScreen(
                                    categoryTitle: selectedCategory.title,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
                            },
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 52,
                                  height: 52,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF1F5F9),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      LucideIcons.layoutGrid,
                                      size: 22,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Xem Tất Cả',
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                    height: 1.2,
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          );
                        }

                        final item = subcategories[index - 1];
                        return InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                    CategoryProductListScreen(
                                  categoryTitle: item.title,
                                ),
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                              ),
                            );
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 52,
                                height: 52,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF1F5F9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    LucideIcons.layoutGrid,
                                    size: 22,
                                    color: Color(0xFF64748B),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                item.title,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF475569),
                                  height: 1.2,
                                ),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
      },
    );
  }
}

