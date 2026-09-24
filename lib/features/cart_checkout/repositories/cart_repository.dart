import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/features/cart_checkout/models/cart_item_model.dart';

abstract class CartRepository {
  List<CartItemModel> getInitialItems();
}

class MockCartRepository implements CartRepository {
  @override
  List<CartItemModel> getInitialItems() {
    return ProductModel.mockCartProducts
        .map(
          (product) => CartItemModel(
            id: product.id,
            shopName: product.shopName,
            name: product.name,
            imageUrl: product.imageUrl,
            brand: product.shopName,
            variantInfo: product.variantOptions.isNotEmpty
                ? 'Đã chọn: ${product.variantOptions.first}'
                : 'Đã chọn: Mặc định',
            price: product.price.toInt(),
            originalPrice: product.originalPrice.toInt(),
          ),
        )
        .toList();
  }
}
