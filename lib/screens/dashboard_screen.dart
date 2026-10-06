import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/sidebar_nav_item.dart';
import 'auth_screen.dart';
import 'profile_screen.dart';

/// Головний екран (Dashboard) з бічною навігацією, як у макеті:
/// темний сайдбар зліва (лоґо, меню, профіль, вихід) і контент праворуч
/// (статистика ремонту + швидкий перехід до розділів).
/// Дані хардкодні, без бекенду.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Хардкодні дані користувача та прогресу ремонту.
  static const String _userName = 'Мищатин Марія';
  static const String _userEmail = 'mariia.myshchatyn@gmail.com';
  static const String _userInitials = 'ММ';

  static const double _repairProgress = 0.30; // 30%
  static const int _stagesDone = 0;
  static const int _stagesTotal = 2;

  static const int _budgetSpent = 60000;
  static const int _budgetPlanned = 120000;

  static const int _materialsBought = 2;
  static const int _materialsTotal = 3;

  void _showDemoSnackBar(String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Розділ "$section" (демо)'),
        backgroundColor: AppColors.ink,
      ),
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Sidebar(
              userName: _userName,
              userEmail: _userEmail,
              userInitials: _userInitials,
              onNavTap: _showDemoSnackBar,
              onProfileTap: _openProfile,
              onLogout: _logout,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Головна',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Загальний стан вашого ремонту',
                      style: TextStyle(fontSize: 13.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 22),

                    // --- Статистичні картки ---
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final cards = [
                          _StatCard(
                            label: 'Прогрес ремонту',
                            value:
                                '${(_repairProgress * 100).round()}%',
                            progress: _repairProgress,
                            footer:
                                '$_stagesDone з $_stagesTotal етапів завершено',
                          ),
                          _StatCard(
                            label: 'Бюджет витрачено',
                            value: '${_formatMoney(_budgetSpent)} ₴',
                            progress: _budgetSpent / _budgetPlanned,
                            footer: 'з плану ${_formatMoney(_budgetPlanned)} ₴',
                          ),
                          _StatCard(
                            label: 'Матеріали куплено',
                            value: '$_materialsBought/$_materialsTotal',
                            progress: null,
                            footer: 'позицій зі списку закупівлі',
                          ),
                        ];
                        if (isWide) {
                          return Row(
                            children: [
                              for (int i = 0; i < cards.length; i++) ...[
                                Expanded(child: cards[i]),
                                if (i != cards.length - 1)
                                  const SizedBox(width: 16),
                              ],
                            ],
                          );
                        }
                        return Column(
                          children: [
                            for (final c in cards) ...[
                              c,
                              const SizedBox(height: 16),
                            ],
                          ],
                        );
                      },
                    ),

                    const SizedBox(height: 30),
                    const Text(
                      'Швидкий перехід',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 14),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final items = [
                          _QuickLinkCard(
                            icon: Icons.checklist_rounded,
                            title: 'Етапи ремонту',
                            onTap: () => _showDemoSnackBar('Етапи ремонту'),
                          ),
                          _QuickLinkCard(
                            icon: Icons.attach_money_rounded,
                            title: 'Кошторис',
                            onTap: () => _showDemoSnackBar('Кошторис'),
                          ),
                          _QuickLinkCard(
                            icon: Icons.grid_view_rounded,
                            title: 'Матеріали',
                            onTap: () => _showDemoSnackBar('Матеріали'),
                          ),
                        ];
                        if (isWide) {
                          return Row(
                            children: [
                              for (int i = 0; i < items.length; i++) ...[
                                Expanded(child: items[i]),
                                if (i != items.length - 1)
                                  const SizedBox(width: 16),
                              ],
                            ],
                          );
                        }
                        return Column(
                          children: [
                            for (final it in items) ...[
                              it,
                              const SizedBox(height: 12),
                            ],
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatMoney(int value) {
    final s = value.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buf.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buf.write(' ');
    }
    return buf.toString();
  }
}

/// Темна бічна панель навігації з лоґо, меню та профілем користувача.
class _Sidebar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userInitials;
  final void Function(String section) onNavTap;
  final VoidCallback onProfileTap;
  final VoidCallback onLogout;

  const _Sidebar({
    required this.userName,
    required this.userEmail,
    required this.userInitials,
    required this.onNavTap,
    required this.onProfileTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 248,
      color: AppColors.ink,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Лоґо ---
          Row(
            children: [
              Transform.rotate(
                angle: 0.78,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: AppColors.accent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'Кресля',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // --- Пункти меню ---
          SidebarNavItem(
            icon: Icons.home_rounded,
            label: 'Головна',
            isActive: true,
            onTap: () {},
          ),
          SidebarNavItem(
            icon: Icons.checklist_rounded,
            label: 'Етапи ремонту',
            isActive: false,
            onTap: () => onNavTap('Етапи ремонту'),
          ),
          SidebarNavItem(
            icon: Icons.attach_money_rounded,
            label: 'Кошторис',
            isActive: false,
            onTap: () => onNavTap('Кошторис'),
          ),
          SidebarNavItem(
            icon: Icons.grid_view_rounded,
            label: 'Матеріали',
            isActive: false,
            onTap: () => onNavTap('Матеріали'),
          ),
          SidebarNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Профіль',
            isActive: false,
            onTap: onProfileTap,
          ),

          const Spacer(),

          // --- Міні-картка профілю ---
          InkWell(
            onTap: onProfileTap,
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: AppColors.accent,
                    child: Text(
                      userInitials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          userEmail,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFFA9A297),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // --- Вийти ---
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: onLogout,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0x33FFFFFF)),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Вийти',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Картка статистики (прогрес, бюджет, матеріали) із заголовка,
/// великого значення, опціональним прогрес-баром та підписом.
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final double? progress;
  final String footer;

  const _StatCard({
    required this.label,
    required this.value,
    required this.progress,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: AppColors.muted),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress!.clamp(0.0, 1.0),
                minHeight: 8,
                backgroundColor: AppColors.line,
                valueColor: const AlwaysStoppedAnimation(AppColors.accent),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Text(
            footer,
            style: const TextStyle(fontSize: 12, color: AppColors.muted),
          ),
        ],
      ),
    );
  }
}

/// Картка швидкого переходу до розділу (Етапи, Кошторис, Матеріали).
class _QuickLinkCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickLinkCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.ink, width: 1.5),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppColors.ink, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Перейти до розділу',
                          style: TextStyle(
                            fontSize: 12.5,
                            color: AppColors.muted,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward_rounded,
                            size: 14, color: AppColors.muted),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}