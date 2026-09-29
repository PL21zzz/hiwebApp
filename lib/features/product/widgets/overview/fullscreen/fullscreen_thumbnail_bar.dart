import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';

class FullscreenThumbnailBar extends StatelessWidget {
  final List<ProductMediaModel> mediaList;
  final int currentIndex;
  final ValueChanged<int> onSelectMedia;

  const FullscreenThumbnailBar({
    super.key,
    required this.mediaList,
    required this.currentIndex,
    required this.onSelectMedia,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.black87,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 54,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: mediaList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final media = mediaList[index];
                final isSelected = index == currentIndex;

                return GestureDetector(
                  onTap: () => onSelectMedia(index),
                  child: Container(
                    width: 54,
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected ? Colors.cyanAccent : Colors.white30,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          () {
                            final imgUrl =
                                media.thumb.isNotEmpty ? media.thumb : media.url;
                            if (imgUrl.startsWith('http')) {
                              return Image.network(
                                imgUrl,
                                fit: BoxFit.cover,
                              );
                            }
                            return Image.asset(
                              imgUrl,
                              fit: BoxFit.cover,
                            );
                          }(),
                          if (media.isVideo)
                            Container(
                              color: Colors.black38,
                              child: const Center(
                                child: Icon(
                                  Icons.play_arrow,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 6),

          // Page Pill Counter (1/6)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '${currentIndex + 1}/${mediaList.length}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
