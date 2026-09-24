import 'package:flutter/material.dart';

class MessageModel {
  final String id;
  final String shopName;
  final String avatarLetter;
  final Color avatarBgColor;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final bool isOnline;

  const MessageModel({
    required this.id,
    required this.shopName,
    required this.avatarLetter,
    required this.avatarBgColor,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.isOnline = false,
  });

  static const List<MessageModel> mockMessages = [
    MessageModel(
      id: 'm1',
      shopName: 'YoungFit Official Store',
      avatarLetter: 'Y',
      avatarBgColor: Color(0xFF0F5A6E),
      lastMessage: 'Dạ sản phẩm còn hàng ạ, anh/chị đặt giúp em nhé',
      time: '10:24',
      unreadCount: 2,
      isOnline: true,
    ),
    MessageModel(
      id: 'm2',
      shopName: 'Life Extension - Hồ Chí Minh',
      avatarLetter: 'L',
      avatarBgColor: Color(0xFFF59E0B),
      lastMessage: 'Bạn ơi, đơn hàng đã được giao cho vận chuyển',
      time: 'Hôm qua',
      unreadCount: 0,
      isOnline: false,
    ),
    MessageModel(
      id: 'm3',
      shopName: 'Orihiro Vietnam',
      avatarLetter: 'O',
      avatarBgColor: Color(0xFF22C55E),
      lastMessage: 'Cảm ơn bạn đã ủng hộ shop ạ 💖',
      time: '2 ngày',
      unreadCount: 0,
      isOnline: true,
    ),
    MessageModel(
      id: 'm4',
      shopName: 'Phương Thảo Pharmacy',
      avatarLetter: 'P',
      avatarBgColor: Color(0xFFA855F7),
      lastMessage: 'Shop đã gửi hàng rồi ạ, bạn theo dõi đơn nhé',
      time: '3 ngày',
      unreadCount: 1,
      isOnline: false,
    ),
    MessageModel(
      id: 'm5',
      shopName: 'Blackmores Vietnam',
      avatarLetter: 'B',
      avatarBgColor: Color(0xFFEC4899),
      lastMessage: 'Chào bạn, bạn cần hỗ trợ gì không ạ?',
      time: '5 ngày',
      unreadCount: 0,
      isOnline: true,
    ),
  ];
}
