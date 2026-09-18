import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/home/category_model.dart';
import '../../theme/app_colors.dart';
import '../../screens/product/category_product_list_screen.dart';

class CategoryDrawer extends StatefulWidget {
  const CategoryDrawer({super.key});

  @override
  State<CategoryDrawer> createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  DrawerCategoryModel? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final categories = DrawerCategoryModel.mockDrawerCategories;
    final subcategories = _selectedCategory != null
        ? SubcategoryModel.getSubcategoriesForCategory(_selectedCategory!.id)
        : const <SubcategoryModel>[];
    final drawerWidth = MediaQuery.of(context).size.width * 0.78;

    return Drawer(
      width: drawerWidth,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: Column(
        children: [
          // Drawer Header
          Container(
            color: AppColors.primary,
            child: SafeArea(
              bottom: false,
              child: Container(
                height: 52,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    if (_selectedCategory != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategory = null;
                          });
                        },
                        behavior: HitTestBehavior.opaque,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(
                            LucideIcons.chevronLeft,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    Expanded(
                      child: Text(
                        _selectedCategory != null ? _selectedCategory!.title : 'Danh mục',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(LucideIcons.x, color: Colors.white, size: 20),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Drawer Body
          Expanded(
            child: Container(
              color: Colors.white,
              child: _selectedCategory == null
                  ? ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: categories.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFF1F5F9),
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final item = categories[index];
                        return InkWell(
                          onTap: () {
                            setState(() {
                              _selectedCategory = item;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            child: Row(
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  LucideIcons.chevronRight,
                                  size: 16,
                                  color: Color(0xFF94A3B8),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : ListView.separated(
                      padding: EdgeInsets.zero,
                      itemCount: subcategories.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 0.5,
                        color: Color(0xFFF1F5F9),
                        indent: 16,
                        endIndent: 16,
                      ),
                      itemBuilder: (context, index) {
                        final item = subcategories[index];
                        return InkWell(
                          onTap: () {
                            if (item.targetCategoryId != null) {
                              final targetCat = categories.firstWhere(
                                (c) => c.id == item.targetCategoryId,
                                orElse: () => categories.first,
                              );
                              setState(() {
                                _selectedCategory = targetCat;
                              });
                            } else {
                              Navigator.of(context).pop();
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
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            child: Row(
                              children: [
                                Text(
                                  item.emoji,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.title,
                                    style: const TextStyle(
                                      fontSize: 13.5,
                                      color: Color(0xFF1E293B),
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                if (item.hasChevron)
                                  const Icon(
                                    LucideIcons.chevronRight,
                                    size: 16,
                                    color: Color(0xFF94A3B8),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
