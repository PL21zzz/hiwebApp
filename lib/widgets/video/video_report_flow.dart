import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../models/video/video_report_model.dart';
import '../../theme/app_colors.dart';

class VideoReportFlow extends StatefulWidget {
  const VideoReportFlow({super.key});

  static Future<bool?> show(BuildContext context) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: false,
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
    final topInset = defaultTargetPlatform == TargetPlatform.iOS ? 0.0 : 24.0;
    final bottomInset = MediaQuery.viewPaddingOf(context).bottom;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        width: double.infinity,
        height: MediaQuery.sizeOf(context).height * 0.92,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              color: AppColors.primary,
              padding: EdgeInsets.only(top: topInset),
              child: _ReportHeader(
                title: isDetail ? _selectedReason! : 'Báo cáo video này',
                onBack:
                    isDetail
                        ? () => setState(() => _selectedReason = null)
                        : () => Navigator.of(context).pop(),
              ),
            ),
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
      padding: EdgeInsets.zero,
      itemCount: VideoReportMockData.reasons.length,
      separatorBuilder:
          (_, __) => const Divider(height: 1, color: Color(0xFFF1F5F9)),
      itemBuilder: (context, index) {
        return InkWell(
          onTap:
              () => setState(
                () => _selectedReason = VideoReportMockData.reasons[index],
              ),
          child: SizedBox(
            height: 59,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      VideoReportMockData.reasons[index],
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: Color(0xFF64748B),
                    size: 21,
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 17, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text.rich(
            TextSpan(
              text: 'Nhập mô tả báo cáo',
              style: TextStyle(
                fontSize: 12,
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
            maxLines: 5,
            maxLength: 50,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: 'Vui lòng nhập từ 10-50 ký tự',
              hintStyle: const TextStyle(
                fontSize: 10,
                color: Color(0xFF94A3B8),
              ),
              counterText: '$length/50',
              counterStyle: const TextStyle(
                fontSize: 8,
                color: Color(0xFF94A3B8),
              ),
              contentPadding: const EdgeInsets.fromLTRB(10, 11, 10, 6),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 0.8,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: SizedBox(
              width: 200,
              height: 31,
              child: ElevatedButton(
                onPressed: isValid ? _submit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: const Color(0xFF9DD9E8),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  'Gửi báo cáo',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
  final VoidCallback onBack;

  const _ReportHeader({required this.title, required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      color: AppColors.primary,
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 40, height: 40),
            icon: const Icon(Icons.chevron_left, color: Colors.white, size: 22),
          ),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
