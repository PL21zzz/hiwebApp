import 'package:flutter/material.dart';
import 'product_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';

import 'product_detail_mock_data.dart';

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
        'assets/images/flash-sale1.webp',
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

  static ProductDetailModel get mockSample => ProductDetailMockData.mockSample;
}
