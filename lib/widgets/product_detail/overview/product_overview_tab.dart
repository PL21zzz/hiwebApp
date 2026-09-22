import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:video_player/video_player.dart';
import '../../../models/product/product_detail_model.dart';
import '../../../theme/app_colors.dart';
import 'fullscreen_video_modal.dart';

class ProductOverviewTab extends StatefulWidget {
  final ScrollController? scrollController;
  final ProductDetailModel? productDetail;
  final String? selectedCapacity;
  final ValueChanged<String?>? onCapacitySelected;

  const ProductOverviewTab({
    super.key,
    this.scrollController,
    this.productDetail,
    this.selectedCapacity,
    this.onCapacitySelected,
  });

  @override
  State<ProductOverviewTab> createState() => _ProductOverviewTabState();
}

class _ProductOverviewTabState extends State<ProductOverviewTab>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();

  int _currentMediaIndex = 0;
  bool _isMuted = true;
  late bool _isFavorite;
  String? _selectedCapacity;

  ProductDetailModel get _detail =>
      widget.productDetail ?? ProductDetailModel.mockSample;

  int _topItemIndex = 0;
  AnimationController? _tickerAnimController;
  Animation<double>? _tickerAnimation;
  Timer? _tickerTimer;

  static const double _badgeHeight = 25.0;
  static const double _badgeMargin = 5.0;
  static const double _itemSlotHeight = _badgeHeight + _badgeMargin;

  void _ensureTickerAnimController() {
    if (_tickerAnimController == null) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      _tickerAnimController = controller;
      _tickerAnimation = CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Animation<double> get _tickerAnim {
    _ensureTickerAnimController();
    return _tickerAnimation!;
  }

  @override
  void initState() {
    super.initState();
    _isFavorite = _detail.isFavorite;
    _selectedCapacity = widget.selectedCapacity;

    _ensureTickerAnimController();

    _tickerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        _ensureTickerAnimController();
        _tickerAnimController!.forward(from: 0.0).then((_) {
          if (mounted) {
            setState(() {
              _topItemIndex = (_topItemIndex + 1) % _detail.tickerItems.length;
              _tickerAnimController!.value = 0.0;
            });
          }
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant ProductOverviewTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedCapacity != oldWidget.selectedCapacity) {
      setState(() {
        _selectedCapacity = widget.selectedCapacity;
      });
    }
  }

  @override
  void dispose() {
    _tickerTimer?.cancel();
    _tickerAnimController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _openFullscreenModal(int index) {
    showDialog(
      context: context,
      useSafeArea: false,
      builder: (context) => FullscreenVideoModal(
        mediaList: _detail.mediaList,
        initialIndex: index,
      ),
    );
  }

  Widget _buildTickerBadgeWidget(TickerItemModel item) {
    return Container(
      height: _badgeHeight,
      margin: const EdgeInsets.only(bottom: _badgeMargin),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: item.bgColor.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item.icon,
            size: 13,
            color: item.iconColor,
          ),
          const SizedBox(width: 5),
          Text(
            item.text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF334155),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityChip(String cap) {
    final isCapSelected = _selectedCapacity == cap;
    return GestureDetector(
      onTap: () {
        final newCap = isCapSelected ? null : cap;
        setState(() {
          _selectedCapacity = newCap;
        });
        if (widget.onCapacitySelected != null) {
          widget.onCapacitySelected!(newCap);
        }
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: isCapSelected ? const Color(0xFFF0F9FF) : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color:
                    isCapSelected ? AppColors.primary : const Color(0xFFCBD5E1),
                width: isCapSelected ? 1.5 : 1,
              ),
            ),
            child: Text(
              cap,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isCapSelected ? FontWeight.bold : FontWeight.w500,
                color: isCapSelected
                    ? AppColors.primary
                    : const Color(0xFF334155),
              ),
            ),
          ),
          if (isCapSelected)
            Positioned(
              top: 0,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(7),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
                child: const Icon(
                  Icons.check,
                  size: 9,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // --- A. Main Media Slider ---
        Container(
          height: 270,
          width: double.infinity,
          color: const Color(0xFFE2E8F0),
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _detail.mediaList.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentMediaIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final item = _detail.mediaList[index];

                  if (item.isVideo) {
                    return _OverviewVideoItemWidget(
                      videoUrl: item.url,
                      thumbUrl: item.thumb.isNotEmpty ? item.thumb : item.url,
                      isCurrentPage: index == _currentMediaIndex,
                      isMuted: _isMuted,
                      onOpenFullscreen: () => _openFullscreenModal(index),
                    );
                  }

                  return GestureDetector(
                    onTap: () => _openFullscreenModal(index),
                    child: Image.network(
                      item.url,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) {
                        return Container(
                          color: const Color(0xFFCBD5E1),
                          child: const Icon(
                            LucideIcons.image,
                            size: 48,
                            color: Color(0xFF94A3B8),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),

              // Bottom-Left 6-Item Continuous Slide-Up Ticker Queue
              Positioned(
                left: 12,
                bottom: 8,
                width: 260,
                child: SizedBox(
                  height: _itemSlotHeight * 2,
                  child: ClipRect(
                    child: AnimatedBuilder(
                      animation: _tickerAnim,
                      builder: (context, child) {
                        final dy = -_tickerAnim.value * _itemSlotHeight;

                        final item1 = _detail.tickerItems[_topItemIndex];
                        final item2 = _detail.tickerItems[
                            (_topItemIndex + 1) % _detail.tickerItems.length];
                        final item3 = _detail.tickerItems[
                            (_topItemIndex + 2) % _detail.tickerItems.length];

                        return Transform.translate(
                          offset: Offset(0, dy),
                          child: OverflowBox(
                            minWidth: 0,
                            maxWidth: 260,
                            minHeight: 0,
                            maxHeight: 120,
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildTickerBadgeWidget(item1),
                                _buildTickerBadgeWidget(item2),
                                _buildTickerBadgeWidget(item3),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              // Bottom-Right Controls (Mute & Indicator)
              Positioned(
                right: 12,
                bottom: 10,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _isMuted
                              ? LucideIcons.volumeX
                              : LucideIcons.volume2,
                          color: Colors.white,
                          size: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${_currentMediaIndex + 1}/${_detail.mediaList.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
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

        // --- B. Horizontal Thumbnail Carousel ---
        Container(
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 8,
          ),
          child: SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _detail.mediaList.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _currentMediaIndex;
                final item = _detail.mediaList[index];
                return GestureDetector(
                  onTap: () {
                    _pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeInOut,
                    );
                  },
                  child: Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : const Color(0xFFE2E8F0),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            item.thumb.isNotEmpty ? item.thumb : item.url,
                            fit: BoxFit.cover,
                          ),
                          if (item.isVideo) ...[
                            Container(
                              color: Colors.black.withValues(alpha: 0.25),
                            ),
                            const Center(
                              child: Icon(
                                Icons.play_arrow,
                                color: Colors.white,
                                size: 18,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // --- C. Product Title & Price Card ---
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Best seller badge
              GestureDetector(
                onTap: () {},
                child: Row(
                  children: [
                    const _TrophyIcon(
                      size: 16,
                      color: Color(0xFF087A34),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _detail.bestSellerBadge.replaceAll('🌳 ', ''),
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF087A34),
                        ),
                      ),
                    ),
                    const Icon(
                      LucideIcons.chevronRight,
                      size: 16,
                      color: Color(0xFF087A34),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Title + Favorite Badge
              RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: Container(
                        margin: const EdgeInsets.only(right: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEF4444),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Yêu thích',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    TextSpan(
                      text: _detail.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Price Row (CrossAxisAlignment.center to prevent baseline misalignment)
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${_detail.price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${_detail.originalPrice.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}đ',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-${_detail.discountPercent}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Sales & Heart / Rating Row
              Row(
                children: [
                  Text(
                    'Đã bán ${_detail.soldCount}',
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    width: 14,
                    height: 14,
                    decoration: const BoxDecoration(
                      color: Color(0xFFCBD5E1),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text(
                        '?',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  // Heart Toggle Button
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isFavorite = !_isFavorite;
                      });
                    },
                    child: Icon(
                      _isFavorite ? Icons.favorite : LucideIcons.heart,
                      size: 18,
                      color: _isFavorite
                          ? const Color(0xFFEF4444)
                          : const Color(0xFF94A3B8),
                    ),
                  ),
                  const Spacer(),

                  // Rating
                  Text(
                    '${_detail.rating} ',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF334155),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => const Icon(
                        Icons.star,
                        size: 14,
                        color: Color(0xFFEAB308),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // --- D. Variant Capacity & Perks Card ---
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dung tích',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  if (_selectedCapacity != null)
                    RichText(
                      text: TextSpan(
                        children: [
                          const TextSpan(
                            text: 'Đã chọn: ',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          TextSpan(
                            text: _selectedCapacity,
                            style: const TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Capacity Chips (Initially None Selected)
              Row(
                children: _detail.capacityOptions
                    .map((cap) => _buildCapacityChip(cap))
                    .toList(),
              ),
              const SizedBox(height: 12),

              // Shipping & Return Perks
              Row(
                children: const [
                  Icon(
                    LucideIcons.truck,
                    size: 16,
                    color: Color(0xFF0284C7),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Miễn phí vận chuyển',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: const [
                  Icon(
                    LucideIcons.refreshCw,
                    size: 15,
                    color: Color(0xFF0284C7),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Miễn phí đổi trả trong vòng 15 ngày',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0284C7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        // --- E. Voucher Section (Mã giảm giá) ---
        Container(
          width: double.infinity,
          color: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.ticket,
                size: 16,
                color: AppColors.primary,
              ),
              const SizedBox(width: 8),
              const Text(
                'Mã giảm giá',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF334155),
                ),
              ),
              const Spacer(),

              // Voucher Tag Chips
              Row(
                children: _detail.vouchers.map((v) {
                  return Container(
                    margin: const EdgeInsets.only(right: 4),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF2F2),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: const Color(0xFFFECACA),
                        width: 0.8,
                      ),
                    ),
                    child: Text(
                      v,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFEF4444),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(width: 4),
              const Icon(
                LucideIcons.chevronRight,
                size: 16,
                color: Color(0xFF94A3B8),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),
      ],
    );

    if (widget.scrollController != null) {
      return SingleChildScrollView(
        controller: widget.scrollController,
        child: content,
      );
    }

    return content;
  }
}

class _OverviewVideoItemWidget extends StatefulWidget {
  final String videoUrl;
  final String thumbUrl;
  final bool isCurrentPage;
  final bool isMuted;
  final VoidCallback onOpenFullscreen;

  const _OverviewVideoItemWidget({
    required this.videoUrl,
    required this.thumbUrl,
    required this.isCurrentPage,
    required this.isMuted,
    required this.onOpenFullscreen,
  });

  @override
  State<_OverviewVideoItemWidget> createState() =>
      _OverviewVideoItemWidgetState();
}

class _OverviewVideoItemWidgetState extends State<_OverviewVideoItemWidget> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((_) {
        if (mounted) {
          _controller?.seekTo(Duration.zero);
          _controller?.setLooping(true);
          _controller?.setVolume(widget.isMuted ? 0.0 : 1.0);
          setState(() {
            _isInitialized = true;
          });
        }
      });
  }

  @override
  void didUpdateWidget(covariant _OverviewVideoItemWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_controller != null && _isInitialized) {
      if (oldWidget.isMuted != widget.isMuted) {
        _controller?.setVolume(widget.isMuted ? 0.0 : 1.0);
      }
      if (!widget.isCurrentPage && _isPlaying) {
        _controller?.pause();
        setState(() => _isPlaying = false);
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _handleVideoTap() {
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
      onTap: _handleVideoTap,
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
            Image.network(
              widget.thumbUrl,
              fit: BoxFit.cover,
            ),

          if (!_isPlaying) ...[
            Container(
              color: Colors.black.withValues(alpha: 0.25),
            ),
            Center(
              child: Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TrophyIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _TrophyIcon({
    this.size = 17,
    this.color = const Color(0xFF087A34),
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _TrophyPainter(color: color),
      ),
    );
  }
}

class _TrophyPainter extends CustomPainter {
  final Color color;

  _TrophyPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final scaleX = size.width / 24.0;
    final scaleY = size.height / 24.0;

    canvas.scale(scaleX, scaleY);

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    // Cup body: M7 4h10v4a5 5 0 0 1-10 0V4Z
    final cupPath = Path();
    cupPath.moveTo(7, 4);
    cupPath.lineTo(17, 4);
    cupPath.lineTo(17, 8);
    cupPath.arcToPoint(
      const Offset(7, 8),
      radius: const Radius.circular(5),
      clockwise: true,
    );
    cupPath.close();

    canvas.drawPath(cupPath, fillPaint);
    canvas.drawPath(cupPath, strokePaint);

    // Stem and base: M8 21h8M12 17v4
    final baseLine = Path()
      ..moveTo(8, 21)
      ..lineTo(16, 21)
      ..moveTo(12, 17)
      ..lineTo(12, 21);
    canvas.drawPath(baseLine, strokePaint);

    // Handles: M7 6H4v2a4 4 0 0 0 4 4 M17 6h3v2a4 4 0 0 1-4 4
    final handlesPath = Path();
    // Left handle
    handlesPath.moveTo(7, 6);
    handlesPath.lineTo(4, 6);
    handlesPath.lineTo(4, 8);
    handlesPath.arcToPoint(
      const Offset(8, 12),
      radius: const Radius.circular(4),
      clockwise: false,
    );
    // Right handle
    handlesPath.moveTo(17, 6);
    handlesPath.lineTo(20, 6);
    handlesPath.lineTo(20, 8);
    handlesPath.arcToPoint(
      const Offset(16, 12),
      radius: const Radius.circular(4),
      clockwise: true,
    );

    canvas.drawPath(handlesPath, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _TrophyPainter oldDelegate) =>
      oldDelegate.color != color;
}
