import 'package:flutter/material.dart';
import '../auth_text_field.dart';

class RegisterNameRow extends StatelessWidget {
  final TextEditingController lastNameController;
  final TextEditingController firstNameController;
  final String? lastNameError;
  final String? firstNameError;
  final VoidCallback onLastNameTap;
  final ValueChanged<String> onLastNameChanged;
  final VoidCallback onFirstNameTap;
  final ValueChanged<String> onFirstNameChanged;
  final double verticalInputPadding;

  const RegisterNameRow({
    super.key,
    required this.lastNameController,
    required this.firstNameController,
    this.lastNameError,
    this.firstNameError,
    required this.onLastNameTap,
    required this.onLastNameChanged,
    required this.onFirstNameTap,
    required this.onFirstNameChanged,
    required this.verticalInputPadding,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: AuthTextField(
            label: 'Họ và tên đệm',
            hintText: 'Nguyễn Văn',
            controller: lastNameController,
            errorText: lastNameError,
            onTap: onLastNameTap,
            onChanged: onLastNameChanged,
            verticalPadding: verticalInputPadding,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 1,
          child: AuthTextField(
            label: 'Tên',
            hintText: 'An',
            controller: firstNameController,
            errorText: firstNameError,
            onTap: onFirstNameTap,
            onChanged: onFirstNameChanged,
            verticalPadding: verticalInputPadding,
          ),
        ),
      ],
    );
  }
}
