import 'package:flutter/material.dart';

class RegisterPasswordNote extends StatelessWidget {
  final bool isCompact;

  const RegisterPasswordNote({
    super.key,
    required this.isCompact,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: isCompact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(6),
      ),
      child: const Text(
        'Ít nhất 8 ký tự, gồm chữ thường, chữ hoa, số và ký tự đặc biệt @\$%^*&.',
        style: TextStyle(
          fontSize: 11.5,
          color: Color(0xFF64748B),
          height: 1.25,
        ),
      ),
    );
  }
}
