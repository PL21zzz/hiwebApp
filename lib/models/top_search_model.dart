class TopSearchModel {
  final String id;
  final String imageUrl;
  final String label;

  const TopSearchModel({
    required this.id,
    required this.imageUrl,
    required this.label,
  });

  static const List<TopSearchModel> mockTopSearches = [
    TopSearchModel(
      id: 'ts1',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789607758/search1_juc8bw.webp',
      label: 'netflix',
    ),
    TopSearchModel(
      id: 'ts2',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789607758/search2_vaai20.webp',
      label: 'netflix',
    ),
    TopSearchModel(
      id: 'ts3',
      imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789607758/search3_gecpey.webp',
      label: 'netflix',
    ),
  ];
}
