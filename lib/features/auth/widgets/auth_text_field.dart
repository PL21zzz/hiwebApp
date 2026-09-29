import 'package:flutter/material.dart';
import 'auth_input_decoration.dart';

class AuthTextField extends StatelessWidget {
  final String? label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final String? errorText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final double verticalPadding;
  final double labelFontSize;
  final double inputFontSize;

  const AuthTextField({
    super.key,
    this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.errorText,
    this.onTap,
    this.onChanged,
    this.verticalPadding = 10.0,
    this.labelFontSize = 13.5,
    this.inputFontSize = 13.5,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: labelFontSize,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF334155),
            ),
          ),
          const SizedBox(height: 2),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onTap: onTap,
          onChanged: onChanged,
          style: TextStyle(
            fontSize: inputFontSize,
            color: const Color(0xFF1E293B),
          ),
          decoration: buildAuthInputDecoration(
            hintText: hintText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            errorText: errorText,
            verticalPadding: verticalPadding,
          ),
        ),
      ],
    );
  }
}
