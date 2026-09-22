import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import '../../../models/product/product_detail_model.dart';

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

class _FullscreenVideoModalState extends State<FullscreenVideoModal> {
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
    _currentIndex = widget.initialIndex;
    _setupMedia();
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
      final controller = VideoPlayerController.networkUrl(Uri.parse(item.url));
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
          setState(() => _isPlaying = true);
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

  String _formatTime(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
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
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Close button X
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 26),
                    onPressed: () => Navigator.of(context).pop(),
                  ),

                  // Title / Counter
                  Text(
                    '${_currentIndex + 1}/${widget.mediaList.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // Zoom level controls (- 100% +)
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(LucideIcons.minus, color: Colors.white, size: 18),
                        onPressed: _zoomOut,
                      ),
                      ValueListenableBuilder<Matrix4>(
                        valueListenable: _transformationController,
                        builder: (context, value, child) {
                          final scale = value.getMaxScaleOnAxis();
                          return Text(
                            '${(scale * 100).toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
                        onPressed: _zoomIn,
                      ),
                    ],
                  ),
                ],
              ),
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

                                  // Standard Mobile Video Player Control Bar (matching sample)
                                  if (_isInitialized && _videoController != null)
                                    Container(
                                      color: Colors.black.withValues(alpha: 0.75),
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              // Play / Pause Icon
                                              GestureDetector(
                                                onTap: _togglePlay,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                                                  child: Icon(
                                                    _isPlaying ? Icons.pause : Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 22,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 4),

                                              // Time format: 0:02 / 0:05
                                              Builder(
                                                builder: (context) {
                                                  final dur = _getDuration();
                                                  final pos = _getPosition();
                                                  return Text(
                                                    '${_formatTime(pos)} / ${_formatTime(dur)}',
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 13,
                                                      fontWeight: FontWeight.w500,
                                                    ),
                                                  );
                                                },
                                              ),

                                              const Spacer(),

                                              // Volume Icon
                                              GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    _isMuted = !_isMuted;
                                                    _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
                                                  });
                                                },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(6),
                                                  child: Icon(
                                                    _isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
                                                    color: Colors.white,
                                                    size: 18,
                                                  ),
                                                ),
                                              ),

                                              // Fullscreen Icon
                                              const Padding(
                                                padding: EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.fullscreen,
                                                  color: Colors.white,
                                                  size: 22,
                                                ),
                                              ),

                                              // 3-dots Menu Icon
                                              const Padding(
                                                padding: EdgeInsets.all(6),
                                                child: Icon(
                                                  Icons.more_vert,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),

                                          // Sleek White Progress Slider Bar
                                          Builder(
                                            builder: (context) {
                                              final dur = _getDuration();
                                              final pos = _getPosition();
                                              final maxMs = dur.inMilliseconds.toDouble() > 0
                                                  ? dur.inMilliseconds.toDouble()
                                                  : 5000.0;
                                              final currentMs = pos.inMilliseconds
                                                  .toDouble()
                                                  .clamp(0.0, maxMs);

                                              return SizedBox(
                                                height: 20,
                                                child: SliderTheme(
                                                  data: const SliderThemeData(
                                                    thumbShape: RoundSliderThumbShape(
                                                      enabledThumbRadius: 6,
                                                    ),
                                                    trackHeight: 3,
                                                    activeTrackColor: Colors.white,
                                                    inactiveTrackColor: Colors.white38,
                                                    thumbColor: Colors.white,
                                                    overlayShape: RoundSliderOverlayShape(
                                                      overlayRadius: 10,
                                                    ),
                                                  ),
                                                  child: Slider(
                                                    value: currentMs,
                                                    min: 0.0,
                                                    max: maxMs,
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
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
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
                              child: Image.network(
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
            Container(
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
                      itemCount: widget.mediaList.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final media = widget.mediaList[index];
                        final isSelected = index == _currentIndex;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _currentIndex = index;
                              _setupMedia();
                            });
                          },
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
                                  Image.network(
                                    media.thumb.isNotEmpty ? media.thumb : media.url,
                                    fit: BoxFit.cover,
                                  ),
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
                      '${_currentIndex + 1}/${widget.mediaList.length}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
