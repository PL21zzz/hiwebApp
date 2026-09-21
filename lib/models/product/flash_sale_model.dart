class FlashSaleSlotInfo {
  final String label;
  final int startHour;
  final int endHour;

  const FlashSaleSlotInfo({
    required this.label,
    required this.startHour,
    required this.endHour,
  });
}

class FlashSaleModel {
  static const List<FlashSaleSlotInfo> mockDailySlots = [
    FlashSaleSlotInfo(label: '09:00', startHour: 9, endHour: 12),
    FlashSaleSlotInfo(label: '12:00', startHour: 12, endHour: 15),
    FlashSaleSlotInfo(label: '15:00', startHour: 15, endHour: 19),
    FlashSaleSlotInfo(label: '19:00', startHour: 19, endHour: 24),
  ];

  static const List<String> mockCategories = [
    'Top sản phẩm nổi bật',
    'Deal giá sốc',
    'Sản phẩm siêu rẻ',
    'Thực phẩm chức năng',
    'Mỹ phẩm',
    'Mẹ và bé',
  ];
}
