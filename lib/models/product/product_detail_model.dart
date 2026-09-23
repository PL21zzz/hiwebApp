import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'product_model.dart';
import '../user/cart/cart_item_model.dart';

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

  const ShopProfileModel({
    required this.name,
    required this.avatarUrl,
    required this.lastActive,
    required this.rating,
    required this.responseRate,
    this.followerCount = 50,
    this.totalSold = '2.3K',
    this.joinedDuration = '1 năm trước',
    this.isFavorite = true,
    this.coverUrl = 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
    this.videoCount = 1,
    this.productCount = 18,
    this.welcomeMessage = 'Chào bạn, shop có thể giúp gì cho bạn?',
  });

  static const List<String> mockRankBadges = [
    '#1 Bán chạy',
    '#2 Bán chạy',
    '#3 Bán chạy',
    '#4 Bán chạy',
    '#5 Bán chạy',
    '#6 Bán chạy',
  ];

  static const List<String> mockCategoryNames = [
    'Handmade',
    'Quà tặng',
    'Trang trí',
    'Chăm sóc cá nhân',
    'Dưỡng da & Chăm sóc da',
    'Y tế & Thực phẩm chức năng',
  ];
}

class ProductSpecificationModel {
  final String title;
  final String value;

  const ProductSpecificationModel({
    required this.title,
    required this.value,
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
  final List<ProductSpecificationModel> specifications;
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
    this.isFavorite = false,
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

  factory ProductDetailModel.fromProduct(ProductModel product) {
    final mock = ProductDetailModel.mockSample;
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
      capacityOptions: product.variantOptions,
      variantLabel: product.variantLabel.isNotEmpty
          ? product.variantLabel
          : mock.variantLabel,
      vouchers: mock.vouchers,
      mediaList: mock.mediaList,
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
      discountPercent: item.originalPrice > 0
          ? ((item.originalPrice - item.price) * 100 / item.originalPrice).round()
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
        url:
            'assets/videos/videodetail.mp4',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638143/videodetail1_tkmffs.jpg',
        title: 'Video sản phẩm 1',
      ),
      ProductMediaModel(
        type: 'video',
        url:
            'assets/videos/videodetail.mp4',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638136/videodetail2_zfkwdq.jpg',
        title: 'Video hướng dẫn 2',
      ),
      ProductMediaModel(
        type: 'video',
        url:
            'assets/videos/videodetail.mp4',
        thumb:
            'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638201/videodetail3_z6o8sg.jpg',
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
        icon: LucideIcons.checkCircle2,
        iconColor: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
        text: 'Đánh giá 4.9/5 từ 128 đánh giá',
      ),
      TickerItemModel(
        icon: LucideIcons.truck,
        iconColor: Color(0xFF9333EA),
        bgColor: Color(0xFFFAF5FF),
        text: 'Miễn phí giao hàng toàn quốc',
      ),
      TickerItemModel(
        icon: LucideIcons.eye,
        iconColor: Color(0xFF0891B2),
        bgColor: Color(0xFFECFEFF),
        text: '6 người đang xem',
      ),
      TickerItemModel(
        icon: LucideIcons.hourglass,
        iconColor: Color(0xFFCA8A04),
        bgColor: Color(0xFFFEFCE8),
        text: 'Số lượng có hạn',
      ),
    ],
    specifications: [
      ProductSpecificationModel(
        title: 'Thương hiệu:',
        value: 'không thương hiệu',
      ),
      ProductSpecificationModel(
        title: 'Số lượng sản phẩm còn:',
        value: '157',
      ),
      ProductSpecificationModel(
        title: 'Xuất xứ:',
        value: 'Ấn Độ',
      ),
      ProductSpecificationModel(
        title: 'Kho hàng tại:',
        value: 'Nghệ An',
      ),
    ],
    shortDescription:
        'Ezamic Gel Azelaic Acid 20% giúp dưỡng ẩm cho da, hỗ trợ điều trị mụn, mờ thâm, làm mờ sưng viêm, sạch da, ngừa mụn.\n\n'
        'Hoạt chất: Azelaic Acid 20%\n\n'
        'Hỗ trợ:\n'
        '- Giúp dưỡng ẩm cho da, mờ thâm mụn rất nhanh nếu\n'
        '- Mờ thâm đen và thâm đỏ sau mụn.\n'
        '- Giảm mụn vừa và nhẹ.',
    fullDescription:
        'Ezamic Gel Azelaic Acid 20% giúp dưỡng ẩm cho da, hỗ trợ điều trị mụn, mờ thâm, làm mờ sưng viêm, sạch da, ngừa mụn.\n\n'
        'Hoạt chất: Azelaic Acid 20%\n\n'
        'Hỗ trợ:\n'
        '- Giúp dưỡng ẩm cho da, mờ thâm mụn rất nhanh nếu\n'
        '- Mờ thâm đen và thâm đỏ sau mụn.\n'
        '- Giảm mụn vừa và nhẹ.\n\n'
        'HƯỚNG DẪN SỬ DỤNG:\n'
        'Thoa đều gel dưỡng ẩm lên vùng da khô cần chăm sóc hàng ngày sau khi làm sạch da. Sử dụng 1-2 lần/ngày vào buổi sáng và tối.',
    reviews: [
      ProductReviewModel(
        userName: 'Mình*** Anh',
        userAvatar: '',
        rating: 5,
        date: 'Hữu ích (12)',
        variant: 'Phân loại: 453g',
        comment:
            'Kem dưỡng ẩm tốt, chất kem mịn và thấm khá nhanh. Đóng gói cẩn thận, hàng nhận được giống hình.',
        media: [
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/video/upload/so_0/v1789638143/videodetail1_tkmffs.jpg',
            isVideo: true,
            videoUrl: 'assets/videos/videodetail.mp4',
          ),
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
          ),
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
          ),
        ],
        helpfulCount: 12,
      ),
      ProductReviewModel(
        userName: 'Ngọc*** Hà',
        userAvatar: '',
        rating: 5,
        date: 'Hữu ích (8)',
        variant: 'Phân loại: 453g',
        comment:
            'Giao nhanh hơn dự kiến. Mình dùng buổi tối thấy da mềm hơn, không bị cảm giác quá bí.',
        media: [
          ProductReviewMediaModel(
            url:
                'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
          ),
        ],
        helpfulCount: 8,
      ),
      ProductReviewModel(
        userName: 'Thu*** Trang',
        userAvatar: '',
        rating: 4,
        date: 'Hữu ích (5)',
        variant: 'Phân loại: 250g',
        comment:
            'Sản phẩm ổn, bao bì chắc chắn. Mùi nhẹ, mình thích. Trừ một sao vì hộp bên ngoài hơi móp khi nhận.',
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
          ),
        ],
        helpfulCount: 5,
      ),
      ProductReviewModel(
        userName: 'Phương*** Linh',
        userAvatar: '',
        rating: 5,
        date: 'Hữu ích (3)',
        variant: 'Phân loại: 100g',
        comment: 'Sản phẩm chính hãng, giao hàng nhanh, sẽ mua lại lần sau.',
        helpfulCount: 3,
      ),
      ProductReviewModel(
        userName: 'Huy*** Khoa',
        userAvatar: '',
        rating: 4,
        date: 'Hữu ích (2)',
        variant: 'Phân loại: 250g',
        comment: 'Đóng gói kỹ, chất lượng ổn trong tầm giá.',
        helpfulCount: 2,
      ),
      ProductReviewModel(
        userName: 'Mai*** Chi',
        userAvatar: '',
        rating: 3,
        date: 'Hữu ích (1)',
        variant: 'Phân loại: 100g',
        comment: 'Giao hơi lâu nhưng sản phẩm không bị hư hỏng.',
        helpfulCount: 1,
      ),
      ProductReviewModel(
        userName: 'Lan*** Anh',
        userAvatar: '',
        rating: 5,
        date: 'Hữu ích (4)',
        variant: 'Phân loại: 453g',
        comment: 'Kem dễ dùng, da mềm hơn sau vài ngày.',
        helpfulCount: 4,
      ),
    ],
    shopProfile: ShopProfileModel(
      name: 'Phương Thảo Pharmacy',
      avatarUrl:
          'https://images.unsplash.com/photo-1584308666744-24d5c474f2ae?auto=format&fit=crop&w=200&q=80',
      lastActive: '5 phút trước',
      rating: 4.9,
      responseRate: '98%',
    ),
    otherShopProducts: [
      ProductModel(
        id: 'osp1',
        name: 'Acnedap Gel 15g Ngăn Ngừa Mụn Thâm Nhọt',
        price: 235000,
        originalPrice: 345000,
        discountPercent: 32,
        rating: 5,
        soldCount: '3.6k+',
        location: 'Nghệ An',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
      ProductModel(
        id: 'osp2',
        name: 'Kem Dưỡng Ẩm Zebor Gel Azelaic Acid 20%',
        price: 165000,
        originalPrice: 235000,
        discountPercent: 32,
        rating: 5,
        soldCount: '3k+',
        location: 'Nghệ An',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
      ProductModel(
        id: 'osp3',
        name: 'Acnedap Gel 15g Ngăn Ngừa Mụn Thâm Nhọt',
        price: 235000,
        originalPrice: 345000,
        discountPercent: 32,
        rating: 5,
        soldCount: '3.6k+',
        location: 'Nghệ An',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
      ProductModel(
        id: 'osp4',
        name: 'Serum Giảm Thâm Acne-Derm Azelaic Acid 20%',
        price: 185000,
        originalPrice: 260000,
        discountPercent: 29,
        rating: 4.9,
        soldCount: '2.1k+',
        location: 'Hà Nội',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
      ProductModel(
        id: 'osp5',
        name: 'Kem Dưỡng Phục Hồi Da Skinavis Moisturizer 50ml',
        price: 420000,
        originalPrice: 550000,
        discountPercent: 24,
        rating: 5,
        soldCount: '1.8k+',
        location: 'Nghệ An',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
      ProductModel(
        id: 'osp6',
        name: 'Gel Dưỡng Ngừa Mụn Megaduo Gel 15g',
        price: 115000,
        originalPrice: 160000,
        discountPercent: 28,
        rating: 4.8,
        soldCount: '5.2k+',
        location: 'Nghệ An',
        imageUrl:
            'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
        category: 'Dưỡng da',
        isFavorite: true,
      ),
    ],
  );
}
