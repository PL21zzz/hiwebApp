import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import 'product_card.dart';

class ProductGrid extends StatelessWidget {
  final int? itemCount;

  const ProductGrid({super.key, this.itemCount});

  static final List<ProductModel> _products = ProductModel.mockProducts;

  @override
  Widget build(BuildContext context) {
    final count = (itemCount != null && itemCount! > 0 && itemCount! <= _products.length)
        ? itemCount!
        : _products.length;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.56,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: count,
      itemBuilder: (context, index) {
        return ProductCard(
          product: _products[index],
        );
      },
    );
  }
}
