class VoucherItemModel {
  final String id;
  final String shopName;
  final String discountTitle;
  final String? minSpend;
  final String expiryDate;
  final String category;
  bool isSaved;

  VoucherItemModel({
    required this.id,
    required this.shopName,
    required this.discountTitle,
    this.minSpend,
    required this.expiryDate,
    required this.category,
    this.isSaved = false,
  });

  static final List<VoucherItemModel> mockVouchers = [
    VoucherItemModel(
      id: 'v1',
      shopName: 'nhathuocsuckhoe2',
      discountTitle: 'Giảm 530.000đ',
      expiryDate: '14.09.2026',
      category: 'shop',
    ),
    VoucherItemModel(
      id: 'v2',
      shopName: 'nhathuocsuckhoe2',
      discountTitle: 'Giảm 480.000đ',
      expiryDate: '14.09.2026',
      category: 'shop',
    ),
    VoucherItemModel(
      id: 'v3',
      shopName: 'nhathuocsuckhoe2',
      discountTitle: 'Giảm 400.000đ',
      expiryDate: '14.09.2026',
      category: 'shop',
    ),
    VoucherItemModel(
      id: 'v4',
      shopName: 'Mizuno Việt Nam',
      discountTitle: 'Giảm 200.000đ',
      minSpend: 'Đơn tối thiểu 1.500.000đ',
      expiryDate: '30.09.2026',
      category: 'shop',
    ),
    VoucherItemModel(
      id: 'v5',
      shopName: 'Mật Ong CvdBeehoney',
      discountTitle: 'Giảm 50.000đ',
      minSpend: 'Đơn tối thiểu 300.000đ',
      expiryDate: '15.10.2026',
      category: 'shop',
    ),
    VoucherItemModel(
      id: 'v6',
      shopName: 'VietMade Official',
      discountTitle: 'Giảm 10% Tối đa 100k',
      minSpend: 'Cho đơn từ 500k',
      expiryDate: '31.12.2026',
      category: 'vietmade',
    ),
  ];
}
