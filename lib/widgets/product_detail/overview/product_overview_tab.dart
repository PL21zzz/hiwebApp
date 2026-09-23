import 'package:flutter/material.dart';
import '../../../models/product/product_detail_model.dart';
import '../../../theme/app_colors.dart';
import 'overview_media_section.dart';
import 'overview_product_info_section.dart';
import 'overview_variant_section.dart';

class ProductOverviewTab extends StatefulWidget {
  final ScrollController? scrollController;
  final ProductDetailModel? productDetail;
  final String? selectedCapacity;
  final ValueChanged<String?>? onCapacitySelected;

  const ProductOverviewTab({
    super.key,
    this.scrollController,
    this.productDetail,
    this.selectedCapacity,
    this.onCapacitySelected,
  });

  @override
  State<ProductOverviewTab> createState() => _ProductOverviewTabState();
}

class _ProductOverviewTabState extends State<ProductOverviewTab> {
  String? _selectedCapacity;

  ProductDetailModel get _detail =>
      widget.productDetail ?? ProductDetailModel.mockSample;

  @override
  void initState() {
    super.initState();
    _selectedCapacity = widget.selectedCapacity;
  }

  @override
  void didUpdateWidget(covariant ProductOverviewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCapacity != oldWidget.selectedCapacity) {
      _selectedCapacity = widget.selectedCapacity;
    }
  }

  void _selectCapacity(String? capacity) {
    setState(() => _selectedCapacity = capacity);
    widget.onCapacitySelected?.call(capacity);
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OverviewMediaSection(detail: _detail),
        const SizedBox(height: 8),
        OverviewProductInfoSection(detail: _detail),
        const SizedBox(height: 8),
        OverviewVariantSection(
          detail: _detail,
          selectedCapacity: _selectedCapacity,
          onCapacitySelected: _selectCapacity,
        ),
        const SizedBox(height: 8),
        _VoucherSection(detail: _detail),
        const SizedBox(height: 12),
      ],
    );

    if (widget.scrollController != null) {
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: content,
      );
    }
    return content;
  }
}

class _VoucherSection extends StatelessWidget {
  final ProductDetailModel detail;

  const _VoucherSection({required this.detail});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          const Icon(Icons.confirmation_number_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          const Text('Mã giảm giá', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: Color(0xFF334155))),
          const Spacer(),
          Row(
            children: detail.vouchers
                .map(
                  (voucher) => Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: const Color(0xFFFECACA), width: 0.8),
                    ),
                    child: Text(voucher, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
                  ),
                )
                .toList(),
          ),
          const SizedBox(width: 4),
          const Icon(Icons.chevron_right, size: 16, color: Color(0xFF94A3B8)),
        ],
      ),
    );
  }
}
