class CartItemModel {
  final String id;
  final String shopName;
  final String name;
  final String imageUrl;
  final String brand;
  final String variantInfo;
  final int price;
  final int originalPrice;
  final int quantity;
  final bool isSelected;

  const CartItemModel({
    required this.id,
    required this.shopName,
    required this.name,
    required this.imageUrl,
    this.brand = 'Healthy Care',
    this.variantInfo = 'Đã chọn: Size: M',
    required this.price,
    required this.originalPrice,
    this.quantity = 1,
    this.isSelected = true,
  });

  CartItemModel copyWith({
    String? id,
    String? shopName,
    String? name,
    String? imageUrl,
    String? brand,
    String? variantInfo,
    int? price,
    int? originalPrice,
    int? quantity,
    bool? isSelected,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      shopName: shopName ?? this.shopName,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      brand: brand ?? this.brand,
      variantInfo: variantInfo ?? this.variantInfo,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      quantity: quantity ?? this.quantity,
      isSelected: isSelected ?? this.isSelected,
    );
  }
}

class CartMockData {
  static const List<CartItemModel> sampleItems = [
    CartItemModel(
      id: 'cart_omega3',
      shopName: 'VietMade Store',
      name: 'Omega 3-6-9 Healthy Care 200 viên',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789957346/order_product_mock_qiuzdo.webp',
      brand: 'Healthy Care',
      variantInfo: 'Đã chọn: Size: M',
      price: 420000,
      originalPrice: 480000,
      quantity: 1,
      isSelected: true,
    ),
  ];
}
