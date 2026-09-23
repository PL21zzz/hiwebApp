class VideoProductSheetItemModel {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final int discountPercent;
  final int price;
  final int originalPrice;
  final String badgeText;

  const VideoProductSheetItemModel({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.discountPercent,
    required this.price,
    required this.originalPrice,
    required this.badgeText,
  });

  String get formattedPrice => '${_format(price)}đ';
  String get formattedOriginalPrice => '${_format(originalPrice)}đ';

  static String _format(int value) {
    final text = value.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && (text.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(text[i]);
    }
    return buffer.toString();
  }
}

class VideoProductSheetData {
  static const List<VideoProductSheetItemModel> mockItems = [
    VideoProductSheetItemModel(
      id: 'vp_01',
      imageUrl: 'assets/images/prd1.webp',
      title: 'Đồ dùng tiện ích mini',
      subtitle: 'Mẫu 01',
      discountPercent: 25,
      price: 15000,
      originalPrice: 20000,
      badgeText: 'Giảm 25%',
    ),
    VideoProductSheetItemModel(
      id: 'vp_02',
      imageUrl: 'assets/images/prd1.webp',
      title: 'Khả năng chống lão hóa',
      subtitle: 'Mẫu 02',
      discountPercent: 25,
      price: 20000,
      originalPrice: 25000,
      badgeText: 'Giảm 25%',
    ),
    VideoProductSheetItemModel(
      id: 'vp_03',
      imageUrl: 'assets/images/prd1.webp',
      title: 'Nước hoa mini hương tự nhiên',
      subtitle: 'Mẫu 03',
      discountPercent: 25,
      price: 25000,
      originalPrice: 30000,
      badgeText: 'Giảm 25%',
    ),
    VideoProductSheetItemModel(
      id: 'vp_04',
      imageUrl: 'assets/images/prd1.webp',
      title: 'Đồ trang trí phòng tắm',
      subtitle: 'Mẫu 04',
      discountPercent: 25,
      price: 35000,
      originalPrice: 45000,
      badgeText: 'Giảm 25%',
    ),
    VideoProductSheetItemModel(
      id: 'vp_05',
      imageUrl: 'assets/images/prd1.webp',
      title: 'Chậu cây mini decor',
      subtitle: 'Mẫu 05',
      discountPercent: 25,
      price: 39000,
      originalPrice: 50000,
      badgeText: 'Giảm 25%',
    ),
  ];
}
