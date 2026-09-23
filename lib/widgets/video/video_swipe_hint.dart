import 'package:flutter/material.dart';

class VideoSwipeHint extends StatefulWidget {
  const VideoSwipeHint({super.key});

  @override
  State<VideoSwipeHint> createState() => _VideoSwipeHintState();
}

class _VideoSwipeHintState extends State<VideoSwipeHint>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    )..repeat(reverse: true);
    _offsetAnimation = Tween<double>(begin: 4, end: -5).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: AnimatedBuilder(
          animation: _offsetAnimation,
          builder: (context, child) => Transform.translate(
            offset: Offset(0, _offsetAnimation.value),
            child: child,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('↑', style: TextStyle(color: Color(0xFF334155), fontSize: 13, fontWeight: FontWeight.bold)),
                SizedBox(width: 4),
                Text('Vuốt lên để xem thêm', style: TextStyle(color: Color(0xFF334155), fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
