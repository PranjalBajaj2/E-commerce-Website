import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../data/models/address_model.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/custom_text_field.dart';
import '../../shared/widgets/empty_state_view.dart';
import '../auth/auth_controller.dart';

class ManageAddressesView extends StatelessWidget {
  const ManageAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const Text('Shipping Addresses'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () => _showAddressForm(context, null),
          ),
        ],
      ),
      body: Obx(() {
        final addresses = authController.currentUser.value?.addresses ?? [];

        if (addresses.isEmpty) {
          return EmptyStateView(
            icon: Icons.location_off_outlined,
            title: 'No Addresses Found',
            message: 'Add a verified shipping address for frictionless one-touch checkout.',
            buttonText: 'Add Address',
            onButtonPressed: () => _showAddressForm(context, null),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
          itemCount: addresses.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final addr = addresses[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                border: Border.all(
                  color: addr.isDefault ? AppColors.charcoal : AppColors.border,
                  width: addr.isDefault ? 1.5 : 1.0,
                ),
                boxShadow: AppTheme.softShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            addr.title.toLowerCase().contains('work') ||
                                    addr.title.toLowerCase().contains('studio')
                                ? Icons.business_rounded
                                : Icons.home_rounded,
                            size: 18,
                            color: AppColors.charcoal,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            addr.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.charcoal,
                            ),
                          ),
                          if (addr.isDefault) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.roseLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'DEFAULT',
                                style: TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.roseDeep,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      // Actions Popup
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.more_horiz_rounded, size: 20, color: AppColors.textMuted),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        ),
                        onSelected: (val) {
                          if (val == 'edit') {
                            _showAddressForm(context, addr);
                          } else if (val == 'default') {
                            authController.setDefaultAddress(addr.id);
                          } else if (val == 'delete') {
                            authController.deleteAddress(addr.id);
                          }
                        },
                        itemBuilder: (context) => [
                          if (!addr.isDefault)
                            const PopupMenuItem(
                              value: 'default',
                              child: Text('Set as Default'),
                            ),
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Edit Address'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete Address', style: TextStyle(color: AppColors.danger)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    addr.recipientName,
                    style: const TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    addr.formattedAddress,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    addr.phone,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        color: AppColors.white,
        child: SafeArea(
          child: CustomButton(
            text: 'Add New Address',
            icon: Icons.add_rounded,
            onPressed: () => _showAddressForm(context, null),
          ),
        ),
      ),
    );
  }

  void _showAddressForm(BuildContext context, AddressModel? existing) {
    final titleController = TextEditingController(text: existing?.title ?? 'Home');
    final nameController = TextEditingController(text: existing?.recipientName ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    final streetController = TextEditingController(text: existing?.street ?? '');
    final cityController = TextEditingController(text: existing?.city ?? '');
    final stateController = TextEditingController(text: existing?.state ?? '');
    final zipController = TextEditingController(text: existing?.postalCode ?? '');
    bool isDefault = existing?.isDefault ?? false;
    final formKey = GlobalKey<FormState>();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLg)),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          existing != null ? 'Edit Address' : 'New Shipping Address',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.charcoal,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close_rounded),
                          onPressed: () => Get.back(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'Label (e.g. Home, Studio)',
                      hintText: 'Home',
                      controller: titleController,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Recipient Full Name',
                      hintText: 'Eleanor Vance',
                      controller: nameController,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Street Address',
                      hintText: '123 Curated Lane, Apt 4B',
                      controller: streetController,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: CustomTextField(
                            label: 'City',
                            hintText: 'Portland',
                            controller: cityController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            label: 'State',
                            hintText: 'OR',
                            controller: stateController,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CustomTextField(
                            label: 'ZIP',
                            hintText: '97201',
                            controller: zipController,
                            keyboardType: TextInputType.number,
                            validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'Phone Number',
                      hintText: '+1 (555) 000-0000',
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: isDefault,
                      activeColor: AppColors.charcoal,
                      title: const Text(
                        'Set as default shipping address',
                        style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
                      ),
                      onChanged: (val) {
                        setModalState(() {
                          isDefault = val ?? false;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomButton(
                      text: existing != null ? 'Update Address' : 'Save Address',
                      onPressed: () {
                        if (formKey.currentState?.validate() ?? false) {
                          final newAddr = AddressModel(
                            id: existing?.id ?? 'addr-${DateTime.now().millisecondsSinceEpoch}',
                            title: titleController.text.trim(),
                            recipientName: nameController.text.trim(),
                            phone: phoneController.text.trim(),
                            street: streetController.text.trim(),
                            city: cityController.text.trim(),
                            state: stateController.text.trim(),
                            postalCode: zipController.text.trim(),
                            country: 'United States',
                            isDefault: isDefault,
                          );
                          final authController = Get.find<AuthController>();
                          authController.saveAddress(newAddr);
                          Get.back();
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
}
