class ProductModel {
  final String id;
  final String name;
  final double price;
  final double originalPrice;
  final int discountPercent;
  final double rating;
  final String soldCount;
  final String location;
  final String imageUrl;
  final String category;
  final String shopName;
  final String variantLabel;
  final List<String> variantOptions;
  final bool isFlashSale;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.discountPercent,
    required this.rating,
    required this.soldCount,
    required this.location,
    required this.imageUrl,
    required this.category,
    this.shopName = 'VietMade Store',
    this.variantLabel = '',
    this.variantOptions = const [],
    this.isFlashSale = false,
    this.isFavorite = false,
  });

  static const List<ProductModel> mockProducts = [
    ProductModel(
      id: 'p1',
      name: 'Kem dưỡng ẩm Cetaphil Moisturizing Cream 453g',
      price: 450000,
      originalPrice: 520000,
      discountPercent: 13,
      rating: 4.8,
      soldCount: '3k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale1.webp',
      category: 'Dưỡng da',
      variantLabel: 'Dung tích',
      variantOptions: ['453g', '250g', '100g'],
    ),
    ProductModel(
      id: 'p2',
      name: 'Omega 3-6-9 Healthy Care 200 viên',
      price: 420000,
      originalPrice: 480000,
      discountPercent: 12,
      rating: 4.7,
      soldCount: '2k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale2.webp',
      category: 'Y tế',
      variantLabel: 'Size',
      variantOptions: ['S', 'M', 'L'],
    ),
    ProductModel(
      id: 'p3',
      name: 'Viên uống Kirkland Vitamin D3 1000IU 600 viên',
      price: 590000,
      originalPrice: 650000,
      discountPercent: 9,
      rating: 4.8,
      soldCount: '4k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/prd1.webp',
      category: 'Y tế',
    ),
    ProductModel(
      id: 'p4',
      name: 'Serum Vitamin C Obagi Professional-C Serum 20% 30ml',
      price: 1850000,
      originalPrice: 2100000,
      discountPercent: 11,
      rating: 4.9,
      soldCount: '1k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale1.webp',
      category: 'Dưỡng da',
    ),
    ProductModel(
      id: 'p5',
      name: 'Kem chống nắng Anessa Perfect UV Sunscreen Skincare Milk 60ml',
      price: 520000,
      originalPrice: 580000,
      discountPercent: 10,
      rating: 4.8,
      soldCount: '2k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale2.webp',
      category: 'Dưỡng da',
    ),
    ProductModel(
      id: 'p6',
      name: 'Viên uống tăng cường sinh lý Ostelin Vitamin D & Calcium 250 viên',
      price: 680000,
      originalPrice: 750000,
      discountPercent: 9,
      rating: 4.7,
      soldCount: '2k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/prd1.webp',
      category: 'Y tế',
    ),
  ];

  static const List<ProductModel> mockCartProducts = [
    ProductModel(
      id: 'cart_french_perfume',
      name: 'Nước hoa French Perfume Oriental 100ml - Hương thơm phương Đông...',
      price: 350000,
      originalPrice: 450000,
      discountPercent: 22,
      rating: 4.8,
      soldCount: '1k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale1.webp',
      category: 'Nước hoa',
      shopName: 'ShopMyPham',
      variantLabel: 'Phân loại',
      variantOptions: ['French Perfume'],
    ),
    ProductModel(
      id: 'cart_collagen_cream',
      name: 'Kem dưỡng da collagen Hàn Quốc - Dưỡng ẩm & chống lão hóa',
      price: 280000,
      originalPrice: 520000,
      discountPercent: 46,
      rating: 4.7,
      soldCount: '2k+',
      location: 'Hồ Chí Minh',
      imageUrl: 'assets/images/flash-sale2.webp',
      category: 'Dưỡng da',
      shopName: 'ShopMyPham',
      variantLabel: 'Phân loại',
      variantOptions: ['Mặc định'],
    ),
  ];
}
