import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'product_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';

class ProductMediaModel {
  final String type; // 'video' | 'image'
  final String url;
  final String thumb;
  final String title;

  const ProductMediaModel({
    required this.type,
    required this.url,
    required this.thumb,
    required this.title,
  });

  bool get isVideo => type == 'video';
  bool get isImage => type == 'image';

  Map<String, String> toMap() => {
    'type': type,
    'url': url,
    'thumb': thumb,
    'title': title,
  };
}

class TickerItemModel {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final String text;

  const TickerItemModel({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    required this.text,
  });
}

class ProductReviewModel {
  final String userName;
  final String userAvatar;
  final int rating;
  final String date;
  final String variant;
  final String comment;
  final List<String> photos;
  final List<ProductReviewMediaModel> media;
  final int helpfulCount;
  final bool isVerifiedPurchase;
  final String? shopResponse;

  const ProductReviewModel({
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.date,
    required this.variant,
    required this.comment,
    this.photos = const [],
    this.media = const [],
    this.helpfulCount = 0,
    this.isVerifiedPurchase = true,
    this.shopResponse,
  });
}

class ProductReviewMediaModel {
  final String url;
  final bool isVideo;
  final String? videoUrl;

  const ProductReviewMediaModel({
    required this.url,
    this.isVideo = false,
    this.videoUrl,
  });
}

class ShopProfileModel {
  final String name;
  final String avatarUrl;
  final String lastActive;
  final double rating;
  final String responseRate;
  final int followerCount;
  final String totalSold;
  final String joinedDuration;
  final bool isFavorite;
  final String coverUrl;
  final int videoCount;
  final int productCount;
  final String welcomeMessage;

  static const List<String> mockRankBadges = ['Top Shop', 'Chính Hãng', 'Uy Tín'];
  static const List<String> mockCategoryNames = ['Tất cả sản phẩm', 'Dưỡng da', 'Trang điểm', 'Chăm sóc tóc'];

  const ShopProfileModel({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
    required this.rating,
    required this.responseRate,
    this.followerCount = 12500,
    this.totalSold = '15.8k+',
    this.joinedDuration = '3 năm',
    this.isFavorite = true,
    this.coverUrl =
        'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
    this.videoCount = 24,
    this.productCount = 158,
    this.welcomeMessage =
        'Chào mừng bạn đến với shop chính hãng! Chuyên cung cấp sản phẩm cao cấp 100%.',
  });
}

class ProductDetailModel {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final int reviewCount;
  final String soldCount;
  final bool isFavorite;
  final String bestSellerBadge;
  final List<String> capacityOptions;
  final String variantLabel;
  final List<String> vouchers;
  final List<ProductMediaModel> mediaList;
  final List<TickerItemModel> tickerItems;
  final Map<String, String> specifications;
  final String shortDescription;
  final String fullDescription;
  final List<ProductReviewModel> reviews;
  final ShopProfileModel shopProfile;
  final List<ProductModel> otherShopProducts;

