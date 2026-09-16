import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/vietmade_header.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_grid.dart';
import '../widgets/flash_sale_section.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.topBackgroundGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const VietmadeHeader(),
        body: const SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Slider 3 ảnh tự cuộn
              BannerSlider(),

              // 2. Lưới 5 icon danh mục
              CategoryGrid(),

              // 3. Khối Flash Sale + VietMade VIDEO
              FlashSaleSection(),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
