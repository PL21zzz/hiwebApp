import 'package:flutter/foundation.dart';
import 'package:hiweb_app_management/core/config/app_config.dart';
import 'package:hiweb_app_management/core/network/api_client.dart';
import 'package:hiweb_app_management/core/state/async_state.dart';
import 'package:hiweb_app_management/features/category/repositories/category_repository.dart';
import 'package:hiweb_app_management/features/home/models/category_model.dart';

class CategoryService extends ChangeNotifier {
  CategoryService._(this._repository);

  static final CategoryService instance = CategoryService._(
    AppConfig.useMockData
        ? MockCategoryRepository()
        : ApiCategoryRepository(ApiClient.instance),
  );

  final CategoryRepository _repository;
  List<DrawerCategoryModel> _rootCategories = const [];
  final Map<String, List<SubcategoryModel>> _categoryTrees = {};
  AsyncState<List<DrawerCategoryModel>> _rootState =
      const AsyncState.initial();
  final Map<String, AsyncState<List<SubcategoryModel>>> _treeStates = {};

  List<DrawerCategoryModel> get rootCategories =>
      List.unmodifiable(_rootCategories);
  AsyncState<List<DrawerCategoryModel>> get rootState => _rootState;
  AsyncState<List<SubcategoryModel>> treeStateFor(String rootId) =>
      _treeStates[rootId] ?? const AsyncState.initial();
  bool get isLoadingRoot => _rootState.isLoading;
  bool get isLoadingTree => _treeStates.values.any((state) => state.isLoading);
  String? get errorMessage => _rootState.errorMessage ??
      _treeStates.values
          .where((state) => state.hasError)
          .map((state) => state.errorMessage)
          .firstWhere((message) => message != null, orElse: () => null);

  List<SubcategoryModel> getCategoryTreeFor(String rootId) => List.unmodifiable(
        _categoryTrees[rootId] ?? const [],
      );

  Future<void> fetchRootCategories() async {
    _rootState = _rootState.loading();
    notifyListeners();
    try {
      final result = await _repository.getCategoryTree();
      _rootCategories = result.roots;
      _categoryTrees
        ..clear()
        ..addAll(result.children);
      _rootState = _rootState.withSuccess(result.roots);
      for (final entry in result.children.entries) {
        _treeStates[entry.key] =
            const AsyncState<List<SubcategoryModel>>.initial()
                .withSuccess(entry.value);
      }
    } catch (error) {
      debugPrint('Error fetching category tree: $error');
      _rootCategories = const [];
      _rootState = _rootState.error(
        'Không thể tải danh sách danh mục: $error',
      );
    } finally {
      notifyListeners();
    }
  }

  Future<void> fetchCategoryTree(String rootId) async {
    if (_categoryTrees.containsKey(rootId)) return;
    final currentState = treeStateFor(rootId);
    _treeStates[rootId] = currentState.loading(keepData: false);
    notifyListeners();
    try {
      final result = await _repository.getSubcategories(rootId);
      _categoryTrees[rootId] = result;
      _treeStates[rootId] = currentState.withSuccess(result);
    } catch (error) {
      debugPrint('Error fetching category $rootId: $error');
      _treeStates[rootId] = currentState.error('Không thể tải danh mục con');
    } finally {
      notifyListeners();
    }
  }
}
