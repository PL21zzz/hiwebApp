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
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide1_dhs27i.webp',
    ),
    BannerModel(
      id: 'b2',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide2_cjt32o.webp',
    ),
    BannerModel(
      id: 'b3',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide3_navayf.webp',
    ),
  ];
}
