import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';

class VideoItemPlayer extends StatefulWidget {
  final VideoItemModel video;
  final bool isActive;
  final bool isMuted;

  const VideoItemPlayer({
    super.key,
    required this.video,
    required this.isActive,
    required this.isMuted,
  });

  @override
  State<VideoItemPlayer> createState() => _VideoItemPlayerState();
}

class _VideoItemPlayerState extends State<VideoItemPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlayingManually = true;

  @override
  void initState() {
    super.initState();
    if (widget.isActive) {
      _initController();
    }
  }

  Future<void> _initController() async {
    _controller?.dispose();
    _controller = null;

    final controller =
        widget.video.videoUrl.startsWith('assets/')
            ? VideoPlayerController.asset(widget.video.videoUrl)
            : VideoPlayerController.networkUrl(
              Uri.parse(widget.video.videoUrl),
            );
    _controller = controller;

    try {
      final initialization = controller.initialize();
      if (widget.video.videoUrl.startsWith('assets/')) {
        await initialization;
      } else {
        await initialization.timeout(const Duration(seconds: 20));
      }
      if (!mounted || _controller != controller) {
        controller.dispose();
        return;
      }
      controller.setLooping(true);
      controller.setVolume(widget.isMuted ? 0.0 : 1.0);
      setState(() {
        _isInitialized = true;
      });
      if (widget.isActive && _isPlayingManually) {
        controller.play();
      }
    } catch (e) {
      debugPrint('Error initializing video player: $e');
      if (mounted && _controller == controller) {
        setState(() {
          _isInitialized = false;
        });
      }
    }
  }

  @override
  void didUpdateWidget(covariant VideoItemPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      if (widget.isActive) {
        _isPlayingManually = true;
        if (_controller == null || !_isInitialized) {
          _initController();
        } else {
          _controller!.play();
        }
      } else {
        // Free video buffers immediately when user scrolls to another video
        _controller?.pause();
        _controller?.dispose();
        _controller = null;
        _isInitialized = false;
      }
    } else if (_controller != null && _isInitialized) {
      if (oldWidget.isMuted != widget.isMuted) {
        _controller!.setVolume(widget.isMuted ? 0.0 : 1.0);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller != null && _isInitialized) {
      setState(() {
        if (_controller!.value.isPlaying) {
          _controller!.pause();
          _isPlayingManually = false;
        } else {
          _controller!.play();
          _isPlayingManually = true;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _togglePlayPause,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Background Video / Thumbnail
          if (_isInitialized &&
              _controller != null &&
              _controller!.value.isInitialized)
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
            Image.network(
              widget.video.thumbnailUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: const Color(0xFF1E293B),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 48,
                        color: Colors.white70,
                      ),
                    ),
                  ),
            ),

          // 2. Play Icon Overlay when paused
          if (_isInitialized &&
              _controller != null &&
              !_controller!.value.isPlaying)
            Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 48,
                ),
              ),
            ),

          // 3. Linear Gradient Overlays (Top & Bottom)
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.75),
                  ],
                  stops: const [0.0, 0.25, 0.60, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
