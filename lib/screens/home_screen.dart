import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/common/layout/vietmade_header.dart';
import '../widgets/common/layout/vietmade_footer.dart';
import '../widgets/common/layout/category_drawer.dart';
import '../widgets/common/product/product_grid.dart';
import '../widgets/home/banner_slider.dart';
import '../widgets/home/category_grid.dart';
import '../widgets/home/flash_sale_section.dart';
import '../widgets/home/top_searches_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VietmadeHeader(),
      drawer: const CategoryDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: AppColors.topSectionGradient,
              ),
              child: const Column(
                children: [
                  BannerSlider(),
                  CategoryGrid(),
                ],
              ),
            ),
            const FlashSaleSection(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.all(6),
              color: AppColors.productBoxBg,
              child: const ProductGrid(itemCount: 4),
            ),
            const TopSearchesSection(),
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Gợi ý dành cho bạn',
                    style: TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F1F1F),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    borderRadius: BorderRadius.circular(4),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      child: Text(
                        'Xem tất cả',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              color: AppColors.productBoxBg,
              child: const ProductGrid(itemCount: 6),
            ),
            const SizedBox(height: 120),
            const VietmadeFooter(),
          ],
        ),
      ),
    );
  }
}
