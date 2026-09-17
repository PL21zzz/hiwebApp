import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/vietmade_header.dart';
import '../widgets/banner_slider.dart';
import '../widgets/category_grid.dart';
import '../widgets/flash_sale_section.dart';
import '../widgets/top_searches_section.dart';
import '../widgets/product_grid.dart';
import '../widgets/vietmade_footer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VietmadeHeader(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Vùng nền Gradient Cyan cuộn theo trang (bọc Banner & CategoryGrid, nhạt dần và MẤT HẮN tại Flash Sale)
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF00A8E8), // Cyan đậm dưới Header
                    Color(0xFF80D8FF), // Cyan nhạt qua Banner
                    Color(0xFFE0F7FA), // Cyan phớt qua Category
                    AppColors.background, // Mất hẳn khi đến Flash Sale (#F5F7FA)
                  ],
                  stops: [0.0, 0.45, 0.85, 1.0],
                ),
              ),
              child: const Column(
                children: [
                  BannerSlider(),
                  CategoryGrid(),
                ],
              ),
            ),

            // 2. Khối Flash Sale + VietMade VIDEO (nằm ngoài vùng gradient, trên nền #F5F7FA)
            const FlashSaleSection(),

            // 3. Danh sách Sản phẩm 1 (Chỉ 4 sản phẩm, nền #BCEDF4 trồi 6px, card 12px)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.productBoxBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const ProductGrid(itemCount: 4),
            ),

            // 4. Khối TÌM KIẾM HÀNG ĐẦU (Nằm ngay DƯỚI Danh sách sản phẩm 1)
            const TopSearchesSection(),

            // 5. Thanh Tiêu Đề "Gợi ý dành cho bạn" & "Xem tất cả" (Nền trắng tràn viền)
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
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
                          color: Color(0xFF00A8E8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 6. Vị trí thứ 6: Danh sách sản phẩm 2 ("Gợi ý dành cho bạn" - 6 sản phẩm, nền xanh nhạt tràn viền)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(6),
              color: AppColors.productBoxBg, // Nền #BCEDF4 tràn viền ngang không margin
              child: const ProductGrid(itemCount: 6),
            ),

            // 7. Khoảng đệm (spacer) rộng ~120px để lộ nền xám nhạt trước khi xuống Footer
            const SizedBox(height: 120),

            // 8. Chân trang (Footer) đen sẫm
            const VietmadeFooter(),
          ],
        ),
      ),
    );
  }
}
