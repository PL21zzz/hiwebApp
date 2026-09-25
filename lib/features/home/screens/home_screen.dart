import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_footer.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/category_drawer.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_grid.dart';
import 'package:hiweb_app_management/core/widgets/common/loading/product_card_skeleton.dart';
import 'package:hiweb_app_management/features/home/widgets/banner_slider.dart';
import 'package:hiweb_app_management/features/home/widgets/category_grid.dart';
import 'package:hiweb_app_management/features/home/widgets/flash_sale_section.dart';
import 'package:hiweb_app_management/features/home/widgets/top_searches_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    await Future.delayed(const Duration(milliseconds: 700));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VietmadeHeader(),
      drawer: const CategoryDrawer(),
      body: RefreshIndicator(
        onRefresh: _simulateLoading,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                child: _isLoading
                    ? const ProductGridSkeleton(itemCount: 4)
                    : const ProductGrid(itemCount: 4),
              ),
              const TopSearchesSection(),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
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
                        padding: EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 2,
                        ),
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
                child: _isLoading
                    ? const ProductGridSkeleton(itemCount: 6)
                    : const ProductGrid(itemCount: 6),
              ),
              const SizedBox(height: 120),
              const VietmadeFooter(),
            ],
          ),
        ),
      ),
    );
  }
}
