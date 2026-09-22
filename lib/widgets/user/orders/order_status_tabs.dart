import 'package:flutter/material.dart';

class OrderStatusTab {
  final String id;
  final String label;
  final int count;

  const OrderStatusTab({
    required this.id,
    required this.label,
    required this.count,
  });
}

class OrderStatusTabs extends StatefulWidget {
  final List<OrderStatusTab> tabs;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  const OrderStatusTabs({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onSelected,
  });

  @override
  State<OrderStatusTabs> createState() => _OrderStatusTabsState();
}

class _OrderStatusTabsState extends State<OrderStatusTabs> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToTab(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(covariant OrderStatusTabs oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _scrollToTab(widget.selectedIndex);
    }
  }

  void _scrollToTab(int index) {
    if (!_scrollController.hasClients) return;
    // Calculate approximate offset to bring selected tab towards center
    const itemEstimatedWidth = 110.0;
    final targetOffset = (index * itemEstimatedWidth) - 100.0;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: ListView.builder(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: widget.tabs.length,
        itemBuilder: (context, index) {
          final isSelected = index == widget.selectedIndex;
          final tab = widget.tabs[index];

          return InkWell(
            onTap: () {
              widget.onSelected(index);
              _scrollToTab(index);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: isSelected ? const Color(0xFF0097B2) : Colors.transparent,
                    width: 2.5,
                  ),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tab.label,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: isSelected ? const Color(0xFF0097B2) : const Color(0xFF64748B),
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF0097B2).withValues(alpha: 0.1)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${tab.count}',
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                        color: isSelected ? const Color(0xFF0097B2) : const Color(0xFF94A3B8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
