import 'package:flutter/material.dart';
import '../../models/video/video_model.dart';
import '../../widgets/video/video_header_bar.dart';
import '../../widgets/video/video_info_section.dart';
import '../../widgets/video/video_item_player.dart';
import '../../widgets/video/video_right_actions.dart';
import '../../widgets/video/video_swipe_hint.dart';

class VideoFeedScreen extends StatefulWidget {
  const VideoFeedScreen({super.key});

  @override
  State<VideoFeedScreen> createState() => _VideoFeedScreenState();
}

class _VideoFeedScreenState extends State<VideoFeedScreen> {
  late final PageController _pageController;
  int _currentPage = 0;
  bool _isMuted = false;
  final List<VideoItemModel> _videos = VideoItemModel.mockVideos;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Vertical PageView for 3 Videos
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: _videos.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final video = _videos[index];
              return Stack(
                fit: StackFit.expand,
                children: [
                  // Video Player + Gradient Layer
                  VideoItemPlayer(
                    video: video,
                    isActive: index == _currentPage,
                    isMuted: _isMuted,
                  ),

                  // Right Actions Column (Avatar, Like, Comment, Save, Share, Report)
                  VideoRightActions(video: video),

                  // Left Product & Caption Info Section
                  VideoInfoSection(video: video),

                  // Bottom Swipe Hint Pill (only on first video)
                  if (index == 0) const VideoSwipeHint(),
                ],
              );
            },
          ),

          // 2. Fixed Top Header Bar (3 Tabs + Search + Cart + Mute Loa)
          VideoHeaderBar(
            isMuted: _isMuted,
            onToggleMute: _toggleMute,
          ),
        ],
      ),
    );
  }
}
