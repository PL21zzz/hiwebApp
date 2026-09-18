import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import '../../models/product_detail_model.dart';

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
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _setupMedia();
  }

  void _setupMedia() {
    _videoController?.dispose();
    _videoController = null;
    _isInitialized = false;
    _isPlaying = false;

    final item = widget.mediaList[_currentIndex];
    if (item.isVideo) {
      _videoController = VideoPlayerController.networkUrl(Uri.parse(item.url))
        ..initialize().then((_) {
          if (mounted) {
            setState(() {
              _isInitialized = true;
            });
            _videoController?.setLooping(true);
            _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
            _videoController?.play();
            setState(() => _isPlaying = true);
          }
        });
      _videoController?.addListener(() {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
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
                        onPressed: () {
                          if (_zoomLevel > 0.8) {
                            setState(() => _zoomLevel -= 0.1);
                          }
                        },
                      ),
                      Text(
                        '${(_zoomLevel * 100).toInt()}%',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(LucideIcons.plus, color: Colors.white, size: 18),
                        onPressed: () {
                          if (_zoomLevel < 2.0) {
                            setState(() => _zoomLevel += 0.1);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Main Media Display Area
            Expanded(
              child: Transform.scale(
                scale: _zoomLevel,
                child: Center(
                  child: item.isVideo
                      ? GestureDetector(
                          onTap: _togglePlay,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (_isInitialized && _videoController != null)
                                AspectRatio(
                                  aspectRatio: _videoController!.value.aspectRatio,
                                  child: VideoPlayer(_videoController!),
                                )
                              else
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                ),

                              if (!_isPlaying && _isInitialized)
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withValues(alpha: 0.6),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  child: const Icon(
                                    Icons.play_arrow,
                                    color: Colors.white,
                                    size: 38,
                                  ),
                                ),
                            ],
                          ),
                        )
                      : Image.network(
                          item.url,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stack) => const Icon(
                            LucideIcons.image,
                            color: Colors.white54,
                            size: 64,
                          ),
                        ),
                ),
              ),
            ),

            // Bottom Video Controls & Scrubber (if Video)
            if (item.isVideo && _isInitialized && _videoController != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.black45,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Text(
                          _formatDuration(_videoController!.value.position),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        Expanded(
                          child: SliderTheme(
                            data: const SliderThemeData(
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                              trackHeight: 3,
                              activeTrackColor: Colors.tealAccent,
                              inactiveTrackColor: Colors.white30,
                              thumbColor: Colors.tealAccent,
                            ),
                            child: Slider(
                              value: _videoController!.value.position.inMilliseconds
                                  .toDouble()
                                  .clamp(
                                    0.0,
                                    _videoController!.value.duration.inMilliseconds.toDouble(),
                                  ),
                              min: 0.0,
                              max: _videoController!.value.duration.inMilliseconds > 0
                                  ? _videoController!.value.duration.inMilliseconds.toDouble()
                                  : 1.0,
                              onChanged: (val) {
                                _videoController?.seekTo(
                                  Duration(milliseconds: val.toInt()),
                                );
                              },
                            ),
                          ),
                        ),
                        Text(
                          _formatDuration(_videoController!.value.duration),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              _isMuted = !_isMuted;
                              _videoController?.setVolume(_isMuted ? 0.0 : 1.0);
                            });
                          },
                          child: Icon(
                            _isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // Bottom Media Thumbnail Bar
            Container(
              height: 70,
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: Colors.black87,
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
                          color: isSelected ? Colors.tealAccent : Colors.white30,
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
          ],
        ),
      ),
    );
  }
}
