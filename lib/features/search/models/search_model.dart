class SearchSuggestionModel {
  final String id;
  final String emoji;
  final String title;

  const SearchSuggestionModel({
    required this.id,
    required this.emoji,
    required this.title,
  });

  static const List<SearchSuggestionModel> mockSuggestions = [
    SearchSuggestionModel(id: 's1', emoji: '🤖', title: 'chatgpt'),
    SearchSuggestionModel(id: 's2', emoji: '💊', title: 'Collagen Peptide'),
  ];
}

class SearchPopularCategoryModel {
  final String id;
  final String emoji;
  final String title;

  const SearchPopularCategoryModel({
    required this.id,
    required this.emoji,
    required this.title,
  });

  static const List<SearchPopularCategoryModel> mockPopularCategories = [
    SearchPopularCategoryModel(id: 'pc1', emoji: '📦', title: 'Thực phẩm chức năng'),
    SearchPopularCategoryModel(id: 'pc2', emoji: '🧴', title: 'Kem trị nám lẫn nhanh'),
    SearchPopularCategoryModel(id: 'pc3', emoji: '🐾', title: 'Chăm sóc thư cưng'),
    SearchPopularCategoryModel(id: 'pc4', emoji: '💊', title: 'Viên uống trắng da'),
    SearchPopularCategoryModel(id: 'pc5', emoji: '🧴', title: 'Dầu xoa bóp'),
    SearchPopularCategoryModel(id: 'pc6', emoji: '🌿', title: 'Ginkgo Biloba'),
    SearchPopularCategoryModel(id: 'pc7', emoji: '✨', title: 'Tẩy da chết'),
    SearchPopularCategoryModel(id: 'pc8', emoji: '🍳', title: 'Đồ gia dụng nhà bếp'),
  ];
}

class SearchQuickTagModel {
  static const List<String> mockQuickTags = [
    'Kem Dưỡng Ẩm',
    'Kem Chống Nắng',
    'Toner',
    'Tẩy Trang',
    'Sữa Rửa Mặt',
    'Son Môi',
    'Serum',
  ];
}
