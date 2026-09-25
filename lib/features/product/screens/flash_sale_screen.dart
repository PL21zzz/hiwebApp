import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/product/models/flash_sale_model.dart';
import 'package:hiweb_app_management/features/product/models/product_model.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_footer.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'package:hiweb_app_management/features/auth/screens/login_screen.dart';
import 'package:hiweb_app_management/features/product/screens/product_detail_screen.dart';

import 'package:hiweb_app_management/core/widgets/common/loading/flash_sale_skeleton.dart';

class FlashSaleScreen extends StatefulWidget {
  const FlashSaleScreen({super.key});

  @override
  State<FlashSaleScreen> createState() => _FlashSaleScreenState();
}

class _FlashSaleScreenState extends State<FlashSaleScreen> {
  static const List<FlashSaleSlotInfo> _allDailySlots = FlashSaleModel.mockDailySlots;

  late List<FlashSaleSlotInfo> _availableSlots;
  int _selectedSlotIndex = 0;
  int _selectedCategoryIndex = 0;

  Timer? _timer;
  int _remainingSeconds = 0;
  bool _isCurrentSlotActive = true;
  bool _isLoading = true;

  final List<String> _categories = FlashSaleModel.mockCategories;

  @override
  void initState() {
    super.initState();
    _computeAvailableSlots();
    _startCountdownTimer();
    _simulateLoading();
  }

