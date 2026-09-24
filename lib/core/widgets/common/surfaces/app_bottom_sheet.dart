import 'package:flutter/material.dart';

typedef AppBottomSheetBuilder = Widget Function(BuildContext context);

class AppBottomSheet {
  const AppBottomSheet._();

  static Future<T?> show<T>(
    BuildContext context, {
    required AppBottomSheetBuilder builder,
    bool isScrollControlled = true,
    bool isDismissible = false,
    bool enableDrag = false,
    bool useSafeArea = false,
    Color backgroundColor = Colors.transparent,
    double? maxHeight,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      useSafeArea: useSafeArea,
      backgroundColor: backgroundColor,
      builder: (sheetContext) {
        final content = builder(sheetContext);
        if (maxHeight == null) return content;
        return ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(sheetContext).height * maxHeight,
          ),
          child: content,
        );
      },
    );
  }
}
