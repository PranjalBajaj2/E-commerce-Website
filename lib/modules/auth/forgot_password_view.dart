import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import 'auth_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = Get.find<AuthController>();
      authController.sendPasswordReset(_emailController.text.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Reset Password'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
                const Text(
                  'Recover Access',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Enter the email address tied to your Lumina account and we will dispatch a secure recovery link.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),

                // Email
                CustomTextField(
                  label: 'Email Address',
                  hintText: 'Enter your registered email',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20, color: AppColors.textMuted),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!GetUtils.isEmail(value.trim())) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSubmitted: (_) => _submit(),
                ),
                const SizedBox(height: 28),

                // Submit Button
                Obx(
                  () => CustomButton(
                    text: 'Send Recovery Link',
                    isLoading: authController.isLoading.value,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 16),

                // Cancel Button
                CustomButton(
                  text: 'Back to Sign In',
                  variant: ButtonVariant.outline,
                  onPressed: () => Get.back(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
