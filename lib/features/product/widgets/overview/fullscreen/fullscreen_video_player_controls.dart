import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class FullscreenVideoPlayerControls extends StatelessWidget {
  final bool isPlaying;
  final bool isMuted;
  final Duration position;
  final Duration duration;
  final VoidCallback onTogglePlay;
  final VoidCallback onToggleMute;
  final ValueChanged<double> onChangeStart;
  final ValueChanged<double> onChanged;
  final ValueChanged<double> onChangeEnd;

  const FullscreenVideoPlayerControls({
    super.key,
    required this.isPlaying,
    required this.isMuted,
    required this.position,
    required this.duration,
    required this.onTogglePlay,
    required this.onToggleMute,
    required this.onChangeStart,
    required this.onChanged,
    required this.onChangeEnd,
  });

  String _formatTime(Duration d) {
    if (d.isNegative) d = Duration.zero;
    final minutes = d.inMinutes;
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final maxMs = duration.inMilliseconds.toDouble() > 0
        ? duration.inMilliseconds.toDouble()
        : 5000.0;
    final currentMs = position.inMilliseconds.toDouble().clamp(0.0, maxMs);

    return Container(
      color: Colors.black.withValues(alpha: 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              // Play / Pause Icon
              GestureDetector(
                onTap: onTogglePlay,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // Time format: 0:02 / 0:05
              Text(
                '${_formatTime(position)} / ${_formatTime(duration)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const Spacer(),

              // Volume Icon
              GestureDetector(
                onTap: onToggleMute,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Icon(
                    isMuted ? LucideIcons.volumeX : LucideIcons.volume2,
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
          SizedBox(
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
                onChangeStart: onChangeStart,
                onChanged: onChanged,
                onChangeEnd: onChangeEnd,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
