import 'package:hiweb_app_management/core/network/api_client.dart';
import 'package:hiweb_app_management/core/network/api_endpoints.dart';
import 'package:hiweb_app_management/features/home/models/category_model.dart';

class CategoryTreeData {
  final List<DrawerCategoryModel> roots;
  final Map<String, List<SubcategoryModel>> children;

  const CategoryTreeData({required this.roots, required this.children});
}

abstract class CategoryRepository {
  Future<CategoryTreeData> getCategoryTree();
  Future<List<SubcategoryModel>> getSubcategories(String rootId);
}

class ApiCategoryRepository implements CategoryRepository {
  final ApiClient client;

  ApiCategoryRepository(this.client);

  @override
  Future<CategoryTreeData> getCategoryTree() async {
    final response = await client.get(ApiEndpoints.categoryTree);
    final roots = <DrawerCategoryModel>[];
    final children = <String, List<SubcategoryModel>>{};
    final list = response is Map && response['data'] is List
        ? response['data'] as List<dynamic>
        : const <dynamic>[];

    for (var index = 0; index < list.length; index++) {
      final json = Map<String, dynamic>.from(list[index] as Map);
      final id = json['id']?.toString() ?? '';
      final title = json['name_vi']?.toString() ??
          json['name_en']?.toString() ??
          json['title']?.toString() ?? '';
      final slug = json['slug']?.toString() ?? '';
      roots.add(DrawerCategoryModel(
        id: id,
        title: title,
        emoji: _mapEmoji(json['emoji']?.toString(), title, slug, index),
      ));
      children[id] = _parseChildren(json['children']);
    }

    return CategoryTreeData(roots: roots, children: children);
  }

  @override
  Future<List<SubcategoryModel>> getSubcategories(String rootId) async {
    final data = await getCategoryTree();
    return data.children[rootId] ?? const [];
  }

  List<SubcategoryModel> _parseChildren(dynamic rawChildren) {
    if (rawChildren is! List) return const [];
    return rawChildren.asMap().entries.map((entry) {
      final json = Map<String, dynamic>.from(entry.value as Map);
      final title = json['name_vi']?.toString() ??
          json['name_en']?.toString() ??
          json['title']?.toString() ?? '';
      final rawEmoji = json['emoji']?.toString();
      return SubcategoryModel(
        id: json['id']?.toString() ?? '',
        title: title,
        emoji: (rawEmoji != null && rawEmoji.isNotEmpty) ? rawEmoji : '📦',
        hasChevron: json['has_chevron'] == true,
        targetCategoryId: json['target_category_id']?.toString(),
      );
    }).toList();
  }

  static String _mapEmoji(String? raw, String name, String slug, int index) {
    if (raw != null && raw.isNotEmpty && raw != '📦') return raw;
    final value = '${name.toLowerCase()} ${slug.toLowerCase()}';
    const matches = <String, String>{
      'phụ kiện': '🔧', 'phu-kien': '🔧', 'accessories': '🔧',
      'nghệ thuật': '🎨', 'sưu tầm': '🎨', 'art': '🎨',
      'túi': '👜', 'ví': '👜', 'bag': '👜', 'wallet': '👜',
      'chăm sóc': '💄', 'sắc đẹp': '💄', 'beauty': '💄', 'care': '💄',
      'sách': '📚', 'phim': '📚', 'nhạc': '📚', 'book': '📚', 'media': '📚',
      'quần áo': '👕', 'áo': '👕', 'thời trang': '👕', 'clothing': '👕',
      'thủ công': '✂️', 'vật tư': '✂️', 'craft': '✂️',
      'điện tử': '💻', 'công nghệ': '💻', 'electronic': '💻',
      'nhà cửa': '🏠', 'đời sống': '🏠', 'home': '🏠',
      'trang sức': '💍', 'jewelry': '💍', 'văn phòng': '🎉', 'stationery': '🎉',
      'thú cưng': '🐾', 'pet': '🐾', 'giày': '👟', 'shoes': '👟',
      'đồ chơi': '🎮', 'trò chơi': '🎮', 'toy': '🎮', 'game': '🎮',
      'đám cưới': '💒', 'cưới': '💒', 'wedding': '💒',
      'thực phẩm': '💊', 'sức khỏe': '💊', 'health': '💊', 'mẹ': '👶', 'bé': '👶',
      'baby': '👶', 'collagen': '✨',
    };
    for (final entry in matches.entries) {
      if (value.contains(entry.key)) return entry.value;
    }
    const defaults = ['🔧', '🎨', '👜', '💄', '📚', '👕', '✂️', '💻', '🏠', '💍', '🎉', '🐾', '👟', '🎮', '💒'];
    return defaults[index % defaults.length];
  }
}

class MockCategoryRepository implements CategoryRepository {
  @override
  Future<CategoryTreeData> getCategoryTree() async {
    final roots = DrawerCategoryModel.mockDrawerCategories;
    return CategoryTreeData(
      roots: roots,
      children: {
        for (final root in roots) root.id: SubcategoryModel.getSubcategoriesForCategory(root.id),
      },
    );
  }

  @override
  Future<List<SubcategoryModel>> getSubcategories(String rootId) async =>
      SubcategoryModel.getSubcategoriesForCategory(rootId);
}
