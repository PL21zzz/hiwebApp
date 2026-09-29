import 'package:flutter/material.dart';
import 'package:hiweb_app_management/core/state/async_state.dart';
import 'package:hiweb_app_management/features/product/repositories/product_repository.dart';
import 'package:hiweb_app_management/core/widgets/common/product/product_card.dart';

class ProductGrid extends StatelessWidget {
  final int? itemCount;

  const ProductGrid({super.key, this.itemCount});

  @override
  Widget build(BuildContext context) {
    final productsState = AsyncState.success(MockProductRepository().getProducts());
    final products = productsState.data ?? const [];
    final count = (itemCount != null && itemCount! > 0 && itemCount! <= products.length)
        ? itemCount!
      : products.length;

    final textScaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 8) / 2;
        final textSectionHeight = textScaler.scale(120.0);
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
              product: products[index],
            );
          },
        );
      },
    );
  }
}
