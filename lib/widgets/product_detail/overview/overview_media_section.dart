import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/product/product_detail_model.dart';
import '../../../theme/app_colors.dart';
import 'fullscreen_video_modal.dart';
import 'overview_video_item.dart';

class OverviewMediaSection extends StatefulWidget {
  final ProductDetailModel detail;

  const OverviewMediaSection({super.key, required this.detail});

  @override
  State<OverviewMediaSection> createState() => _OverviewMediaSectionState();
}

class _OverviewMediaSectionState extends State<OverviewMediaSection>
    with SingleTickerProviderStateMixin {
  static const double _badgeHeight = 25;
  static const double _badgeMargin = 5;
  static const double _itemSlotHeight = _badgeHeight + _badgeMargin;

  final _pageController = PageController();
  int _currentMediaIndex = 0;
  int _topItemIndex = 0;
  bool _isMuted = true;
  late final AnimationController _tickerController;
  late final Animation<double> _tickerAnimation;
  Timer? _tickerTimer;

  @override
  void initState() {
    super.initState();
    _tickerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _tickerAnimation = CurvedAnimation(
      parent: _tickerController,
      curve: Curves.easeInOutCubic,
    );
    if (widget.detail.tickerItems.isNotEmpty) {
      _tickerTimer = Timer.periodic(const Duration(seconds: 3), (_) {
        if (!mounted) return;
        _tickerController.forward(from: 0).then((_) {
          if (!mounted) return;
          setState(() {
            _topItemIndex = (_topItemIndex + 1) % widget.detail.tickerItems.length;
            _tickerController.value = 0;
          });
        });
      });
    }
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreen(int index) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (_) => FullscreenVideoModal(
        mediaList: widget.detail.mediaList,
        initialIndex: index,
      ),
    );
  }

  Widget _tickerBadge(TickerItemModel item) {
    return Container(
      height: _badgeHeight,
      margin: const EdgeInsets.only(bottom: _badgeMargin),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: item.bgColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(item.icon, size: 13, color: item.iconColor),
          const SizedBox(width: 5),
          Flexible(
            child: Text(
              item.text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFF334155)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = widget.detail.mediaList;
    final tickerItems = widget.detail.tickerItems;
    return Column(
      children: [
        SizedBox(
          height: 270,
          width: double.infinity,
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: media.length,
                onPageChanged: (index) => setState(() => _currentMediaIndex = index),
                itemBuilder: (context, index) {
                  final item = media[index];
                  if (item.isVideo) {
                    return OverviewVideoItem(
                      videoUrl: item.url,
                      thumbUrl: item.thumb.isNotEmpty ? item.thumb : item.url,
                      isCurrentPage: index == _currentMediaIndex,
                      isMuted: _isMuted,
                      onOpenFullscreen: () => _openFullscreen(index),
                    );
                  }
                  return GestureDetector(
                    onTap: () => _openFullscreen(index),
                    child: Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const ColoredBox(
                        color: Color(0xFFCBD5E1),
                        child: Icon(LucideIcons.image, size: 48, color: Color(0xFF94A3B8)),
                      ),
                    ),
                  );
                },
              ),
              if (tickerItems.isNotEmpty)
                Positioned(
                  left: 12,
                  bottom: 8,
                  width: 260,
                  child: SizedBox(
                    height: _itemSlotHeight * 2,
                    child: ClipRect(
                      child: AnimatedBuilder(
                        animation: _tickerAnimation,
                        builder: (_, __) {
                          final offset = -_tickerAnimation.value * _itemSlotHeight;
                          TickerItemModel itemAt(int index) =>
                              tickerItems[index % tickerItems.length];
                          return OverflowBox(
                            alignment: Alignment.topLeft,
                            minHeight: 0,
                            maxHeight: double.infinity,
                            minWidth: 0,
                            maxWidth: 260,
                            child: Transform.translate(
                              offset: Offset(0, offset),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _tickerBadge(itemAt(_topItemIndex)),
                                  _tickerBadge(itemAt(_topItemIndex + 1)),
                                  _tickerBadge(itemAt(_topItemIndex + 2)),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              Positioned(
                right: 12,
                bottom: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => _isMuted = !_isMuted),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), shape: BoxShape.circle),
                        child: Icon(_isMuted ? LucideIcons.volumeX : LucideIcons.volume2, color: Colors.white, size: 15),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
                      child: Text('${_currentMediaIndex + 1}/${media.length}', style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: media.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final item = media[index];
                final selected = index == _currentMediaIndex;
                return GestureDetector(
                  onTap: () => _pageController.animateToPage(index, duration: const Duration(milliseconds: 250), curve: Curves.easeInOut),
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(6), border: Border.all(color: selected ? AppColors.primary : const Color(0xFFE2E8F0), width: selected ? 2 : 1)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(item.thumb.isNotEmpty ? item.thumb : item.url, fit: BoxFit.cover),
                          if (item.isVideo) ...[
                            Container(color: Colors.black.withValues(alpha: 0.25)),
                            const Center(child: Icon(Icons.play_arrow, color: Colors.white, size: 18)),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
