import 'dart:async';
import 'package:flutter/material.dart';

class BannerSlider extends StatefulWidget {
  const BannerSlider({super.key});

  @override
  State<BannerSlider> createState() => _BannerSliderState();
}

class _BannerSliderState extends State<BannerSlider> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  // 3 ảnh slider từ Cloudinary do người dùng cung cấp
  final List<String> _bannerUrls = const [
    'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide1_dhs27i.webp',
    'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide2_cjt32o.webp',
    'https://res.cloudinary.com/dypm5avrx/image/upload/v1789547604/slide3_navayf.webp',
  ];

  @override
  void initState() {
    super.initState();
    // Tự động cuộn nhanh hơn (mỗi 2.0 giây chuyển 1 slide)
    _timer = Timer.periodic(const Duration(milliseconds: 2000), (timer) {
      if (_pageController.hasClients) {
        int nextPage = (_currentPage + 1) % _bannerUrls.length;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 6, 12, 12),
      height: 160,
      child: Stack(
        children: [
          // Slider hiển thị ảnh từ Cloudinary
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: _bannerUrls.length,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    _bannerUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: const Color(0xFF0077B6),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFF0077B6),
                        child: const Center(
                          child: Icon(Icons.image_not_supported, color: Colors.white),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          ),

          // 3 Dấu chấm / Thanh ngang chỉ số nhảy theo slide
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _bannerUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: _currentPage == index ? 16 : 4,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
