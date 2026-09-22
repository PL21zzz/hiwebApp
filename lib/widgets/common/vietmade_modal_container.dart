import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class VietmadeModalContainer extends StatelessWidget {
  final String title;
  final Widget? headerIcon;
  final Widget child;
  final double maxHeightRatio;

  const VietmadeModalContainer({
    super.key,
    required this.title,
    this.headerIcon,
    required this.child,
    this.maxHeightRatio = 0.9,
  });

  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    Widget? headerIcon,
    required Widget child,
    double maxHeightRatio = 0.9,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: VietmadeModalContainer(
          title: title,
          headerIcon: headerIcon,
          maxHeightRatio: maxHeightRatio,
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isAndroid = Theme.of(context).platform == TargetPlatform.android;
    final effectiveMaxHeightRatio = isAndroid ? (maxHeightRatio > 0.82 ? 0.82 : maxHeightRatio) : maxHeightRatio;

    return Container(
      margin: isAndroid ? const EdgeInsets.only(top: 44.0) : EdgeInsets.zero,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * effectiveMaxHeightRatio,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Header Icon (if any) + Title + Close button X
            Row(
              children: [
                if (headerIcon != null) ...[
                  headerIcon!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      LucideIcons.x,
                      size: 18,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFF1F5F9)),
            const SizedBox(height: 14),

            // Modal Body Content
            child,
          ],
        ),
      ),
    );
  }
}
