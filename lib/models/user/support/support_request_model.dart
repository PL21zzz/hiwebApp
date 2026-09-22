import 'dart:convert';

class SupportRequestModel {
  final String id;
  final String type; // 'order' or 'bug'
  final String typeLabel; // 'Về Đơn hàng' or 'Báo Lỗi'
  final String title;
  final String content;
  final String createdAt;
  final String status; // 'Chờ xử lý', 'Đang xử lý', 'Đã xử lý'

  const SupportRequestModel({
    required this.id,
    required this.type,
    required this.typeLabel,
    required this.title,
    required this.content,
    required this.createdAt,
    this.status = 'Chờ xử lý',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'typeLabel': typeLabel,
      'title': title,
      'content': content,
      'createdAt': createdAt,
      'status': status,
    };
  }

  factory SupportRequestModel.fromMap(Map<String, dynamic> map) {
    return SupportRequestModel(
      id: map['id'] ?? '',
      type: map['type'] ?? '',
      typeLabel: map['typeLabel'] ?? '',
      title: map['title'] ?? '',
      content: map['content'] ?? '',
      createdAt: map['createdAt'] ?? '',
      status: map['status'] ?? 'Chờ xử lý',
    );
  }

  String toJson() => json.encode(toMap());

  factory SupportRequestModel.fromJson(String source) =>
      SupportRequestModel.fromMap(json.decode(source));
}
