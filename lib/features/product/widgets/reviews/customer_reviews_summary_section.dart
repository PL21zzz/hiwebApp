import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'review_item_card.dart';

class CustomerReviewsSummarySection extends StatelessWidget {
  final ProductDetailModel detail;
  final VoidCallback? onViewAllReviews;

  const CustomerReviewsSummarySection({
    super.key,
    required this.detail,
    this.onViewAllReviews,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                detail.rating.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(width: 6),
              ...List.generate(
                5,
                (index) => const Icon(
                  Icons.star,
                  size: 14,
                  color: Color(0xFFF59E0B),
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '(${detail.reviewCount})',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF0284C7),
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Row(
            children: [
              Icon(Icons.check_circle, size: 13, color: Color(0xFF0284C7)),
              SizedBox(width: 5),
              Text(
                'Tất cả đánh giá đều từ người đã mua hàng',
                style: TextStyle(fontSize: 11.5, color: Color(0xFF0284C7)),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(height: 1, color: Color(0xFFE2E8F0)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Đánh giá mới nhất',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                'Hiển thị 3 đánh giá',
                style: const TextStyle(
                  fontSize: 11.5,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),

          Column(
            children:
                detail.reviews
                    .take(3)
                    .map((review) => ReviewItemCard(review: review))
                    .toList(),
          ),

          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton(
              onPressed: onViewAllReviews,
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: const BorderSide(color: Color(0xFFCBD5E1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Xem tất cả ${detail.reviewCount} đánh giá',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.chevron_right,
                    size: 16,
                    color: Color(0xFF0284C7),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
