import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import '../../../theme/app_colors.dart';

class OverviewVideoItem extends StatefulWidget {
  final String videoUrl;
  final String thumbUrl;
  final bool isCurrentPage;
  final bool isMuted;
  final VoidCallback onOpenFullscreen;

  const OverviewVideoItem({
    super.key,
    required this.videoUrl,
    required this.thumbUrl,
    required this.isCurrentPage,
    required this.isMuted,
    required this.onOpenFullscreen,
  });

  @override
  State<OverviewVideoItem> createState() => _OverviewVideoItemState();
}

class _OverviewVideoItemState extends State<OverviewVideoItem> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (widget.isCurrentPage) _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    if (_controller != null || !widget.isCurrentPage) return;
    final controller = widget.videoUrl.startsWith('assets/')
        ? VideoPlayerController.asset(widget.videoUrl)
        : VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl));
    _controller = controller;
    try {
      await controller.initialize();
      if (!mounted || _controller != controller) return;
      await controller.seekTo(Duration.zero);
      await controller.setLooping(true);
      await controller.setVolume(widget.isMuted ? 0 : 1);
      setState(() => _isInitialized = true);
    } catch (error) {
      debugPrint('Error initializing product video: $error');
      if (_controller == controller) {
        await controller.dispose();
        _controller = null;
      }
    }
  }

  @override
  void didUpdateWidget(covariant OverviewVideoItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null && _isInitialized) {
      if (oldWidget.isMuted != widget.isMuted) {
        _controller?.setVolume(widget.isMuted ? 0 : 1);
      }
      if (!widget.isCurrentPage && _isPlaying) {
        _controller?.pause();
        setState(() => _isPlaying = false);
      }
    } else if (widget.isCurrentPage && !oldWidget.isCurrentPage) {
      _initializePlayer();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleTap() {
    if (_controller == null || !_isInitialized) return;
    if (_isPlaying) {
      widget.onOpenFullscreen();
    } else {
      _controller!.play();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (_isInitialized && _controller != null)
            FittedBox(
              fit: BoxFit.cover,
              clipBehavior: Clip.hardEdge,
              child: SizedBox(
                width: _controller!.value.size.width,
                height: _controller!.value.size.height,
                child: VideoPlayer(_controller!),
              ),
            )
          else
            Image.network(widget.thumbUrl, fit: BoxFit.cover),
          if (!_isPlaying) ...[
            Container(color: Colors.black.withValues(alpha: 0.25)),
            Center(
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 3))],
                ),
                child: const Icon(Icons.play_arrow, color: Colors.white, size: 32),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
