import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:hiweb_app_management/features/user/support/models/support_request_model.dart';
import 'package:hiweb_app_management/features/user/support/services/support_request_service.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/top_notification.dart';
import 'package:hiweb_app_management/core/widgets/common/dialogs/vietmade_modal_container.dart';
import 'modal/support_stepper_header.dart';
import 'modal/support_step1_type_selector.dart';
import 'modal/support_step2_form.dart';
import 'modal/support_step3_summary.dart';

class SupportRequestModal extends StatefulWidget {
  const SupportRequestModal({super.key});

  static Future<void> show(BuildContext context) {
    return VietmadeModalContainer.show(
      context: context,
      title: 'Tạo yêu cầu hỗ trợ',
      headerIcon: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF08A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(
          LucideIcons.ticket,
          size: 16,
          color: Color(0xFFD97706),
        ),
      ),
      child: const SupportRequestModal(),
    );
  }

  @override
  State<SupportRequestModal> createState() => _SupportRequestModalState();
}

class _SupportRequestModalState extends State<SupportRequestModal> {
  int _currentStep = 1;
  String? _selectedType; // 'order' or 'bug'
  String? _selectedTypeLabel; // 'Về Đơn hàng' or 'Báo Lỗi'

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _selectType(String type, String label) {
    setState(() {
      _selectedType = type;
      _selectedTypeLabel = label;
      _currentStep = 2;
    });
  }

  void _goToStep3() {
    if (_titleController.text.trim().isEmpty) {
      TopNotification.show(context, message: 'Vui lòng nhập Tiêu đề', isError: true);
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      TopNotification.show(context, message: 'Vui lòng nhập Nội dung cần hỗ trợ', isError: true);
      return;
    }
    setState(() {
      _currentStep = 3;
    });
  }

  void _submitRequest() {
    final now = DateTime.now();
    final day = now.day.toString().padLeft(2, '0');
    final month = now.month.toString().padLeft(2, '0');
    final formattedDate = '$day/$month/${now.year}';

    final request = SupportRequestModel(
      id: 'req_${now.millisecondsSinceEpoch}',
      type: _selectedType ?? 'order',
      typeLabel: _selectedTypeLabel ?? 'Về Đơn hàng',
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      createdAt: formattedDate,
      status: 'Chờ xử lý',
    );

    SupportRequestService.instance.addRequest(request);
    Navigator.of(context).pop();
    TopNotification.show(
      context,
      message: 'Đã gửi yêu cầu hỗ trợ thành công!',
      isError: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Tạo yêu cầu hỗ trợ',
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        const Text(
          'Chọn loại yêu cầu, diễn thông tin và gửi — VietMade sẽ hỗ trợ bạn sớm nhất.',
          style: TextStyle(
            fontSize: 11.5,
            color: Color(0xFF64748B),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 16),

        // Stepper
        SupportStepperHeader(currentStep: _currentStep),

        // Dynamic step view
        if (_currentStep == 1)
          SupportStep1TypeSelector(onSelectType: _selectType),
        if (_currentStep == 2)
          SupportStep2Form(
            selectedType: _selectedType,
            selectedTypeLabel: _selectedTypeLabel,
            titleController: _titleController,
            contentController: _contentController,
            onBack: () => setState(() => _currentStep = 1),
            onNext: _goToStep3,
          ),
        if (_currentStep == 3)
          SupportStep3Summary(
            selectedTypeLabel: _selectedTypeLabel,
            titleText: _titleController.text,
            contentText: _contentController.text,
            onBack: () => setState(() => _currentStep = 2),
            onSubmit: _submitRequest,
          ),
      ],
    );
  }
}
