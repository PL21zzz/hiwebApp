import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class AppImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? fallbackBgColor;

  const AppImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.fallbackBgColor,
  });

  Widget _buildFallback(BuildContext context) {
    return errorWidget ??
        Container(
          width: width,
          height: height,
          color: fallbackBgColor ?? Colors.grey.shade200,
          child: const Center(
            child: Icon(
              LucideIcons.image,
              color: Colors.grey,
              size: 20,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    if (imageUrl.trim().isEmpty) {
      return _buildFallback(context);
    }

    final imageWidget = imageUrl.startsWith('http')
        ? Image.network(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildFallback(context),
          )
        : Image.asset(
            imageUrl,
            width: width,
            height: height,
            fit: fit,
            errorBuilder: (context, error, stackTrace) => _buildFallback(context),
          );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
