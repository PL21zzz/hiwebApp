import 'package:flutter/foundation.dart';
import '../../models/product/product_model.dart';
import '../../models/user/cart/cart_item_model.dart';

class CartService extends ChangeNotifier {
  CartService._()
      : _items = ProductModel.mockCartProducts
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

  static final CartService instance = CartService._();

  final List<CartItemModel> _items;
  bool _useXu = false;
  final int _xuBalance = 150;
  final int _shippingFee = 22000;
  final int _shippingDiscount = 22000;

  List<CartItemModel> get items => List.unmodifiable(_items);
  bool get useXu => _useXu;
  int get xuBalance => _xuBalance;
  int get shippingFee => _shippingFee;
  int get shippingDiscount => _shippingDiscount;

  /// Total count of all items (quantities) in cart
  int get totalItemCount {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Get quantity of a specific item in cart by ID or name
  int getItemQuantity(String idOrName) {
    final index = _items.indexWhere((i) => i.id == idOrName || i.name == idOrName);
    return index != -1 ? _items[index].quantity : 0;
  }

  /// Total count of selected items for checkout
  int get totalSelectedCount {
    return _items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + item.quantity);
  }

  /// Are all items selected?
  bool get isAllSelected {
    if (_items.isEmpty) return false;
    return _items.every((item) => item.isSelected);
  }

  /// Subtotal of selected items at current price
  int get itemsSubtotal {
    return _items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  /// Original price subtotal of selected items
  int get originalSubtotal {
    return _items
        .where((item) => item.isSelected)
        .fold(0, (sum, item) => sum + (item.originalPrice * item.quantity));
  }

  /// Effective shipping fee after discount
  int get effectiveShippingFee {
    if (totalSelectedCount == 0) return 0;
    final net = _shippingFee - _shippingDiscount;
    return net > 0 ? net : 0;
  }

  /// Discount amount from Xu
  int get xuDiscountAmount {
    return (_useXu && totalSelectedCount > 0) ? _xuBalance : 0;
  }

  /// Total money saved
  int get totalSavings {
    if (totalSelectedCount == 0) return 0;
    final itemDiscount = originalSubtotal - itemsSubtotal;
    return itemDiscount + _shippingDiscount + xuDiscountAmount;
  }

  /// Final checkout amount
  int get finalTotal {
    if (totalSelectedCount == 0) return 0;
    final total = itemsSubtotal + effectiveShippingFee - xuDiscountAmount;
    return total > 0 ? total : 0;
  }

  // --- ACTIONS ---

  void addToCart(CartItemModel newItem) {
    final existingIndex = _items.indexWhere(
      (item) => item.id == newItem.id || item.name == newItem.name,
    );

    if (existingIndex != -1) {
      final existing = _items[existingIndex];
      _items[existingIndex] = existing.copyWith(
        quantity: existing.quantity + 1,
        isSelected: true,
      );
    } else {
      _items.add(newItem.copyWith(isSelected: true));
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      final newQty = _items[index].quantity + delta;
      if (newQty < 1) return;
      _items[index] = _items[index].copyWith(quantity: newQty);
      notifyListeners();
    }
  }

  void toggleItemSelection(String itemId) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        isSelected: !_items[index].isSelected,
      );
      notifyListeners();
    }
  }

  void toggleShopSelection(String shopName, bool select) {
    for (int i = 0; i < _items.length; i++) {
      if (_items[i].shopName == shopName) {
        _items[i] = _items[i].copyWith(isSelected: select);
      }
    }
    notifyListeners();
  }

  void toggleSelectAll(bool select) {
    for (int i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(isSelected: select);
    }
    notifyListeners();
  }

  void toggleUseXu(bool value) {
    _useXu = value;
    notifyListeners();
  }

  void removeItem(String itemId) {
    _items.removeWhere((i) => i.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
