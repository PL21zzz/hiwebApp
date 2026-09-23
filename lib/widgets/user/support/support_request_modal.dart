import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../models/user/support/support_request_model.dart';
import '../../../services/user/support_request_service.dart';
import '../../../theme/app_colors.dart';
import '../../common/dialogs/top_notification.dart';
import '../../common/dialogs/vietmade_modal_container.dart';

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

  Widget _buildStepper() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStepCircle(1, 'Chọn loại'),
            _buildStepLine(_currentStep >= 2),
            _buildStepCircle(2, 'Chi tiết'),
            _buildStepLine(_currentStep >= 3),
            _buildStepCircle(3, 'Gửi'),
          ],
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStepCircle(int stepNumber, String label) {
    final isActive = _currentStep == stepNumber;
    final isCompleted = _currentStep > stepNumber;

    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive
                ? Colors.white
                : (isCompleted ? AppColors.primary : const Color(0xFFF1F5F9)),
            border: Border.all(
              color: isActive || isCompleted
                  ? AppColors.primary
                  : const Color(0xFFCBD5E1),
              width: 1.8,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(LucideIcons.check, size: 14, color: Colors.white)
                : Text(
                    '$stepNumber',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isActive ? AppColors.primary : const Color(0xFF64748B),
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.primary : const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isFinished) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 16),
        color: isFinished ? AppColors.primary : const Color(0xFFE2E8F0),
      ),
    );
  }

  Widget _buildStep1() {
    return Column(
      children: [
        // Option 1: Về Đơn hàng
        GestureDetector(
          onTap: () => _selectType('order', 'Về Đơn hàng'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF59E0B),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.package,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Về Đơn hàng',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'Giao thiếu, hỏng, sai sản phẩm, đổi/trả... -> Người bán xử lý',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Option 2: Báo Lỗi
        GestureDetector(
          onTap: () => _selectType('bug', 'Báo Lỗi'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF8B5CF6),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Icon(
                      LucideIcons.cog,
                      size: 22,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Báo Lỗi',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        'App/web lỗi, đăng nhập, thanh toán, tài khoản... -> VietMade xử lý',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF64748B),
                          height: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  LucideIcons.chevronRight,
                  size: 18,
                  color: Color(0xFFCBD5E1),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Selected type summary badge
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _selectedType == 'order'
                      ? const Color(0xFFF59E0B)
                      : const Color(0xFF8B5CF6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    _selectedType == 'order'
                        ? LucideIcons.package
                        : LucideIcons.cog,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Loại yêu cầu',
                    style: TextStyle(fontSize: 10.5, color: Color(0xFF64748B)),
                  ),
                  Text(
                    _selectedTypeLabel ?? '',
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Tiêu đề
        const Text(
          'Tiêu đề',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: Center(
            child: TextField(
              controller: _titleController,
              style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
              decoration: const InputDecoration(
                hintText: 'Ví dụ: Đơn hàng giao thiếu sản phẩm',
                hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                border: InputBorder.none,
                isDense: true,
              ),
            ),
          ),
        ),
        const SizedBox(height: 14),

        // Nội dung cần hỗ trợ
        const Text(
          'Nội dung cần hỗ trợ',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF334155),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 110,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: TextField(
            controller: _contentController,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 13.5, color: Color(0xFF1E293B)),
            decoration: const InputDecoration(
              hintText: 'Mô tả chi tiết vấn đề bạn đang gặp...',
              hintStyle: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              isDense: true,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Bottom Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                icon: const Icon(LucideIcons.arrowLeft, size: 16),
                label: const Text('Quay lại'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: _goToStep3,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStep3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Summary Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Loại yêu cầu',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                _selectedTypeLabel ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Divider(height: 20, color: Color(0xFFE2E8F0)),

              const Text(
                'Tiêu đề',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                _titleController.text,
                style: const TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const Divider(height: 20, color: Color(0xFFE2E8F0)),

              const Text(
                'Nội dung',
                style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
              ),
              Text(
                _contentController.text,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF334155),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Bottom Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentStep = 2;
                  });
                },
                icon: const Icon(LucideIcons.arrowLeft, size: 16),
                label: const Text('Quay lại'),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  side: const BorderSide(color: Color(0xFFCBD5E1)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: _submitRequest,
                icon: const Icon(LucideIcons.send, size: 16, color: Colors.white),
                label: const Text(
                  'Gửi yêu cầu',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
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
        _buildStepper(),

        // Dynamic step view
        if (_currentStep == 1) _buildStep1(),
        if (_currentStep == 2) _buildStep2(),
        if (_currentStep == 3) _buildStep3(),
      ],
    );
  }
}
