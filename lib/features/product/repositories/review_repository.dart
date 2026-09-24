import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';

abstract class ReviewRepository {
  List<ProductReviewModel> getReviews(ProductDetailModel product);
}

class MockReviewRepository implements ReviewRepository {
  @override
  List<ProductReviewModel> getReviews(ProductDetailModel product) => product.reviews;
}
