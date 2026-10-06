import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_button.dart';
import '../core/widgets/sidebar_nav_item.dart';
import 'auth_screen.dart';
import 'dashboard_screen.dart';

/// Екран профілю користувача з бічною навігацією (як у Dashboard).
/// Ім'я та email хардкодні, зміна пароля — лише демонстраційна,
/// без реального збереження чи бекенду.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const String _userName = 'Мищатин Марія';
  static const String _userEmail = 'mariia.myshchatyn@gmail.com';
  static const String _userInitials = 'ММ';

  final _nameController = TextEditingController(text: _userName);
  final _emailController = TextEditingController(text: _userEmail);
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Профіль оновлено'),
        backgroundColor: AppColors.ink,
      ),
    );
  }

  void _changePassword() {
    if (_newPasswordController.text.trim().length < 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Новий пароль має містити щонайменше 5 символів'),
          backgroundColor: AppColors.red,
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Пароль змінено'),
        backgroundColor: AppColors.teal,
      ),
    );
    _oldPasswordController.clear();
    _newPasswordController.clear();
  }

  void _goToDashboard() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _showDemoSnackBar(String section) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Розділ "$section" (демо)'),
        backgroundColor: AppColors.ink,
      ),
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
            _ProfileSidebar(
              userName: _userName,
              userEmail: _userEmail,
              userInitials: _userInitials,
              onHomeTap: _goToDashboard,
              onNavTap: _showDemoSnackBar,
              onLogout: _logout,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Профіль',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Особисті дані та безпека',
                      style: TextStyle(fontSize: 13.5, color: AppColors.muted),
                    ),
                    const SizedBox(height: 22),

                    LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth > 700;
                        final personalCard = _PersonalDataCard(
                          initials: _userInitials,
                          nameController: _nameController,
                          emailController: _emailController,
                          onSave: _saveProfile,
                        );
                        final passwordCard = _PasswordCard(
                          oldPasswordController: _oldPasswordController,
                          newPasswordController: _newPasswordController,
                          onSubmit: _changePassword,
                        );
                        if (isWide) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(flex: 2, child: personalCard),
                              const SizedBox(width: 16),
                              Expanded(flex: 1, child: passwordCard),
                            ],
                          );
                        }
                        return Column(
                          children: [
                            personalCard,
                            const SizedBox(height: 16),
                            passwordCard,
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
}

/// Бічна панель для екрана профілю (копія з Dashboard, із пунктом
/// "Профіль" активним, а "Головна" веде назад на DashboardScreen).
class _ProfileSidebar extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userInitials;
  final VoidCallback onHomeTap;
  final void Function(String section) onNavTap;
  final VoidCallback onLogout;

  const _ProfileSidebar({
    required this.userName,
    required this.userEmail,
    required this.userInitials,
    required this.onHomeTap,
    required this.onNavTap,
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
            isActive: false,
            onTap: onHomeTap,
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
            isActive: true,
            onTap: () {},
          ),

          const Spacer(),

          // --- Міні-картка профілю ---
          Padding(
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

/// Картка "Особисті дані": аватар, зміна фото, ім'я, email, збереження.
class _PersonalDataCard extends StatelessWidget {
  final String initials;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onSave;

  const _PersonalDataCard({
    required this.initials,
    required this.nameController,
    required this.emailController,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppColors.accent,
                child: Text(
                  initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              OutlinedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Вибір фото (демо, без реалізації)'),
                      backgroundColor: AppColors.ink,
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.ink,
                  side: const BorderSide(color: AppColors.line),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(7),
                  ),
                ),
                child: const Text(
                  'змінити фото',
                  style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          AppTextField(label: "Ім'я", controller: nameController),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Email',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Зберегти зміни',
            fullWidth: false,
            onPressed: onSave,
          ),
        ],
      ),
    );
  }
}

/// Картка "Зміна пароля": поточний/новий пароль та кнопка оновлення.
class _PasswordCard extends StatelessWidget {
  final TextEditingController oldPasswordController;
  final TextEditingController newPasswordController;
  final VoidCallback onSubmit;

  const _PasswordCard({
    required this.oldPasswordController,
    required this.newPasswordController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.ink, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Зміна пароля',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          AppTextField(
            label: 'Поточний пароль',
            controller: oldPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 14),
          AppTextField(
            label: 'Новий пароль',
            controller: newPasswordController,
            obscureText: true,
          ),
          const SizedBox(height: 18),
          AppButton(
            label: 'Оновити пароль',
            style: AppButtonStyle.ghost,
            fullWidth: false,
            onPressed: onSubmit,
          ),
        ],
      ),
    );
  }
}