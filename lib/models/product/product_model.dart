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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
      category: 'Dưỡng da',
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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
      category: 'Y tế',
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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp',
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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp',
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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/video1_dqeu7c.webp',
      category: 'Y tế',
    ),
  ];
}
