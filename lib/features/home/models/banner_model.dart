class BannerModel {
  final String id;
  final String imageUrl;

  const BannerModel({
    required this.id,
    required this.imageUrl,
  });

  static const List<BannerModel> mockBanners = [
    BannerModel(
      id: 'b1',
      imageUrl: 'assets/images/slide1.webp',
    ),
    BannerModel(
      id: 'b2',
      imageUrl: 'assets/images/slide2.webp',
    ),
    BannerModel(
      id: 'b3',
      imageUrl: 'assets/images/slide3.webp',
    ),
  ];
}
