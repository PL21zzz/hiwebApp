import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color iconColor;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.iconColor,
  });
}
