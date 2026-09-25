import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/support/models/support_request_model.dart';
import 'package:hiweb_app_management/features/user/support/services/support_request_service.dart';
import 'package:hiweb_app_management/core/theme/app_colors.dart';
import 'package:hiweb_app_management/core/widgets/common/cards/reusable_info_card.dart';
import 'package:hiweb_app_management/core/widgets/common/layout/vietmade_header.dart';
import 'package:hiweb_app_management/features/user/support/widgets/support_request_modal.dart';

class SupportRequestScreen extends StatelessWidget {
  const SupportRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: const VietmadeHeader(showMenu: false),
      body: Column(
        children: [
          // Sub-Header bar ("< Hỗ trợ / Yêu cầu")
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(
                      LucideIcons.chevronLeft,
                      size: 22,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                const Text(
                  'Hỗ trợ / Yêu cầu',
                  style: TextStyle(
                    fontSize: 16.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Content Card
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: ListenableBuilder(
                      listenable: SupportRequestService.instance,
                      builder: (context, child) {
                        final requests = SupportRequestService.instance.requests;
                        final isEmpty = requests.isEmpty;

                        return ReusableInfoCard(
                        title: 'Yêu cầu hỗ trợ',
                        titleIcon: LucideIcons.headphones,
                        headerNote: 'Theo dõi & xử lý các yêu cầu hỗ trợ của bạn',
                        emptyCustomIcon: Container(
                          width: 52,
                          height: 52,
                          decoration: const BoxDecoration(
                            color: Color(0xFFFEF08A),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              LucideIcons.ticket,
                              size: 26,
                              color: Color(0xFFD97706),
                            ),
                          ),
                        ),
                        emptyTitle: 'Bạn chưa có yêu cầu hỗ trợ nào',
                        emptySubtitle:
                            'Gặp vấn đề với đơn hàng hay tài khoản? Tạo yêu cầu để được hỗ trợ.',
                        buttonText: 'Tạo yêu cầu hỗ trợ',
                        onButtonPressed: () => SupportRequestModal.show(context),
                        isEmpty: isEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...requests.map((request) => _buildRequestItem(request)),
                            const SizedBox(height: 14),

                            // Bottom Add Button
                            ElevatedButton(
                              onPressed: () => SupportRequestModal.show(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                minimumSize: const Size(double.infinity, 44),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                '+ Tạo yêu cầu hỗ trợ',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestItem(SupportRequestModel request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: request.type == 'order'
                      ? const Color(0xFFFEF3C7)
                      : const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  request.typeLabel,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: request.type == 'order'
                        ? const Color(0xFFD97706)
                        : const Color(0xFF7C3AED),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                request.createdAt,
                style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            request.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            request.content,
            style: const TextStyle(
              fontSize: 12.5,
              color: Color(0xFF475569),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE0F2FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  request.status,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0284C7),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
