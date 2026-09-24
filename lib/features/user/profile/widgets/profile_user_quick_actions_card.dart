import 'package:flutter/material.dart';
import 'package:hiweb_app_management/features/user/profile/models/profile_option_model.dart';
import 'package:hiweb_app_management/features/content/repositories/static_content_repository.dart';

class ProfileUserQuickActionsCard extends StatelessWidget {
  const ProfileUserQuickActionsCard({super.key});

  Widget _buildQuickActionItem(QuickActionOption option) {
    return Expanded(
      child: Column(
        children: [
          Image.asset(
            option.imageAsset,
            width: 32,
            height: 32,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) => Icon(option.icon, size: 28, color: const Color(0xFF0284C7)),
          ),
          const SizedBox(height: 5),
          Text(
            option.label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF475569),
              height: 1.2,
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
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: const StaticContentRepository().quickActions
            .map((action) => _buildQuickActionItem(action))
            .toList(),
      ),
    );
  }
}
