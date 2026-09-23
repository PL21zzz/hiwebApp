import 'package:flutter/material.dart';
import '../../models/product/product_detail_model.dart';
import '../../widgets/product_detail/overview/fullscreen_video_modal.dart';

class ProductReviewsScreen extends StatefulWidget {
  final ProductDetailModel productDetail;

  const ProductReviewsScreen({super.key, required this.productDetail});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  int _filterIndex = 0;

  List<ProductReviewModel> get _reviews {
    final reviews = widget.productDetail.reviews;
    switch (_filterIndex) {
      case 1:
        return reviews.where((review) => review.media.isNotEmpty || review.photos.isNotEmpty).toList();
      case 2:
        return reviews.where((review) => review.rating == 5).toList();
      case 3:
        return reviews.where((review) => review.rating == 4).toList();
      case 4:
        return reviews.where((review) => review.rating == 3).toList();
      default:
        return reviews;
    }
  }

  int _countFor(int index) {
    final reviews = widget.productDetail.reviews;
    if (index == 0) return widget.productDetail.reviewCount;
    if (index == 1) return reviews.where((review) => review.media.isNotEmpty || review.photos.isNotEmpty).length;
    final rating = index == 2 ? 5 : index == 3 ? 4 : 3;
    return reviews.where((review) => review.rating == rating).length;
  }

  void _openMedia(ProductReviewMediaModel item) {
    if (item.isVideo && item.videoUrl != null) {
      showDialog(
        context: context,
        useSafeArea: false,
        builder: (_) => FullscreenVideoModal(
          mediaList: [ProductMediaModel(type: 'video', url: item.videoUrl!, thumb: item.url, title: 'Video đánh giá')],
          initialIndex: 0,
        ),
      );
      return;
    }
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        child: InteractiveViewer(child: Image.network(item.url, fit: BoxFit.contain)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final detail = widget.productDetail;
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E293B),
        elevation: 0,
        centerTitle: true,
        title: const Text('Đánh giá sản phẩm', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        children: [
          _buildSummary(detail),
          _buildFilters(),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 0),
            child: Text(
              _filterIndex == 0 ? 'Mới nhất' : _filterTitle,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
          ),
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(children: _reviews.map(_buildReview).toList()),
          ),
        ],
      ),
    );
  }

  String get _filterTitle => ['Mới nhất', 'Có hình ảnh', '5 sao', '4 sao', '3 sao'][_filterIndex];

  Widget _buildSummary(ProductDetailModel detail) {
    final counts = List.generate(5, (index) => detail.reviews.where((review) => review.rating == 5 - index).length);
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
      child: Column(children: [
        Row(children: [
          Text(detail.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0284C7))),
          const SizedBox(width: 8),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: List.generate(5, (_) => const Icon(Icons.star, size: 12, color: Color(0xFFF59E0B)))),
            Text('Trên 5', style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8))),
          ]),
          const SizedBox(width: 18),
          Expanded(child: Column(children: List.generate(5, (index) => _ratingBar(5 - index, counts[index], detail.reviews.length)))),
        ]),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: BoxDecoration(color: const Color(0xFFE0F2FE), borderRadius: BorderRadius.circular(4)),
          child: const Row(children: [Icon(Icons.check_circle, size: 11, color: Color(0xFF0284C7)), SizedBox(width: 4), Text('Tất cả đánh giá đều từ người đã mua hàng', style: TextStyle(fontSize: 9.5, color: Color(0xFF0284C7)))]),
        ),
      ]),
    );
  }

  Widget _ratingBar(int rating, int count, int total) {
    return Row(children: [
      SizedBox(width: 18, child: Text('$rating ★', style: const TextStyle(fontSize: 8, color: Color(0xFF64748B)))),
      Expanded(child: LinearProgressIndicator(value: total == 0 ? 0 : count / total, minHeight: 4, borderRadius: BorderRadius.circular(4), backgroundColor: const Color(0xFFF1F5F9), color: const Color(0xFFF59E0B))),
      SizedBox(width: 18, child: Text('$count', textAlign: TextAlign.right, style: const TextStyle(fontSize: 8, color: Color(0xFF94A3B8)))),
    ]);
  }

  Widget _buildFilters() {
    final labels = ['Mới nhất', 'Có hình ảnh', '5 sao', '4 sao', '3 sao'];
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: List.generate(labels.length, (index) {
          final selected = _filterIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: ChoiceChip(
              label: Text('${labels[index]} (${_countFor(index)})', style: TextStyle(fontSize: 9, color: selected ? const Color(0xFF0284C7) : const Color(0xFF475569))),
              selected: selected,
              onSelected: (_) => setState(() => _filterIndex = index),
              selectedColor: const Color(0xFFE0F2FE),
              backgroundColor: Colors.white,
              side: BorderSide(color: selected ? const Color(0xFF38BDF8) : const Color(0xFFE2E8F0)),
              visualDensity: VisualDensity.compact,
              padding: const EdgeInsets.symmetric(horizontal: 5),
            ),
          );
        })),
      ),
    );
  }

  Widget _buildReview(ProductReviewModel review) {
    final media = review.media.isNotEmpty ? review.media : review.photos.map((url) => ProductReviewMediaModel(url: url)).toList();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0)))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(radius: 15, backgroundColor: const Color(0xFFE879F9), child: Text(review.userName.isEmpty ? 'U' : review.userName[0], style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold))),
          const SizedBox(width: 8),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Text(review.userName, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)), const SizedBox(width: 5), if (review.isVerifiedPurchase) const Text('Đã mua hàng', style: TextStyle(fontSize: 8.5, color: Color(0xFF0284C7)))]),
            Row(children: [for (var i = 0; i < 5; i++) Icon(Icons.star, size: 10, color: i < review.rating ? const Color(0xFFF59E0B) : const Color(0xFFCBD5E1)), const SizedBox(width: 5), Text(review.variant, style: const TextStyle(fontSize: 9, color: Color(0xFF94A3B8)))]),
          ])),
          Text(review.date, style: const TextStyle(fontSize: 8.5, color: Color(0xFF94A3B8))),
        ]),
        const SizedBox(height: 7),
        Text(review.comment, style: const TextStyle(fontSize: 11, color: Color(0xFF334155), height: 1.35)),
        if (media.isNotEmpty) ...[
          const SizedBox(height: 8),
          SizedBox(height: 64, child: ListView.separated(scrollDirection: Axis.horizontal, itemCount: media.length, separatorBuilder: (_, __) => const SizedBox(width: 6), itemBuilder: (_, index) {
            final item = media[index];
            return GestureDetector(onTap: () => _openMedia(item), child: Stack(children: [ClipRRect(borderRadius: BorderRadius.circular(5), child: Image.network(item.url, width: 64, height: 64, fit: BoxFit.cover)), if (item.isVideo) const Positioned.fill(child: Center(child: Icon(Icons.play_circle_fill, color: Colors.white, size: 25)))]));
          })),
        ],
        if (review.shopResponse != null) ...[
          const SizedBox(height: 8),
          Container(width: double.infinity, padding: const EdgeInsets.all(8), color: const Color(0xFFF8FAFC), child: Text('Phản hồi của Shop\n${review.shopResponse}', style: const TextStyle(fontSize: 9, color: Color(0xFF64748B), height: 1.35))),
        ],
      ]),
    );
  }
}
