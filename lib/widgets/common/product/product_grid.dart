import 'package:flutter/material.dart';
import '../../../models/product/product_model.dart';
import '../product/product_card.dart';

class ProductGrid extends StatelessWidget {
  final int? itemCount;

  const ProductGrid({super.key, this.itemCount});

  static final List<ProductModel> _products = ProductModel.mockProducts;

  @override
  Widget build(BuildContext context) {
    final count = (itemCount != null && itemCount! > 0 && itemCount! <= _products.length)
        ? itemCount!
        : _products.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 8) / 2;
        const textSectionHeight = 104.0;
        final childAspectRatio = cardWidth / (cardWidth + textSectionHeight);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: childAspectRatio,
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
      },
    );
  }
}
