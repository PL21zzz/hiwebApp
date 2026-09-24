import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/user/profile/models/profile_option_model.dart';
import 'package:hiweb_app_management/features/user/support/screens/support_request_screen.dart';
import 'package:hiweb_app_management/features/user/voucher/screens/voucher_vault_screen.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';

class ProfileUserToolsGrid extends StatelessWidget {
  const ProfileUserToolsGrid({super.key});

  Widget _buildToolItem(BuildContext context, ToolServiceOption option) {
    return GestureDetector(
      onTap: () {
        if (option.id == 'support') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SupportRequestScreen(),
            ),
          );
        } else if (option.id == 'voucher_wallet') {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VoucherVaultScreen(),
            ),
          );
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            option.imageAsset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(option.icon, size: 28, color: const Color(0xFF0284C7)),
          ),
          const SizedBox(height: 4),
          Text(
            option.label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 10.5,
              color: Color(0xFF475569),
              height: 1.15,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Công cụ & Dịch vụ',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
            children: const StaticContentRepository().toolServices
                .map((tool) => _buildToolItem(context, tool))
                .toList(),
          ),
        ],
      ),
    );
  }
}
