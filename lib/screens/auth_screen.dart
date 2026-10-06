import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../core/widgets/app_text_field.dart';
import '../core/widgets/app_button.dart';
import 'dashboard_screen.dart';

/// Екран авторизації та реєстрації.
/// Перемикається між режимами "Вхід" / "Реєстрація" одним і тим самим
/// віджетом, а відновлення пароля показується як окремий діалог.
/// Бізнес-логіки немає: "Увійти" одразу відкриває DashboardScreen.
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;

  final _emailController = TextEditingController(text: 'olena@example.com');
  final _passwordController = TextEditingController(text: '12345');
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _openDashboard() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const DashboardScreen()),
    );
  }

  void _showForgotPasswordDialog() {
    final forgotEmailController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: AppColors.ink, width: 1.5),
        ),
        title: const Text('Відновлення пароля'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Введіть email — ми надішлемо посилання для скидання пароля.',
              style: TextStyle(fontSize: 13, color: AppColors.muted),
            ),
            const SizedBox(height: 14),
            AppTextField(
              label: 'Email',
              hint: 'you@mail.com',
              controller: forgotEmailController,
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Скасувати',
                style: TextStyle(color: AppColors.muted)),
          ),
          AppButton(
            label: 'Надіслати',
            fullWidth: false,
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Лист надіслано на ${forgotEmailController.text.isEmpty ? "вашу пошту" : forgotEmailController.text}',
                  ),
                  backgroundColor: AppColors.ink,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.paper,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 380),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 32),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.ink, width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: AppColors.ink,
                      offset: Offset(6, 6),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: const [
                        Text(
                          '◆', 
                          style: TextStyle(color: AppColors.accent, fontSize: 14),
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Кресля',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLogin
                          ? 'Вхід до планувальника ремонту'
                          : 'Створення нового акаунта',
                      style: const TextStyle(fontSize: 13, color: AppColors.muted),
                    ),
                    const SizedBox(height: 24),

                    if (!_isLogin) ...[
                      AppTextField(
                        label: "Ім'я",
                        hint: 'Ваше ім\'я',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 14),
                    ],

                    AppTextField(
                      label: 'Email',
                      hint: 'you@mail.com',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 14),
                    AppTextField(
                      label: 'Пароль',
                      hint: '••••••',
                      controller: _passwordController,
                      obscureText: true,
                    ),
                    const SizedBox(height: 20),

                    AppButton(
                      label: _isLogin ? 'Увійти' : 'Зареєструватися',
                      onPressed: _openDashboard,
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _isLogin = !_isLogin),
                          style: TextButton.styleFrom(padding: EdgeInsets.zero),
                          child: Text(
                            _isLogin ? 'Створити акаунт' : 'Вже маю акаунт',
                            style: const TextStyle(
                              color: AppColors.inkLight,
                              fontSize: 13,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                        if (_isLogin)
                          TextButton(
                            onPressed: _showForgotPasswordDialog,
                            style: TextButton.styleFrom(padding: EdgeInsets.zero),
                            child: const Text(
                              'Забули пароль?',
                              style: TextStyle(
                                color: AppColors.inkLight,
                                fontSize: 13,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}