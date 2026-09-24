import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/surfaces/app_bottom_sheet.dart';

class VideoReportFlow extends StatefulWidget {
  const VideoReportFlow({super.key});

  static Future<bool?> show(BuildContext context) {
    return AppBottomSheet.show<bool>(
      context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const VideoReportFlow(),
    );
  }

  @override
  State<VideoReportFlow> createState() => _VideoReportFlowState();
}

class _VideoReportFlowState extends State<VideoReportFlow> {
  String? _selectedReason;
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _submit() {
    final length = _descriptionController.text.trim().length;
    if (length < 10 || length > 50) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final isDetail = _selectedReason != null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      height: MediaQuery.sizeOf(context).height * 0.80,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Drag Handle Indicator
            const SizedBox(height: 8),
            Center(
              child: Container(
                width: 38,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFCBD5E1),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 4),

            // Clean White Header (Phương án B)
            _ReportHeader(
              title: isDetail ? _selectedReason! : 'Báo cáo video này',
              showBack: isDetail,
              onBack: () => setState(() => _selectedReason = null),
            ),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),

            // Content Section
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: isDetail ? _buildDetail(context) : _buildReasons(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasons() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 4),
      itemCount: const StaticContentRepository().videoReportReasons.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
      itemBuilder: (context, index) {
        return InkWell(
          onTap:
              () => setState(
                () =>
                    _selectedReason =
                        const StaticContentRepository()
                            .videoReportReasons[index],
              ),
          child: SizedBox(
            height: 52,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      const StaticContentRepository().videoReportReasons[index],
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF0F172A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Icon(
                    LucideIcons.chevronRight,
                    color: Color(0xFF94A3B8),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetail(BuildContext context) {
    final length = _descriptionController.text.trim().length;
    final isValid = length >= 10 && length <= 50;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Nhập mô tả báo cáo',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0F172A),
              ),
              children: [
                TextSpan(
                  text: ' *',
                  style: TextStyle(color: Color(0xFFEF4444)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            maxLength: 50,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Vui lòng nhập chi tiết từ 10-50 ký tự',
              hintStyle: const TextStyle(
                fontSize: 11,
                color: Color(0xFF94A3B8),
              ),
              counterText: '$length/50',
              counterStyle: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
              contentPadding: const EdgeInsets.all(12),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFCBD5E1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 42,
              child: ElevatedButton(
                onPressed: isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFFCBD5E1),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Gửi báo cáo',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReportHeader extends StatelessWidget {
  final String title;
  final bool showBack;
  final VoidCallback onBack;

  const _ReportHeader({
    required this.title,
    required this.showBack,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Row(
        children: [
          if (showBack)
            IconButton(
              onPressed: onBack,
              icon: const Icon(
                LucideIcons.chevronLeft,
                color: Color(0xFF1E293B),
                size: 20,
              ),
            )
          else
            const SizedBox(width: 46),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Color(0xFF0F172A),
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(
              LucideIcons.x,
              color: Color(0xFF64748B),
              size: 18,
            ),
          ),
        ],
      ),
    );
  }
}
