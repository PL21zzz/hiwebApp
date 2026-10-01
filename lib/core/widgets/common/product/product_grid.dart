import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_card.dart';

import 'package:hiweb_app_management/features/product/models/product_model.dart';

class ProductGrid extends StatelessWidget {
  final int? itemCount;
  final List<ProductModel>? products;

  const ProductGrid({
    super.key,
    this.itemCount,
    this.products,
  });

  @override
  Widget build(BuildContext context) {
    final list = products ?? MockProductRepository().getProducts();
    final count = (itemCount != null && itemCount! > 0 && itemCount! <= list.length)
        ? itemCount!
        : list.length;

    final textScaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 900
            ? 4
            : constraints.maxWidth > 600
                ? 3
                : 2;
        const spacing = 8.0;
        final totalSpacing = spacing * (crossAxisCount - 1);
        final cardWidth = (constraints.maxWidth - totalSpacing) / crossAxisCount;
        final textSectionHeight = textScaler.scale(120.0);
        final childAspectRatio = cardWidth / (cardWidth + textSectionHeight);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: childAspectRatio,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: count,
          itemBuilder: (context, index) {
            return ProductCard(
              product: list[index],
            );
          },
        );
      },
    );
  }
}
