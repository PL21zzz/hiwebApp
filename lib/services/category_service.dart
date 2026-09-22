import 'package:flutter/foundation.dart';
import '../core/config/app_config.dart';
import '../core/network/api_client.dart';
import '../core/network/api_endpoints.dart';
import '../models/home/category_model.dart';

class CategoryService extends ChangeNotifier {
  CategoryService._();
  static final CategoryService instance = CategoryService._();

  List<DrawerCategoryModel> _rootCategories = DrawerCategoryModel.mockDrawerCategories;
  final Map<String, List<SubcategoryModel>> _categoryTrees = {};

  bool _isLoadingRoot = false;
  bool _isLoadingTree = false;
  String? _errorMessage;

  List<DrawerCategoryModel> get rootCategories => List.unmodifiable(_rootCategories);
  bool get isLoadingRoot => _isLoadingRoot;
  bool get isLoadingTree => _isLoadingTree;
  String? get errorMessage => _errorMessage;

  /// Get subcategories (Category Tree) for selected Category Root ID
  List<SubcategoryModel> getCategoryTreeFor(String rootId) {
    if (_categoryTrees.containsKey(rootId)) {
      return List.unmodifiable(_categoryTrees[rootId]!);
    }
    return SubcategoryModel.getSubcategoriesForCategory(rootId);
  }

  /// Fetch Category Tree from Backend API (Parses root categories and subcategories)
  Future<void> fetchRootCategories() async {
    if (AppConfig.useMockData) {
      _rootCategories = DrawerCategoryModel.mockDrawerCategories;
      notifyListeners();
      return;
    }

    _isLoadingRoot = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiClient.instance.get(ApiEndpoints.categoryTree);

      if (response != null && response is Map && response.containsKey('data')) {
        final List<dynamic> list = response['data'] ?? [];
        final List<DrawerCategoryModel> roots = [];

        for (int i = 0; i < list.length; i++) {
          final rootJson = list[i];
          final String rootId = rootJson['id']?.toString() ?? '';
          final String title = rootJson['name_vi']?.toString() ?? rootJson['name_en']?.toString() ?? rootJson['title']?.toString() ?? '';
          final String slug = rootJson['slug']?.toString() ?? '';
          final String emoji = mapEmojiForCategory(rootJson['emoji']?.toString(), title, slug, i);

          roots.add(DrawerCategoryModel(
            id: rootId,
            emoji: emoji,
            title: title,
          ));

          // Parse subcategories / children for this root category
          if (rootJson['children'] is List) {
            final List<dynamic> childrenList = rootJson['children'];
            final subcategories = <SubcategoryModel>[];
            for (int j = 0; j < childrenList.length; j++) {
              final childJson = childrenList[j];
              final childTitle = childJson['name_vi']?.toString() ?? childJson['name_en']?.toString() ?? childJson['title']?.toString() ?? '';
              final childSlug = childJson['slug']?.toString() ?? '';
              final childEmoji = mapEmojiForCategory(childJson['emoji']?.toString(), childTitle, childSlug, j);

              subcategories.add(SubcategoryModel(
                id: childJson['id']?.toString() ?? '',
                emoji: childEmoji,
                title: childTitle,
                hasChevron: childJson['has_chevron'] == true,
                targetCategoryId: childJson['target_category_id']?.toString(),
              ));
            }

            _categoryTrees[rootId] = subcategories;
          }
        }

        if (roots.isNotEmpty) {
          _rootCategories = roots;
        }
      }
    } catch (e) {
      debugPrint('Error fetching category tree API: $e');
      _errorMessage = 'Không thể tải danh sách danh mục: $e';
      _rootCategories = DrawerCategoryModel.mockDrawerCategories;
    } finally {
      _isLoadingRoot = false;
      notifyListeners();
    }
  }

  /// Fetch Subcategories for selected root ID
  Future<void> fetchCategoryTree(String rootId) async {
    if (AppConfig.useMockData) {
      _categoryTrees[rootId] = SubcategoryModel.getSubcategoriesForCategory(rootId);
      notifyListeners();
      return;
    }

    // If children for rootId were already loaded from category_tree API, notify listeners
    if (_categoryTrees.containsKey(rootId)) {
      notifyListeners();
      return;
    }

    _isLoadingTree = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // The category tree endpoint returns roots and their children together.
      await fetchRootCategories();
    } finally {
      _isLoadingTree = false;
      notifyListeners();
    }
  }

  /// Map category names and slugs to matching emoji icons from the mock design
  static String mapEmojiForCategory(String? rawEmoji, String name, String slug, int index) {
    if (rawEmoji != null && rawEmoji.isNotEmpty && rawEmoji != '📦') {
      return rawEmoji;
    }

    final lower = '${name.toLowerCase()} ${slug.toLowerCase()}';

    if (lower.contains('phụ kiện') || lower.contains('phu-kien') || lower.contains('accessories')) return '🔧';
    if (lower.contains('nghệ thuật') || lower.contains('sưu tầm') || lower.contains('art')) return '🎨';
    if (lower.contains('túi') || lower.contains('ví') || lower.contains('bag') || lower.contains('wallet')) return '👜';
    if (lower.contains('chăm sóc') || lower.contains('sắc đẹp') || lower.contains('beauty') || lower.contains('care')) return '💄';
    if (lower.contains('sách') || lower.contains('phim') || lower.contains('nhạc') || lower.contains('book') || lower.contains('media')) return '📚';
    if (lower.contains('quần áo') || lower.contains('áo') || lower.contains('thời trang') || lower.contains('clothing') || lower.contains('apparel')) return '👕';
    if (lower.contains('thủ công') || lower.contains('vật tư') || lower.contains('craft')) return '✂️';
    if (lower.contains('điện tử') || lower.contains('công nghệ') || lower.contains('electronic')) return '💻';
    if (lower.contains('nhà cửa') || lower.contains('đời sống') || lower.contains('home')) return '🏠';
    if (lower.contains('trang sức') || lower.contains('jewelry')) return '💍';
    if (lower.contains('văn phòng') || lower.contains('stationery')) return '🎉';
    if (lower.contains('thú cưng') || lower.contains('pet')) return '🐾';
    if (lower.contains('giày') || lower.contains('shoes') || lower.contains('footwear')) return '👟';
    if (lower.contains('đồ chơi') || lower.contains('trò chơi') || lower.contains('toy') || lower.contains('game')) return '🎮';
    if (lower.contains('đám cưới') || lower.contains('cưới') || lower.contains('wedding')) return '💒';
    if (lower.contains('thực phẩm') || lower.contains('sức khỏe') || lower.contains('health')) return '💊';
    if (lower.contains('mẹ') || lower.contains('bé') || lower.contains('baby')) return '👶';
    if (lower.contains('collagen')) return '✨';

    const defaultIcons = [
      '🔧', '🎨', '👜', '💄', '📚', '👕', '✂️', '💻',
      '🏠', '💍', '🎉', '🐾', '👟', '🎮', '💒'
    ];
    return defaultIcons[index % defaultIcons.length];
  }
}
