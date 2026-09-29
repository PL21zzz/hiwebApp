import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/product/models/flash_sale_model.dart';

class FlashSaleTimeSlots extends StatelessWidget {
  final List<FlashSaleSlotInfo> availableSlots;
  final int selectedSlotIndex;
  final ValueChanged<int> onSlotSelected;

  const FlashSaleTimeSlots({
    super.key,
    required this.availableSlots,
    required this.selectedSlotIndex,
    required this.onSlotSelected,
  });

  Widget _buildTimeSlotTab(int tabIndex) {
    if (tabIndex >= availableSlots.length) {
      return Expanded(
        child: Container(
          color: const Color(0xFF33373D),
        ),
      );
    }

    final slot = availableSlots[tabIndex];
    final nowHour = DateTime.now().hour;
    final isSelected = selectedSlotIndex == tabIndex;

    final isLive = nowHour >= slot.startHour && nowHour < slot.endHour;
    final statusText = isLive ? 'Đang diễn ra' : 'Sắp diễn ra';

    return Expanded(
      child: GestureDetector(
        onTap: () => onSlotSelected(tabIndex),
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

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      color: const Color(0xFF2B2F33),
      child: Row(
        children: [
          for (int i = 0; i < availableSlots.length; i++) ...[
            if (i > 0)
              Container(width: 1, color: const Color(0xFF404448)),
            _buildTimeSlotTab(i),
          ],
        ],
      ),
    );
  }
}
