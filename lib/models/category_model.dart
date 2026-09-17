import 'package:flutter/material.dart';

class CategoryModel {
  final String id;
  final String title;
  final String emoji;
  final IconData? icon;
  final Color? bgColor;
  final Color? iconColor;

  const CategoryModel({
    required this.id,
    required this.title,
    required this.emoji,
    this.icon,
    this.bgColor,
    this.iconColor,
  });

  static const List<CategoryModel> mockCategories = [
    CategoryModel(id: 'c1', emoji: '💊', title: 'Y tế'),
    CategoryModel(id: 'c2', emoji: '✨', title: 'Làm đẹp'),
    CategoryModel(id: 'c3', emoji: '💄', title: 'Mỹ phẩm'),
    CategoryModel(id: 'c4', emoji: '👶', title: 'Mẹ & bé'),
    CategoryModel(id: 'c5', emoji: '👕', title: 'Thời trang'),
  ];
}
