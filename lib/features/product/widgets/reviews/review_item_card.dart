import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import '../overview/fullscreen_video_modal.dart';

class ReviewItemCard extends StatelessWidget {
  final ProductReviewModel review;

  const ReviewItemCard({
    super.key,
    required this.review,
  });

  void _openReviewMedia(BuildContext context, ProductReviewMediaModel item) {
    if (item.isVideo && item.videoUrl != null) {
      showDialog(
        context: context,
        useSafeArea: false,
        builder:
            (_) => FullscreenVideoModal(
              mediaList: [
                ProductMediaModel(
                  type: 'video',
                  url: item.videoUrl!,
                  thumb: item.url,
                  title: 'Video đánh giá',
                ),
              ],
              initialIndex: 0,
            ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder:
          (_) => Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(12),
            child: InteractiveViewer(
              minScale: 0.8,
              maxScale: 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.url.startsWith('http')
                    ? Image.network(item.url, fit: BoxFit.contain)
                    : Image.asset(item.url, fit: BoxFit.contain),
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media =
        review.media.isNotEmpty
            ? review.media
            : review.photos
                .map((url) => ProductReviewMediaModel(url: url))
                .toList();

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: const Color(0xFFE879F9),
                backgroundImage:
                    review.userAvatar.isNotEmpty
                        ? (review.userAvatar.startsWith('http')
                            ? NetworkImage(review.userAvatar)
                            : AssetImage(review.userAvatar) as ImageProvider)
                        : null,
                child:
                    review.userAvatar.isEmpty
                        ? Text(
                          review.userName.isNotEmpty
                              ? review.userName[0].toUpperCase()
                              : 'U',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                        : null,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          review.userName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                        if (review.isVerifiedPurchase) ...[
                          const SizedBox(width: 5),
                          const Text(
                            'Đã mua hàng',
                            style: TextStyle(
                              fontSize: 9,
                              color: Color(0xFF0284C7),
                            ),
                          ),
                        ],
                      ],
                    ),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (index) => Icon(
                            Icons.star,
                            size: 11,
                            color:
                                index < review.rating
                                    ? const Color(0xFFEAB308)
                                    : const Color(0xFFCBD5E1),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          review.variant,
                          style: const TextStyle(
                            fontSize: 9.5,
                            color: Color(0xFF94A3B8),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(
                review.date,
                style: const TextStyle(fontSize: 9.5, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 8),

          if (review.comment.isNotEmpty)
            Text(
              review.comment,
              style: const TextStyle(
                fontSize: 11.5,
                color: Color(0xFF334155),
                height: 1.35,
              ),
            ),

          if (media.isNotEmpty) ...[
            const SizedBox(height: 8),
            SizedBox(
              height: 64,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.zero,
                itemCount: media.length,
                separatorBuilder: (context, index) => const SizedBox(width: 6),
                itemBuilder: (context, index) {
                  final item = media[index];
                  return GestureDetector(
                    onTap: () => _openReviewMedia(context, item),
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: item.url.startsWith('http')
                              ? Image.network(
                                item.url,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFE2E8F0),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              )
                              : Image.asset(
                                item.url,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) => Container(
                                      width: 64,
                                      height: 64,
                                      color: const Color(0xFFE2E8F0),
                                      child: const Icon(
                                        Icons.image,
                                        color: Colors.grey,
                                      ),
                                    ),
                              ),
                        ),
                        if (item.isVideo)
                          const Positioned.fill(
                            child: Center(
                              child: Icon(
                                Icons.play_circle_fill,
                                size: 25,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
