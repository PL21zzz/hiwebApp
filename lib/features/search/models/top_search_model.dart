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
      imageUrl: 'assets/images/flash-sale1.webp',
      label: 'netflix',
    ),
    TopSearchModel(
      id: 'ts2',
      imageUrl: 'assets/images/flash-sale2.webp',
      label: 'netflix',
    ),
    TopSearchModel(
      id: 'ts3',
      imageUrl: 'assets/images/prd1.webp',
      label: 'netflix',
    ),
  ];
}
