import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../auth/auth_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    final authController = Get.find<AuthController>();
    final user = authController.currentUser.value;
    _nameController = TextEditingController(text: user?.name ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      final authController = Get.find<AuthController>();
      authController.updateProfile(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
      );
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Edit Profile'),
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
                const Text(
                  'Personal Information',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.charcoal,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Manage your identity and direct communication channels.',
                  style: TextStyle(fontSize: 13.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),

                // Name
                CustomTextField(
                  label: 'Full Name',
                  hintText: 'Your legal or display name',
                  controller: _nameController,
                  prefixIcon: const Icon(Icons.person_outline_rounded, size: 20, color: AppColors.textMuted),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Phone
                CustomTextField(
                  label: 'Phone Number',
                  hintText: '+1 (555) 000-0000',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(Icons.phone_outlined, size: 20, color: AppColors.textMuted),
                ),
                const SizedBox(height: 16),

                // Email (Read-only)
                CustomTextField(
                  label: 'Email Address (Verified)',
                  hintText: 'Your email address',
                  controller: _emailController,
                  enabled: false,
                  prefixIcon: const Icon(Icons.mail_outline_rounded, size: 20, color: AppColors.textMuted),
                ),
                const SizedBox(height: 32),

                // Save Changes Button
                Obx(
                  () => CustomButton(
                    text: 'Save Changes',
                    isLoading: authController.isLoading.value,
                    onPressed: _submit,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