  Future<void> _simulateLoading() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 600));
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _computeAvailableSlots() {
    final now = DateTime.now();
    final hour = now.hour;

    // Filter out past slots whose endHour <= current hour
    final remaining = _allDailySlots.where((slot) => slot.endHour > hour).toList();

    if (remaining.isEmpty) {
      // If late at night after all slots, reset to full list for next day
      _availableSlots = List.from(_allDailySlots);
    } else {
      _availableSlots = remaining;
    }

    if (_selectedSlotIndex >= _availableSlots.length) {
      _selectedSlotIndex = 0;
    }
  }

  void _startCountdownTimer() {
    _updateTimer();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        _updateTimer();
      }
    });
  }

  void _updateTimer() {
    final now = DateTime.now();
    final hour = now.hour;

    // Dynamically check if available slots need updating (e.g. slot ended or midnight crossed)
    final remaining = _allDailySlots.where((slot) => slot.endHour > hour).toList();
    final newAvailable = remaining.isEmpty ? List<FlashSaleSlotInfo>.from(_allDailySlots) : remaining;

    bool slotsChanged = false;
    if (_availableSlots.length != newAvailable.length) {
      slotsChanged = true;
    } else {
      for (int i = 0; i < _availableSlots.length; i++) {
        if (_availableSlots[i].label != newAvailable[i].label) {
          slotsChanged = true;
          break;
        }
      }
    }

    if (slotsChanged) {
      _availableSlots = newAvailable;
      if (_selectedSlotIndex >= _availableSlots.length) {
        _selectedSlotIndex = 0;
      }
    }

    if (_availableSlots.isEmpty) return;

    final currentSlot = _availableSlots[
        _selectedSlotIndex < _availableSlots.length ? _selectedSlotIndex : 0];

    DateTime targetTime;

    if (hour >= currentSlot.startHour && hour < currentSlot.endHour) {
      // Current slot is live now -> count down to end time
      _isCurrentSlotActive = true;
      if (currentSlot.endHour == 24) {
        targetTime = DateTime(now.year, now.month, now.day + 1, 0, 0, 0);
      } else {
        targetTime = DateTime(
            now.year, now.month, now.day, currentSlot.endHour, 0, 0);
      }
    } else if (hour < currentSlot.startHour) {
      // Slot is upcoming today -> count down to start time
      _isCurrentSlotActive = false;
      targetTime = DateTime(now.year, now.month, now.day, currentSlot.startHour, 0, 0);
    } else {
      // Slot is tomorrow
      _isCurrentSlotActive = false;
      targetTime = DateTime(now.year, now.month, now.day + 1, currentSlot.startHour, 0, 0);
    }

    final diff = targetTime.difference(now).inSeconds;
    setState(() {
      _remainingSeconds = diff > 0 ? diff : 0;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  Widget _buildTimeSlotTab(int tabIndex) {
    if (tabIndex >= _availableSlots.length) {
      // Empty slot tab placeholder
      return Expanded(
        child: Container(
          color: const Color(0xFF33373D),
        ),
      );
    }

    final slot = _availableSlots[tabIndex];
    final nowHour = DateTime.now().hour;
    final isSelected = _selectedSlotIndex == tabIndex;

    final isLive = nowHour >= slot.startHour && nowHour < slot.endHour;
    final statusText = isLive ? 'Đang diễn ra' : 'Sắp diễn ra';

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSlotIndex = tabIndex;
            _updateTimer();
          });
        },
        child: Container(
          color: isSelected ? const Color(0xFFFF7300) : const Color(0xFF33373D),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                slot.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                statusText,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFFCBD5E1),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handlePurchaseAction() {
    TopNotification.show(
      context,
      message: 'Bạn phải đăng nhập để thêm sản phẩm vào giỏ hàng!',
      isError: true,
    );

    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginScreen(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
      (route) => false,
    );
  }

  Widget _buildProductCard(ProductModel item) {
    final isLive = _isCurrentSlotActive;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: item),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left: Image (Discount Badge ONLY shown if isLive == true)
            SizedBox(
              width: 95,
              height: 95,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: item.imageUrl.startsWith('http')
                        ? Image.network(
                          item.imageUrl,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        )
                        : Image.asset(
                          item.imageUrl,
                          width: 95,
                          height: 95,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.image, color: Colors.grey),
                          ),
                        ),
                  ),
                  if (isLive)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(6),
                            bottomLeft: Radius.circular(6),
                          ),
                        ),
                        child: Text(
                          '-${item.discountPercent}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // Right: Content Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    item.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // BÁN CHẠY Badge
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: const Text(
                      'BÁN CHẠY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.5,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Price Section
                  if (isLive) ...[
                    // Original Price
                    Text(
                      _formatPrice(item.originalPrice),
                      style: const TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFFA1A1AA),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    // Flash Sale Price
                    Text(
                      _formatPrice(item.price),
                      style: const TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ] else ...[
                    // Hidden Price for Upcoming Slot
                    const Text(
                      '???.000đ',
                      style: TextStyle(
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFE53935),
                      ),
                    ),
                  ],
                  const SizedBox(height: 6),

                  // Bottom Row: Progress / Status Bar & Action Button
                  Row(
                    children: [
                      // Progress Bar
                      Expanded(
                        child: Container(
                          height: 22,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFED7AA),
                            borderRadius: BorderRadius.circular(11),
                          ),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: isLive ? 0.75 : 0.45,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6A00),
                                    borderRadius: BorderRadius.circular(11),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  isLive
                                      ? 'ĐÃ BÁN ${item.soldCount}'
                                      : 'SẮP MỞ BÁN',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Button: Mua ngay (live) vs Chi tiết (upcoming)
                      ElevatedButton(
                        onPressed: () {
                          if (isLive) {
                            _handlePurchaseAction();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    ProductDetailScreen(product: item),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isLive
                              ? const Color(0xFFE53935)
                              : const Color(0xFFFF7300),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          minimumSize: Size.zero,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Text(
                          isLive ? 'Mua ngay' : 'Chi tiết',
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hours = _twoDigits(_remainingSeconds ~/ 3600);
    final minutes = _twoDigits((_remainingSeconds % 3600) ~/ 60);
    final seconds = _twoDigits(_remainingSeconds % 60);
    final statusTitle = _isCurrentSlotActive ? 'KẾT THÚC SAU' : 'BẮT ĐẦU SAU';

    final products = ProductModel.mockProducts;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFFEFCE8),
        body: Column(
          children: [
            // 1. Header Bar
            Container(
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 4,
                    right: 12,
                    top: 2,
                    bottom: 8,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(
                          LucideIcons.arrowLeft,
                          color: Colors.white,
                          size: 20,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Text(
                        'Flash Sale',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // 2. Countdown Banner (KẾT THÚC SAU / BẮT ĐẦU SAU)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    statusTitle,
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 14,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '$hours : $minutes : $seconds',
                    style: const TextStyle(
                      color: Color(0xFFE53935),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            // 3. Time Slots Bar (Dynamic 4 Slots)
            Container(
              height: 52,
              color: const Color(0xFF2B2F33),
              child: Row(
                children: [
                  for (int i = 0; i < _availableSlots.length; i++) ...[
                    if (i > 0)
                      Container(width: 1, color: const Color(0xFF404448)),
                    _buildTimeSlotTab(i),
                  ],
                ],
              ),
            ),

            // 4. Horizontal Category Scrollable Tabs Bar
            Container(
              height: 42,
              color: Colors.white,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategoryIndex = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: isSelected
                            ? const Border(
                                bottom: BorderSide(
                                  color: Color(0xFFE53935),
                                  width: 2.5,
                                ),
                              )
                            : null,
                      ),
                      child: Text(
                        _categories[index],
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.w500,
                          color: isSelected
                              ? const Color(0xFFE53935)
                              : const Color(0xFF475569),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 5. Product List + VietmadeFooter
            Expanded(
              child: RefreshIndicator(
                onRefresh: _simulateLoading,
                color: const Color(0xFFE53935),
                child: _isLoading
                    ? const FlashSaleListSkeleton(itemCount: 4)
                    : ListView.builder(
                        padding: EdgeInsets.zero,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: products.length + 1,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            return _buildProductCard(products[index]);
                          } else {
                            return Column(
                              children: [
                                Container(
                                  height: 120,
                                  color: AppColors.background,
                                ),
                                const VietmadeFooter(),
                              ],
                            );
                          }
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