  const ProductDetailModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    this.isFavorite = true,
    required this.bestSellerBadge,
    required this.capacityOptions,
    this.variantLabel = 'Dung tích',
    required this.vouchers,
    required this.mediaList,
    required this.tickerItems,
    required this.specifications,
    required this.shortDescription,
    required this.fullDescription,
    required this.reviews,
    required this.shopProfile,
    this.otherShopProducts = const [],
  });

  String get effectiveVariantLabel {
    if (variantLabel.trim().isNotEmpty) return variantLabel;
    return name.contains(RegExp(r'\d\s?(g|kg|ml|l|viên)', caseSensitive: false))
        ? 'Dung tích'
        : 'Size';
  }

  List<String> get effectiveVariantOptions {
    if (capacityOptions.isNotEmpty) return capacityOptions;
    return effectiveVariantLabel == 'Dung tích'
        ? const ['100ml', '50ml', '30ml']
        : const ['S', 'M', 'L'];
  }

  factory ProductDetailModel.fromProduct(ProductModel product) {
    final mock = ProductDetailModel.mockSample;
    final inferredLabel =
        product.variantLabel.isNotEmpty
            ? product.variantLabel
            : (product.name.contains(
                  RegExp(r'\d\s?(g|kg|ml|l|viên)', caseSensitive: false),
                )
                ? 'Dung tích'
                : 'Size');
    return ProductDetailModel(
      id: product.id,
      name: product.name,
      price: product.price,
      originalPrice: product.originalPrice,
      discountPercent: product.discountPercent,
      rating: product.rating,
      reviewCount: mock.reviewCount,
      soldCount: product.soldCount,
      isFavorite: product.isFavorite,
      bestSellerBadge: mock.bestSellerBadge,
      capacityOptions:
          product.variantOptions.isNotEmpty
              ? product.variantOptions
              : (inferredLabel == 'Dung tích'
                  ? const ['100ml', '50ml', '30ml']
                  : const ['S', 'M', 'L']),
      variantLabel: inferredLabel,
      vouchers: mock.vouchers,
      mediaList: [
        ProductMediaModel(
          type: 'video',
          url: 'assets/videos/videodetail.mp4',
          thumb: product.imageUrl.isNotEmpty ? product.imageUrl : mock.mediaList[0].thumb,
          title: 'Video sản phẩm 1',
        ),
        ProductMediaModel(
          type: 'video',
          url: 'assets/videos/videodetail.mp4',
          thumb: mock.mediaList[1].thumb,
          title: 'Video hướng dẫn 2',
        ),
        ProductMediaModel(
          type: 'video',
          url: 'assets/videos/videodetail.mp4',
          thumb: mock.mediaList[2].thumb,
          title: 'Video thực tế 3',
        ),
        ProductMediaModel(
          type: 'image',
          url: product.imageUrl.isNotEmpty ? product.imageUrl : mock.mediaList[3].url,
          thumb: product.imageUrl.isNotEmpty ? product.imageUrl : mock.mediaList[3].thumb,
          title: 'Ảnh 1',
        ),
        ProductMediaModel(
          type: 'image',
          url: mock.mediaList[4].url,
          thumb: mock.mediaList[4].thumb,
          title: 'Ảnh 2',
        ),
        ProductMediaModel(
          type: 'image',
          url: mock.mediaList[5].url,
          thumb: mock.mediaList[5].thumb,
          title: 'Ảnh 3',
        ),
      ],
      tickerItems: mock.tickerItems,
      specifications: mock.specifications,
      shortDescription: mock.shortDescription,
      fullDescription: mock.fullDescription,
      reviews: mock.reviews,
      shopProfile: mock.shopProfile,
      otherShopProducts: mock.otherShopProducts,
    );
  }

  factory ProductDetailModel.fromCartItem(CartItemModel item) {
    final mock = ProductDetailModel.mockSample;
    return ProductDetailModel(
      id: item.id,
      name: item.name,
      price: item.price.toDouble(),
      originalPrice: item.originalPrice.toDouble(),
      discountPercent:
          item.originalPrice > 0
              ? ((item.originalPrice - item.price) * 100 / item.originalPrice)
                  .round()
              : 0,
      rating: mock.rating,
      reviewCount: mock.reviewCount,
      soldCount: mock.soldCount,
      bestSellerBadge: mock.bestSellerBadge,
      capacityOptions: const [],
      vouchers: mock.vouchers,
      mediaList: [
        ProductMediaModel(
          type: 'image',
          url: item.imageUrl,
          thumb: item.imageUrl,
          title: item.name,
        ),
      ],
      tickerItems: mock.tickerItems,
      specifications: mock.specifications,
      shortDescription: mock.shortDescription,
      fullDescription: mock.fullDescription,
      reviews: mock.reviews,
      shopProfile: ShopProfileModel(
        name: item.shopName,
        avatarUrl: mock.shopProfile.avatarUrl,
        lastActive: mock.shopProfile.lastActive,
        rating: mock.shopProfile.rating,
        responseRate: mock.shopProfile.responseRate,
      ),
      otherShopProducts: mock.otherShopProducts,
    );
  }

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
        thumb:
            'https://images.unsplash.com/photo-1556228720-195a672e8a03?w=500',
        title: 'Video sản phẩm 1',
      ),
      ProductMediaModel(
        type: 'video',
        url: 'assets/videos/videodetail.mp4',
        thumb:
            'https://images.unsplash.com/photo-1608248597261-833258657640?w=500',
        title: 'Video hướng dẫn 2',
      ),
      ProductMediaModel(
        type: 'video',
        url: 'assets/videos/videodetail.mp4',
        thumb:
            'https://images.unsplash.com/photo-1522337360788-8b13dee7a37e?w=500',
        title: 'Video thực tế 3',
      ),
      ProductMediaModel(
        type: 'image',
        url:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
        title: 'Ảnh 1',
      ),
      ProductMediaModel(
        type: 'image',
        url:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        title: 'Ảnh 2',
      ),
      ProductMediaModel(
        type: 'image',
        url:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
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
        userAvatar:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
        rating: 5,
        date: '20/08/2026',
        variant: '453g',
        comment:
          'Sản phẩm dùng rất thích, dưỡng ẩm cực tốt cho mùa đông. Giao hàng siêu nhanh!',
        photos: [
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        ],
        media: [
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
          ),
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
          ),
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
            isVideo: true,
            videoUrl:
                'assets/videos/videodetail.mp4',
          ),
        ],
        helpfulCount: 12,
        shopResponse:
          'Cảm ơn bạn đã tin tưởng mua sắm tại Pharmacy! Chúc bạn luôn có làn da khỏe đẹp.',
      ),
      ProductReviewModel(
        userName: 'Trần Thị B',
        userAvatar:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        rating: 4,
        date: '15/08/2026',
        variant: '250g',
        comment: 'Kem thấm nhanh, không bết dính. Đóng gói cẩn thận.',
        photos: [
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        ],
        media: [
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
          ),
        ],
        helpfulCount: 5,
      ),
    ],
    shopProfile: ShopProfileModel(
      name: 'Phương Thảo Pharmacy',
      avatarUrl:
          'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
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
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
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
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
        category: 'Dưỡng da',
      ),
    ],
  );
}
