class FilterOptionModel {
  final String id;
  final String label;
  final String count;

  const FilterOptionModel({
    required this.id,
    required this.label,
    required this.count,
  });
}

class FilterModel {
  static const List<FilterOptionModel> mockCategories = [
    FilterOptionModel(id: 'c1', label: 'Thực phẩm chức năng', count: '128'),
    FilterOptionModel(id: 'c2', label: 'Mỹ phẩm & Dưỡng da', count: '94'),
    FilterOptionModel(id: 'c3', label: 'Dược mỹ phẩm', count: '67'),
    FilterOptionModel(id: 'c4', label: 'Mẹ & bé', count: '52'),
    FilterOptionModel(id: 'c5', label: 'Nước hoa & Hóa mỹ phẩm', count: '41'),
    FilterOptionModel(id: 'c6', label: 'Chăm sóc cá nhân', count: '38'),
  ];

  static const List<FilterOptionModel> mockBrands = [
    FilterOptionModel(id: 'b1', label: 'Cetaphil', count: '45'),
    FilterOptionModel(id: 'b2', label: 'Healthy Care', count: '32'),
    FilterOptionModel(id: 'b3', label: 'Kirkland Signature', count: '29'),
    FilterOptionModel(id: 'b4', label: 'Obagi Medical', count: '18'),
    FilterOptionModel(id: 'b5', label: 'Anessa', count: '24'),
    FilterOptionModel(id: 'b6', label: 'Ostelin', count: '15'),
  ];

  static const List<FilterOptionModel> mockOrigins = [
    FilterOptionModel(id: 'o1', label: 'Việt Nam', count: '110'),
    FilterOptionModel(id: 'o2', label: 'Úc (Australia)', count: '65'),
    FilterOptionModel(id: 'o3', label: 'Mỹ (USA)', count: '82'),
    FilterOptionModel(id: 'o4', label: 'Nhật Bản', count: '54'),
    FilterOptionModel(id: 'o5', label: 'Hàn Quốc', count: '48'),
    FilterOptionModel(id: 'o6', label: 'Pháp', count: '36'),
  ];

  static const List<FilterOptionModel> mockLocations = [
    FilterOptionModel(id: 'l1', label: 'TP. Hồ Chí Minh', count: '185'),
    FilterOptionModel(id: 'l2', label: 'Hà Nội', count: '142'),
    FilterOptionModel(id: 'l3', label: 'Phú Thọ', count: '35'),
    FilterOptionModel(id: 'l4', label: 'An Giang', count: '28'),
  ];
}
