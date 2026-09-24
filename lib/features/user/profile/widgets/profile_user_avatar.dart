import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/auth/models/user_model.dart';
import 'package:hiweb_app_management/features/auth/services/auth_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';

class ProfileUserAvatar extends StatelessWidget {
  final UserModel user;

  const ProfileUserAvatar({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final avatarUrl = user.avatarUrl;
    final initialLetter =
        user.fullName.isNotEmpty
            ? user.fullName.split(' ').last.substring(0, 1).toUpperCase()
            : 'T';

    return GestureDetector(
      onTap: () => _showAvatarPickerModal(context),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Outer cyan ring with inner white border space
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 1.8),
            ),
            padding: const EdgeInsets.all(2.5),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFBE3C5),
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child:
                    avatarUrl != null && avatarUrl.isNotEmpty
                        ? (avatarUrl.startsWith('http')
                            ? Image.network(
                              avatarUrl,
                              width: 57,
                              height: 57,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _buildInitialAvatarText(initialLetter),
                            )
                            : Image.file(
                              File(avatarUrl),
                              width: 57,
                              height: 57,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _buildInitialAvatarText(initialLetter),
                            ))
                        : _buildInitialAvatarText(initialLetter),
              ),
            ),
          ),

          // Camera Badge at Bottom Right
          Positioned(
            bottom: -1,
            right: -1,
            child: Container(
              width: 21,
              height: 21,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 1.5),
              ),
              child: const Center(
                child: Icon(LucideIcons.camera, size: 11, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInitialAvatarText(String letter) {
    return Center(
      child: Text(
        letter,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF8B5A2B),
        ),
      ),
    );
  }

  void _showAvatarPickerModal(BuildContext context) {
    AppBottomSheet.show(
      context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Đổi ảnh đại diện',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 16),

                // Option 1: Chụp ảnh (Camera)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.camera,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Chụp ảnh',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  subtitle: const Text(
                    'Mở camera của điện thoại',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatarImage(context, ImageSource.camera);
                  },
                ),
                const Divider(height: 1, color: Color(0xFFF1F5F9)),

                // Option 2: Tải ảnh lên (Gallery)
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE0F2FE),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      LucideIcons.image,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                  title: const Text(
                    'Tải ảnh lên',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF334155),
                    ),
                  ),
                  subtitle: const Text(
                    'Mở thư viện ảnh của điện thoại',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickAvatarImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _pickAvatarImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? file = await picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (file != null) {
        AuthService.instance.updateAvatar(file.path);
        if (!context.mounted) return;
        TopNotification.show(
          context,
          message: 'Đã cập nhật ảnh đại diện mới!',
          isError: false,
        );
      }
    } catch (e) {
      debugPrint('Error picking avatar image: $e');
      if (!context.mounted) return;
      TopNotification.show(
        context,
        message: 'Lỗi mở thư viện/camera: $e',
        isError: true,
      );
    }
  }
}
