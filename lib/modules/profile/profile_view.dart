import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import '../auth/auth_controller.dart';
import '../main/navigation_controller.dart';
import 'profile_controller.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProfileController());
    final authController = Get.find<AuthController>();
    final navController = Get.find<NavigationController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text(
          'Account & Sanctuary',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
          ),
        ),
      ),
      body: Obx(() {
        final user = authController.currentUser.value;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
          child: Column(
            children: [
              // User Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                  border: Border.all(color: AppColors.border),
                  boxShadow: AppTheme.softShadow,
                ),
                child: Row(
                  children: [
                    // Avatar
                    Container(
                      width: 68,
                      height: 68,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.creamSubtle,
                      ),
                      child: ClipOval(
                        child: user?.avatarUrl != null
                            ? NetworkImageWithFallback(
                                imageUrl: user!.avatarUrl!,
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.person_outline_rounded,
                                size: 36,
                                color: AppColors.charcoal,
                              ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name & Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.name ?? 'Guest Collector',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: AppColors.charcoal,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            user?.email ?? 'Sign in to sync your bag and orders',
                            style: const TextStyle(
                              fontSize: 12.5,
                              color: AppColors.textSecondary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (user?.phone != null) ...[
                            const SizedBox(height: 2),
                            Text(
                              user!.phone!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Edit Profile Icon
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.charcoal),
                      onPressed: () {
                        if (user != null) {
                          Get.toNamed('/edit-profile');
                        } else {
                          Get.toNamed('/login');
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Orders & Wishlist Shortcuts Grid
              Row(
                children: [
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.inventory_2_outlined,
                      title: 'Order History',
                      subtitle: 'Track shipments',
                      onTap: () => Get.toNamed('/order-history'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildMetricTile(
                      icon: Icons.favorite_border_rounded,
                      title: 'Wishlist',
                      subtitle: '${controller.wishlistController.wishlistIds.length} items saved',
                      onTap: () => navController.goToWishlist(),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Account Options Section
              _buildMenuSection(
                title: 'Preferences & Shipping',
                items: [
                  _buildMenuItem(
                    icon: Icons.location_on_outlined,
                    title: 'Shipping Addresses',
                    subtitle: '${user?.addresses.length ?? 0} saved addresses',
                    onTap: () => Get.toNamed('/manage-addresses'),
                  ),
                  _buildThemeToggleItem(controller),
                  _buildMenuItem(
                    icon: Icons.credit_card_outlined,
                    title: 'Payment Methods',
                    subtitle: 'Apple Pay, Visa ending 4242',
                    onTap: () {
                      Get.snackbar(
                        'Payment Methods',
                        'Default card ending in 4242 is active.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.charcoal,
                        colorText: AppColors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                  ),
                  _buildMenuItem(
                    icon: Icons.notifications_none_rounded,
                    title: 'Notification Preferences',
                    subtitle: 'Shipment alerts & editorial releases',
                    onTap: () {
                      Get.snackbar(
                        'Notifications',
                        'All tracking notifications are currently enabled.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.charcoal,
                        colorText: AppColors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Support Section
              _buildMenuSection(
                title: 'About Lumina',
                items: [
                  _buildMenuItem(
                    icon: Icons.eco_outlined,
                    title: 'Sustainability & Materials',
                    subtitle: '100% carbon-neutral packaging',
                    onTap: () => _showSustainabilityDialog(),
                  ),
                  _buildMenuItem(
                    icon: Icons.help_outline_rounded,
                    title: 'Concierge & Help Center',
                    subtitle: 'Direct support & warranty inquiries',
                    onTap: () {
                      Get.snackbar(
                        'Lumina Concierge',
                        'Available 24/7 at concierge@lumina.design',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: AppColors.charcoal,
                        colorText: AppColors.white,
                        margin: const EdgeInsets.all(16),
                        borderRadius: 12,
                      );
                    },
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Log Out / Sign In Button
              if (authController.isLoggedIn.value)
                ListTile(
                  tileColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  leading: const Icon(Icons.logout_rounded, color: AppColors.danger),
                  title: const Text(
                    'Sign Out',
                    style: TextStyle(
                      color: AppColors.danger,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: AppColors.white,
                        title: const Text('Sign Out'),
                        content: const Text('Are you sure you want to sign out of your Lumina account?'),
                        actions: [
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                          ),
                          TextButton(
                            onPressed: () {
                              Get.back();
                              controller.logout();
                            },
                            child: const Text('Sign Out', style: TextStyle(color: AppColors.danger)),
                          ),
                        ],
                      ),
                    );
                  },
                )
              else
                ListTile(
                  tileColor: AppColors.charcoal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                  ),
                  leading: const Icon(Icons.login_rounded, color: AppColors.white),
                  title: const Text(
                    'Sign In / Create Account',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14.5,
                    ),
                  ),
                  onTap: () => Get.toNamed('/login'),
                ),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  '${AppConstants.appName} v1.0.0 • Portfolio Edition',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildMetricTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: AppColors.border),
          boxShadow: AppTheme.softShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.creamSubtle,
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Icon(icon, color: AppColors.charcoal, size: 20),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.charcoal,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11.5,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: AppColors.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusMd),
            border: Border.all(color: AppColors.border),
            boxShadow: AppTheme.softShadow,
          ),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: AppColors.charcoal, size: 22),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.charcoal,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
      ),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      onTap: onTap,
    );
  }

  Widget _buildThemeToggleItem(ProfileController controller) {
    return Obx(
      () => ListTile(
        leading: Icon(
          controller.themeController.isDarkMode.value
              ? Icons.dark_mode_outlined
              : Icons.light_mode_outlined,
          color: AppColors.charcoal,
          size: 22,
        ),
        title: const Text(
          'Dark Mode Appearance',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.charcoal,
          ),
        ),
        subtitle: Text(
          controller.themeController.isDarkMode.value
              ? 'Warm Charcoal Theme'
              : 'Cream & Linen Light Theme',
          style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
        ),
        trailing: Switch(
          value: controller.themeController.isDarkMode.value,
          activeThumbColor: AppColors.rose,
          onChanged: (_) => controller.themeController.toggleTheme(),
        ),
      ),
    );
  }

  void _showSustainabilityDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.white,
        title: const Text(
          'The Lumina Manifesto',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
        content: const Text(
          'We believe beauty and environmental stewardship must coexist. Every material is traced to verified ethical suppliers: FSC-certified hardwoods, 100% recycled anodized aluminum, and vegetable-tanned full-grain leathers.',
          style: TextStyle(fontSize: 14, height: 1.5, color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close', style: TextStyle(color: AppColors.charcoal)),
          ),
        ],
      ),
    );
  }
}
