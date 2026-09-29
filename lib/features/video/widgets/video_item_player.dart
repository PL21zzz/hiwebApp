import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:hiweb_app_management/features/video/models/video_model.dart';

class _HeartAnimationItem {
  final Key key;
  final Offset position;

  _HeartAnimationItem({required this.key, required this.position});
}

class VideoItemPlayer extends StatefulWidget {
  final VideoItemModel video;
  final bool isActive;
  final bool isMuted;
  final VoidCallback? onDoubleTapLike;

  const VideoItemPlayer({
    super.key,
    required this.video,
    required this.isActive,
    required this.isMuted,
    this.onDoubleTapLike,
  });

  @override
  State<VideoItemPlayer> createState() => _VideoItemPlayerState();
}

class _VideoItemPlayerState extends State<VideoItemPlayer>
    with WidgetsBindingObserver {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlayingManually = true;

  final List<_HeartAnimationItem> _hearts = [];
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isActive) {
      _initController();
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_isInitialized) return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      _controller?.pause();
    } else if (state == AppLifecycleState.resumed) {
      if (widget.isActive && _isPlayingManually) {
        _controller?.play();
      }
    }
  }

  void _onControllerUpdated() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _initController() async {
    _controller?.removeListener(_onControllerUpdated);
    _controller?.dispose();
    _controller = null;

    final controller =
        widget.video.videoUrl.startsWith('assets/')
            ? VideoPlayerController.asset(widget.video.videoUrl)
            : VideoPlayerController.networkUrl(
              Uri.parse(widget.video.videoUrl),
            );
    _controller = controller;
    controller.addListener(_onControllerUpdated);

    try {
      final initialization = controller.initialize();
      if (widget.video.videoUrl.startsWith('assets/')) {
        await initialization;
      } else {
        await initialization.timeout(const Duration(seconds: 20));
      }
      if (!mounted || _controller != controller) {
        controller.removeListener(_onControllerUpdated);
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
        _controller?.pause();
        _controller?.removeListener(_onControllerUpdated);
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
    WidgetsBinding.instance.removeObserver(this);
    _controller?.removeListener(_onControllerUpdated);
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

  void _handleDoubleTap() {
    if (_doubleTapDetails != null) {
      final pos = _doubleTapDetails!.localPosition;
      final item = _HeartAnimationItem(
        key: UniqueKey(),
        position: pos,
      );
      setState(() {
        _hearts.add(item);
      });
      if (widget.onDoubleTapLike != null) {
        widget.onDoubleTapLike!();
      }
    }
  }

  void _removeHeart(Key key) {
    setState(() {
      _hearts.removeWhere((h) => h.key == key);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool showBuffering =
        _isInitialized &&
        _controller != null &&
        _controller!.value.isBuffering;

    return GestureDetector(
      onDoubleTapDown: (details) => _doubleTapDetails = details,
      onDoubleTap: _handleDoubleTap,
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
            Stack(
              fit: StackFit.expand,
              children: [
                widget.video.thumbnailUrl.startsWith('http')
                    ? Image.network(
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
                    )
                    : Image.asset(
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
                Container(
                  color: Colors.black26,
                  child: const Center(
                    child: SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),

          // 1b. Buffering Indicator
          if (showBuffering)
            Container(
              color: Colors.black26,
              child: const Center(
                child: SizedBox(
                  width: 36,
                  height: 36,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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

          // 4. Double-Tap Floating Heart Popups
          ..._hearts.map(
            (heart) => Positioned(
              left: heart.position.dx - 40,
              top: heart.position.dy - 40,
              child: _FloatingHeartWidget(
                key: heart.key,
                onComplete: () => _removeHeart(heart.key),
              ),
            ),
          ),

          // 5. TikTok-style Video Seekbar Timeline at bottom edge
          if (_isInitialized && _controller != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: SizedBox(
                height: 12,
                child: VideoProgressIndicator(
                  _controller!,
                  allowScrubbing: true,
                  padding: const EdgeInsets.only(top: 8),
                  colors: const VideoProgressColors(
                    playedColor: Color(0xFF0097B2),
                    bufferedColor: Colors.white24,
                    backgroundColor: Colors.white12,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _FloatingHeartWidget extends StatefulWidget {
  final VoidCallback onComplete;

  const _FloatingHeartWidget({super.key, required this.onComplete});

  @override
  State<_FloatingHeartWidget> createState() => _FloatingHeartWidgetState();
}

class _FloatingHeartWidgetState extends State<_FloatingHeartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;
  late Animation<double> _opacityAnim;
  late Animation<double> _translateYAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scaleAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.2, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 60),
    ]).animate(_animController);

    _opacityAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 30),
    ]).animate(_animController);

    _translateYAnim = Tween<double>(begin: 0, end: -60).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );

    _animController.forward().then((_) {
      widget.onComplete();
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _translateYAnim.value),
          child: Opacity(
            opacity: _opacityAnim.value,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: const Icon(
                Icons.favorite_rounded,
                color: Color(0xFFE53935),
                size: 80,
                shadows: [
                  Shadow(
                    color: Colors.black38,
                    blurRadius: 10,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
