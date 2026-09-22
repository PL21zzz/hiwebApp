import 'package:flutter/material.dart';
import '../../../models/user/profile_option_model.dart';

class ProfileUserQuickActionsCard extends StatelessWidget {
  const ProfileUserQuickActionsCard({super.key});

  Widget _buildQuickActionItem(QuickActionOption option) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: Color(0xFFE0F2FE),
              shape: BoxShape.circle,
            ),
            child: Icon(option.icon, size: 20, color: const Color(0xFF0284C7)),
          ),
          const SizedBox(height: 8),
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
        children: ProfileMockData.quickActions
            .map((action) => _buildQuickActionItem(action))
            .toList(),
      ),
    );
  }
}
