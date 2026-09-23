import 'dart:async';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../screens/main_navigation_screen.dart';
import '../../screens/product/flash_sale_screen.dart';
import '../../theme/app_colors.dart';

class FlashSaleSection extends StatefulWidget {
  const FlashSaleSection({super.key});

  @override
  State<FlashSaleSection> createState() => _FlashSaleSectionState();
}

class _FlashSaleSectionState extends State<FlashSaleSection> {
  Timer? _timer;
  int _remainingSeconds = 0;

  @override
  void initState() {
    super.initState();
    _updateRemainingTime();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) _updateRemainingTime();
    });
  }

  void _updateRemainingTime() {
    final now = DateTime.now();
    final hour = now.hour;
    final target = hour >= 12 && hour < 15
        ? DateTime(now.year, now.month, now.day, 15)
        : hour >= 15 && hour < 19
            ? DateTime(now.year, now.month, now.day, 19)
            : hour >= 19
                ? DateTime(now.year, now.month, now.day + 1)
                : DateTime(now.year, now.month, now.day, 12);
    final seconds = target.difference(now).inSeconds;
    setState(() => _remainingSeconds = seconds > 0 ? seconds : 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int value) => value.toString().padLeft(2, '0');

  Widget _timeBox(String value) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(4)),
        child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
      );

  Widget _imageTile({required String imageUrl, String? badgeText}) {
    return Expanded(
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: AspectRatio(
              aspectRatio: 0.78,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: Color(0xFFE2E8F0),
                  child: Icon(Icons.broken_image, color: Color(0xFF94A3B8)),
                ),
              ),
            ),
          ),
          if (badgeText != null)
            Positioned(
              top: 4,
              left: 4,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFFF6D00), borderRadius: BorderRadius.circular(3)),
                child: Text(badgeText, style: const TextStyle(color: Colors.white, fontSize: 7.5, fontWeight: FontWeight.w900)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _videoTile() => const Expanded(child: _HomeVideoTile());

  void _openVideoTab() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => const MainNavigationScreen(initialIndex: 2),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _twoDigits(_remainingSeconds ~/ 3600);
    final minutes = _twoDigits((_remainingSeconds % 3600) ~/ 60);
    final seconds = _twoDigits(_remainingSeconds % 60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                pageBuilder: (_, __, ___) => const FlashSaleScreen(),
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              )),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 24,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            const Icon(Icons.bolt_rounded, color: Color(0xFFFF6D00), size: 18),
                            const SizedBox(width: 2),
                            const Text('Flash Sale', style: TextStyle(color: Color(0xFFFF6D00), fontSize: 13, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                            const SizedBox(width: 8),
                            _timeBox(hours),
                            const Text(' : ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            _timeBox(minutes),
                            const Text(' : ', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                            _timeBox(seconds),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _imageTile(imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549363/flash-sale1_wbuuhi.webp', badgeText: 'ĐÃ BÁN 4100'),
                        const SizedBox(width: 6),
                        _imageTile(imageUrl: 'https://res.cloudinary.com/dypm5avrx/image/upload/v1789549364/flash-sale2_fvgamt.webp', badgeText: 'ĐÃ BÁN 2800'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: _openVideoTab,
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 24,
                      child: Row(
                        children: [
                          Icon(Icons.play_circle_fill_rounded, color: AppColors.primary, size: 18),
                          SizedBox(width: 4),
                          Text('VietMade VIDEO', style: TextStyle(color: AppColors.primary, fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(children: [_videoTile(), const SizedBox(width: 6), _videoTile()]),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeVideoTile extends StatefulWidget {
  const _HomeVideoTile();

  @override
  State<_HomeVideoTile> createState() => _HomeVideoTileState();
}

class _HomeVideoTileState extends State<_HomeVideoTile> {
  late final VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/videodetail.mp4')
      ..initialize().then((_) {
        if (!mounted) return;
        _controller
          ..setLooping(true)
          ..setVolume(0)
          ..play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const AspectRatio(aspectRatio: 0.78, child: ColoredBox(color: Color(0xFFE2E8F0)));
    }
    return AspectRatio(
      aspectRatio: 0.78,
      child: FittedBox(
        fit: BoxFit.cover,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _controller.value.size.width,
          height: _controller.value.size.height,
          child: VideoPlayer(_controller),
        ),
      ),
    );
  }
}
