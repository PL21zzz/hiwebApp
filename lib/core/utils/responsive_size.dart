import 'package:flutter/material.dart';

/// Helper extension for screen-size-aware responsive sizing and typography.
extension ResponsiveSize on BuildContext {
  /// Returns the screen width.
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Returns the screen height.
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Returns a scaling factor based on a standard 375.0px reference screen.
  /// Clamped between 1.0 (iPhone SE / Small Phone) and 1.25 (Pro Max / Tablets).
  double get scaleFactor => (screenWidth / 375.0).clamp(1.0, 1.25);

  /// Scales a base font size according to device screen width.
  double rFont(double baseSize) => baseSize * scaleFactor;

  /// Scales icon sizes, avatar radii, and element dimensions according to screen width.
  double rSize(double baseSize) => baseSize * scaleFactor;
}
