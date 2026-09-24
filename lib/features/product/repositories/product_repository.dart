import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';

abstract class ProductRepository {
  List<ProductModel> getProducts({String? category});
  ProductDetailModel getProductDetail(String productId);
  ProductDetailModel getFallbackDetail();
}

class MockProductRepository implements ProductRepository {
  @override
  List<ProductModel> getProducts({String? category}) {
    if (category == null || category.isEmpty) return ProductModel.mockProducts;
    return ProductModel.mockProducts.where((item) => item.category == category).toList();
  }

  @override
  ProductDetailModel getProductDetail(String productId) {
    final product = ProductModel.mockProducts.firstWhere(
      (item) => item.id == productId,
      orElse: () => ProductModel.mockProducts.first,
    );
    return ProductDetailModel.fromProduct(product);
  }

  @override
  ProductDetailModel getFallbackDetail() => ProductDetailModel.mockSample;
}
