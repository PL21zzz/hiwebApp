import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import 'package:hiweb_app_management/features/product/models/product_detail_model.dart';
import 'fullscreen/fullscreen_top_bar.dart';
import 'fullscreen/fullscreen_video_player_controls.dart';
import 'fullscreen/fullscreen_thumbnail_bar.dart';

class FullscreenVideoModal extends StatefulWidget {
  final List<ProductMediaModel> mediaList;
  final int initialIndex;

  const FullscreenVideoModal({
    super.key,
    required this.mediaList,
    required this.initialIndex,
  });

  @override
  State<FullscreenVideoModal> createState() => _FullscreenVideoModalState();
}

class _FullscreenVideoModalState extends State<FullscreenVideoModal> with WidgetsBindingObserver {
  late int _currentIndex;
  VideoPlayerController? _videoController;
  bool _isInitialized = false;
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isDragging = false;
  double _dragPositionMs = 0.0;

  final TransformationController _transformationController =
      TransformationController();
  TapDownDetails? _doubleTapDetails;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentIndex = widget.initialIndex;
    _setupMedia();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_videoController == null || !_isInitialized) return;
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      if (_isPlaying) {
        _videoController?.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      if (_isPlaying) {
        _videoController?.play();
      }
    }
  }

  void _setupMedia() {
    _transformationController.value = Matrix4.identity();
    _videoController?.removeListener(_videoListener);
    _videoController?.dispose();
    _videoController = null;
    _isInitialized = false;
    _isPlaying = false;
    _isDragging = false;
    _dragPositionMs = 0.0;

    final item = widget.mediaList[_currentIndex];
    if (item.isVideo) {
      final controller = item.url.startsWith('assets/')
          ? VideoPlayerController.asset(item.url)
          : VideoPlayerController.networkUrl(Uri.parse(item.url));
      _videoController = controller;
      controller.addListener(_videoListener);
      controller.initialize().then((_) {
        if (mounted && _videoController == controller) {
          setState(() {
            _isInitialized = true;
          });
          controller.setLooping(true);
          controller.setVolume(_isMuted ? 0.0 : 1.0);
          controller.play();
          if (mounted) {
            setState(() => _isPlaying = true);
          }
        }
      }).catchError((err) {
        debugPrint('Error initializing video: $err');
      });
    }
  }

  void _videoListener() {
    if (mounted && !_isDragging) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _videoController?.removeListener(_videoListener);
    _transformationController.dispose();
    _videoController?.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (_videoController == null || !_isInitialized) return;
    setState(() {
      if (_videoController!.value.isPlaying) {
        _videoController!.pause();
        _isPlaying = false;
      } else {
        _videoController!.play();
        _isPlaying = true;
      }
    });
  }

  void _previousMedia() {
    if (_currentIndex > 0) {
      setState(() {
        _currentIndex--;
        _setupMedia();
      });
    }
  }

  void _nextMedia() {
    if (_currentIndex < widget.mediaList.length - 1) {
      setState(() {
        _currentIndex++;
        _setupMedia();
      });
    }
  }

  void _handleDoubleTap() {
    if (_transformationController.value != Matrix4.identity()) {
      _transformationController.value = Matrix4.identity();
    } else {
      final position = _doubleTapDetails?.localPosition ?? Offset.zero;
      _transformationController.value = Matrix4.identity()
        ..translate(-position.dx * 1.2, -position.dy * 1.2)
        ..scale(2.5);
    }
  }

  void _zoomIn() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale < 4.0) {
      final newScale = (currentScale + 0.5).clamp(0.8, 4.0);
      _transformationController.value = Matrix4.identity()..scale(newScale);
    }
  }

  void _zoomOut() {
    final currentScale = _transformationController.value.getMaxScaleOnAxis();
    if (currentScale > 0.8) {
      final newScale = (currentScale - 0.5).clamp(0.8, 4.0);
      _transformationController.value = Matrix4.identity()..scale(newScale);
    }
  }

  Duration _getDuration() {
    if (_videoController != null &&
        _videoController!.value.isInitialized &&
        _videoController!.value.duration > Duration.zero) {
      return _videoController!.value.duration;
    }
    return const Duration(seconds: 5);
  }

  Duration _getPosition() {
    if (_isDragging) {
      return Duration(milliseconds: _dragPositionMs.toInt());
    }
    if (_videoController != null && _videoController!.value.isInitialized) {
      return _videoController!.value.position;
    }
    return Duration.zero;
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.mediaList[_currentIndex];

    return Dialog.fullscreen(
      backgroundColor: Colors.black,
      child: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            FullscreenTopBar(
              currentIndex: _currentIndex,
              totalCount: widget.mediaList.length,
              transformationController: _transformationController,
              onZoomIn: _zoomIn,
              onZoomOut: _zoomOut,
            ),

            // Main Media Display Area with Nav Arrows
            Expanded(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Main Media Content
                  Center(
                    child: item.isVideo
                        ? Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  GestureDetector(
                                    onTap: _togglePlay,
                                    child: AspectRatio(
                                      aspectRatio: _isInitialized && _videoController != null
                                          ? _videoController!.value.aspectRatio
                                          : 16 / 9,
                                      child: _isInitialized && _videoController != null
                                          ? VideoPlayer(_videoController!)
                                          : const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                              ),
                                            ),
                                    ),
                                  ),

                                  // Play icon overlay when paused
                                  if (!_isPlaying && _isInitialized)
                                    GestureDetector(
                                      onTap: _togglePlay,
                                      child: Container(
                                        width: 56,
                                        height: 56,
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          shape: BoxShape.circle,
                                          border: Border.all(color: Colors.white, width: 2),
                                        ),
                                        child: const Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 36,
                                        ),
                                      ),
                                    ),

                                  // Standard Mobile Video Player Control Bar
                                  if (_isInitialized && _videoController != null)
                                    FullscreenVideoPlayerControls(
                                      isPlaying: _isPlaying,
                                      isMuted: _isMuted,
                                      position: _getPosition(),
                                      duration: _getDuration(),
                                      onTogglePlay: _togglePlay,
                                      onToggleMute: () {
                                        setState(() {
                                          _isMuted = !_isMuted;
                                          _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
                                        });
                                      },
                                      onChangeStart: (val) {
                                        setState(() {
                                          _isDragging = true;
                                          _dragPositionMs = val;
                                        });
                                      },
                                      onChanged: (val) {
                                        setState(() {
                                          _dragPositionMs = val;
                                        });
                                      },
                                      onChangeEnd: (val) {
                                        _videoController
                                            ?.seekTo(Duration(milliseconds: val.toInt()))
                                            .then((_) {
                                          if (mounted) {
                                            setState(() {
                                              _isDragging = false;
                                            });
                                          }
                                        });
                                      },
                                    ),
                                ],
                              ),
                            ),
                          )
                        : GestureDetector(
                            onDoubleTapDown: (details) =>
                                _doubleTapDetails = details,
                            onDoubleTap: _handleDoubleTap,
                            child: InteractiveViewer(
                              transformationController: _transformationController,
                              minScale: 0.8,
                              maxScale: 4.0,
                              clipBehavior: Clip.none,
                              child: item.url.startsWith('http')
                                  ? Image.network(
                                      item.url,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) =>
                                          const Icon(
                                        LucideIcons.image,
                                        color: Colors.white54,
                                        size: 64,
                                      ),
                                    )
                                  : Image.asset(
                                      item.url,
                                      fit: BoxFit.contain,
                                      errorBuilder: (context, error, stack) =>
                                          const Icon(
                                        LucideIcons.image,
                                        color: Colors.white54,
                                        size: 64,
                                      ),
                                    ),
                            ),
                          ),
                  ),

                  // Left Navigation Arrow (<)
                  if (_currentIndex > 0)
                    Positioned(
                      left: 16,
                      child: GestureDetector(
                        onTap: _previousMedia,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_left,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),

                  // Right Navigation Arrow (>)
                  if (_currentIndex < widget.mediaList.length - 1)
                    Positioned(
                      right: 16,
                      child: GestureDetector(
                        onTap: _nextMedia,
                        child: Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.5),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.chevron_right,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Bottom Media Thumbnail Bar & Page Indicator
            FullscreenThumbnailBar(
              mediaList: widget.mediaList,
              currentIndex: _currentIndex,
              onSelectMedia: (index) {
                setState(() {
                  _currentIndex = index;
                  _setupMedia();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
