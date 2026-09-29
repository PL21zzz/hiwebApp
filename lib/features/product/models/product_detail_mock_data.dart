import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'product_detail_model.dart';
import 'product_model.dart';

class ProductDetailMockData {
  // Mock data instance matching Cetaphil Product Detail
  static const ProductDetailModel mockSample = ProductDetailModel(
    id: 'p1',
    name: 'Kem dưỡng ẩm Cetaphil Moisturizing Cream 453g',
    price: 450000,
    originalPrice: 520000,
    discountPercent: 13,
    rating: 4.1,
    reviewCount: 16,
    soldCount: '2.6k+',
    isFavorite: true,
    bestSellerBadge: '#1 bán chạy của Phương Thảo Pharmacy',
    capacityOptions: ['453g', '250g', '100g'],
    variantLabel: 'Dung tích',
    vouchers: ['10%', '10%', '10%'],
    mediaList: [
      ProductMediaModel(
        type: 'video',
        url: 'assets/videos/videodetail.mp4',
        thumb: 'assets/images/flash-sale1.webp',
        title: 'Video sản phẩm 1',
      ),
      ProductMediaModel(
        type: 'video',
        url: 'assets/videos/videodetail.mp4',
        thumb: 'assets/images/flash-sale2.webp',
        title: 'Video hướng dẫn 2',
      ),
      ProductMediaModel(
        type: 'video',
        url: 'assets/videos/videodetail.mp4',
        thumb: 'assets/images/prd1.webp',
        title: 'Video thực tế 3',
      ),
      ProductMediaModel(
        type: 'image',
        url: 'assets/images/flash-sale1.webp',
        thumb: 'assets/images/flash-sale1.webp',
        title: 'Ảnh 1',
      ),
      ProductMediaModel(
        type: 'image',
        url: 'assets/images/flash-sale2.webp',
        thumb: 'assets/images/flash-sale2.webp',
        title: 'Ảnh 2',
      ),
      ProductMediaModel(
        type: 'image',
        url: 'assets/images/prd1.webp',
        thumb: 'assets/images/prd1.webp',
        title: 'Ảnh 3',
      ),
    ],
    tickerItems: [
      TickerItemModel(
        icon: LucideIcons.shieldCheck,
        iconColor: Color(0xFFD97706),
        bgColor: Color(0xFFFFFBEB),
        text: 'Hàng chính hãng 100%',
      ),
      TickerItemModel(
        icon: LucideIcons.clock,
        iconColor: Color(0xFF0284C7),
        bgColor: Color(0xFFF0F9FF),
        text: 'Flash Sale kết thúc trong 2h',
      ),
      TickerItemModel(
        icon: LucideIcons.truck,
        iconColor: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
        text: 'Miễn phí vận chuyển toàn quốc',
      ),
    ],
    specifications: {
      'Thương hiệu': 'Cetaphil',
      'Xuất xứ thương hiệu': 'Canada',
      'Nơi sản xuất': 'Canada',
      'Dạng sản phẩm': 'Kem (Cream)',
      'Dung tích': '453g',
      'Hạn sử dụng': '36 tháng kể từ ngày sản xuất',
    },
    shortDescription:
        'Kem dưỡng ẩm Cetaphil Moisturizing Cream giúp cấp ẩm tức thì và duy trì độ ẩm suốt 48 giờ cho làn da khô đến rất khô, da nhạy cảm.',
    fullDescription:
        'Công thức được bác sĩ da liễu thử nghiệm lâm sàng chứa thành phần Niacinamide (Vitamin B3), Panthenol (Pro-Vitamin B5) và Glycerin dưỡng ẩm giúp tăng cường hàng rào bảo vệ da nhạy cảm.\n\nĐặc điểm nổi bật:\n- Phục hồi hàng rào bảo vệ da hoàn toàn chỉ trong 1 tuần.\n- Không chứa hương liệu, không paraben, không làm bít tắc lỗ chân lông.\n- Phù hợp cho cả da mặt và toàn thân.',
    reviews: [
      ProductReviewModel(
        userName: 'Nguyễn Văn A',
        userAvatar: 'assets/images/flash-sale1.webp',
        rating: 5,
        date: '20/08/2026',
        variant: '453g',
        comment:
            'Sản phẩm dùng rất thích, dưỡng ẩm cực tốt cho mùa đông. Giao hàng siêu nhanh!',
        photos: [
          'assets/images/flash-sale1.webp',
          'assets/images/flash-sale2.webp',
        ],
        media: [
          ProductReviewMediaModel(
            url: 'assets/images/flash-sale1.webp',
          ),
          ProductReviewMediaModel(
            url: 'assets/images/flash-sale2.webp',
          ),
          ProductReviewMediaModel(
            url: 'assets/images/prd1.webp',
            isVideo: true,
            videoUrl: 'assets/videos/videodetail.mp4',
          ),
        ],
        helpfulCount: 12,
        shopResponse:
            'Cảm ơn bạn đã tin tưởng mua sắm tại Pharmacy! Chúc bạn luôn có làn da khỏe đẹp.',
      ),
      ProductReviewModel(
        userName: 'Trần Thị B',
        userAvatar: 'assets/images/flash-sale2.webp',
        rating: 4,
        date: '15/08/2026',
        variant: '250g',
        comment: 'Kem thấm nhanh, không bết dính. Đóng gói cẩn thận.',
        photos: [
          'assets/images/flash-sale2.webp',
        ],
        media: [
          ProductReviewMediaModel(
            url: 'assets/images/flash-sale2.webp',
          ),
        ],
        helpfulCount: 5,
      ),
    ],
    shopProfile: ShopProfileModel(
      name: 'Phương Thảo Pharmacy',
      avatarUrl: 'assets/images/flash-sale1.webp',
      lastActive: 'Online 5 phút trước',
      rating: 4.9,
      responseRate: '99%',
    ),
    otherShopProducts: [
      ProductModel(
        id: 'p2',
        name: 'Sữa rửa mặt Cetaphil Gentle Skin Cleanser 500ml',
        price: 380000,
        originalPrice: 420000,
        discountPercent: 10,
        rating: 4.9,
        soldCount: '1.8k',
        location: 'Hà Nội',
        imageUrl: 'assets/images/flash-sale2.webp',
        category: 'Dưỡng da',
      ),
      ProductModel(
        id: 'p3',
        name: 'Nước hoa hồng Cerave Hydrating Toner 200ml',
        price: 320000,
        originalPrice: 350000,
        discountPercent: 9,
        rating: 4.8,
        soldCount: '950',
        location: 'Hà Nội',
        imageUrl: 'assets/images/prd1.webp',
        category: 'Dưỡng da',
      ),
    ],
  );
}
