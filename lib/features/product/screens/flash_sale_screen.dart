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
import 'package:hiweb_app_management/core/widgets/common/loading/skeletons.dart';
import '../widgets/flash_sale/flash_sale_countdown_banner.dart';
import '../widgets/flash_sale/flash_sale_time_slots.dart';
import '../widgets/flash_sale/flash_sale_category_bar.dart';
import '../widgets/flash_sale/flash_sale_product_card.dart';

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
    await Future.delayed(const Duration(milliseconds: 450));
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

  @override
  Widget build(BuildContext context) {
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
            FlashSaleCountdownBanner(
              isCurrentSlotActive: _isCurrentSlotActive,
              remainingSeconds: _remainingSeconds,
            ),

            // 3. Time Slots Bar (Dynamic 4 Slots)
            FlashSaleTimeSlots(
              availableSlots: _availableSlots,
              selectedSlotIndex: _selectedSlotIndex,
              onSlotSelected: (index) {
                setState(() {
                  _selectedSlotIndex = index;
                  _updateTimer();
                });
              },
            ),

            // 4. Horizontal Category Scrollable Tabs Bar
            FlashSaleCategoryBar(
              categories: _categories,
              selectedCategoryIndex: _selectedCategoryIndex,
              onCategorySelected: (index) {
                setState(() {
                  _selectedCategoryIndex = index;
                });
              },
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
                            return FlashSaleProductCard(
                              item: products[index],
                              isLive: _isCurrentSlotActive,
                              onPurchaseTap: _handlePurchaseAction,
                            );
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
