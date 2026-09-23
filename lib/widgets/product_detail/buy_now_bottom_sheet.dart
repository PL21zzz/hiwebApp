import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../models/product/buy_now_mock_data.dart';
import '../../models/product/product_detail_model.dart';
import '../../theme/app_colors.dart';
import 'product_customization_section.dart';

class BuyNowBottomSheet extends StatefulWidget {
  final ProductDetailModel productDetail;
  final String? initialCapacity;
  final void Function(String? selectedCapacity, int quantity) onConfirm;

  const BuyNowBottomSheet({
    super.key,
    required this.productDetail,
    this.initialCapacity,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required ProductDetailModel productDetail,
    String? initialCapacity,
    required void Function(String? selectedCapacity, int quantity) onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => BuyNowBottomSheet(
            productDetail: productDetail,
            initialCapacity: initialCapacity,
            onConfirm: onConfirm,
          ),
    );
  }

  @override
  State<BuyNowBottomSheet> createState() => _BuyNowBottomSheetState();
}

class _BuyNowBottomSheetState extends State<BuyNowBottomSheet> {
  String? _selectedVariant;
  int _quantity = 1;

  List<String> get _variants {
    return widget.productDetail.effectiveVariantOptions;
  }

  @override
  void initState() {
    super.initState();
    if (widget.initialCapacity != null &&
        _variants.contains(widget.initialCapacity)) {
      _selectedVariant = widget.initialCapacity!;
    }
  }

  String _formatCurrency(double price) {
    final intPrice = price.toInt();
    final str = intPrice.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(str[i]);
    }
    return '${buffer.toString()}đ';
  }

  @override
  Widget build(BuildContext context) {
    final mediaList = widget.productDetail.mediaList;
    final images =
        mediaList.isNotEmpty
            ? mediaList.map((m) => m.isVideo ? m.thumb : m.url).toList()
            : BuyNowMockData.fallbackImages;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Thumbnails row & Close Button
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 48, 12),
                  child: SizedBox(
                    height: 72,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: images.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 8),
                      itemBuilder: (context, index) {
                        return Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                            image: DecorationImage(
                              image: NetworkImage(images[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 14,
                  right: 14,
                  child: InkWell(
                    onTap: () => Navigator.of(context).pop(),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF64748B),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          LucideIcons.x,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    widget.productDetail.name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),

                  // Price
                  Row(
                    children: [
                      const Text(
                        'Giá bán: ',
                        style: TextStyle(
                          fontSize: 13.5,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      Text(
                        _formatCurrency(widget.productDetail.price),
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),

                  // Stock
                  const Text(
                    'Tồn kho: ${BuyNowMockData.stock}',
                    style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 14),

                  // Variants title
                  const Text(
                    'Phân loại',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    widget.productDetail.effectiveVariantLabel,
                    style: TextStyle(fontSize: 12.5, color: Color(0xFF64748B)),
                  ),
                  const SizedBox(height: 8),

                  // Variant Chips
                  Wrap(
                    spacing: 10,
                    children:
                        _variants.map((variant) {
                          final isSelected = _selectedVariant == variant;
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedVariant = variant;
                              });
                            },
                            borderRadius: BorderRadius.circular(8),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isSelected
                                            ? const Color(0xFFF0F9FF)
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : const Color(0xFFCBD5E1),
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    variant,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight:
                                          isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                      color:
                                          isSelected
                                              ? AppColors.primary
                                              : const Color(0xFF334155),
                                    ),
                                  ),
                                ),
                                if (isSelected)
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 14,
                                      height: 14,
                                      decoration: const BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomLeft: Radius.circular(4),
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                          size: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                  ),
                  const SizedBox(height: 18),

                  const ProductCustomizationSection(),
                  const SizedBox(height: 18),

                  // Quantity Stepper
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Số lượng:',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Row(
                        children: [
                          _buildStepperButton(
                            icon: Icons.remove,
                            onTap:
                                _quantity > 1
                                    ? () => setState(() => _quantity--)
                                    : null,
                          ),
                          Container(
                            width: 50,
                            height: 34,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xFFCBD5E1),
                              ),
                            ),
                            child: Text(
                              '$_quantity',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                          _buildStepperButton(
                            icon: Icons.add,
                            onTap: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Button "MUA NGAY"
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed:
                          _variants.isNotEmpty && _selectedVariant == null
                              ? null
                              : () {
                                Navigator.of(context).pop();
                                widget.onConfirm(_selectedVariant, _quantity);
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            _variants.isNotEmpty && _selectedVariant == null
                                ? const Color(0xFFCBD5E1)
                                : AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'MUA NGAY',
                        style: TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepperButton({
    required IconData icon,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        width: 36,
        height: 34,
        decoration: BoxDecoration(
          color: onTap == null ? const Color(0xFFF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFCBD5E1)),
        ),
        child: Icon(
          icon,
          size: 16,
          color:
              onTap == null ? const Color(0xFF94A3B8) : const Color(0xFF334155),
        ),
      ),
    );
  }
}
