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
  });
}
