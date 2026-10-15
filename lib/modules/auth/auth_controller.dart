import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/constants/app_constants.dart';
import '../../app/theme/app_colors.dart';
import '../../data/models/address_model.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/services/storage_service.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepo = Get.find<AuthRepository>();
  final StorageService _storage = Get.find<StorageService>();

  final Rx<UserModel?> currentUser = Rx<UserModel?>(null);
  final RxBool isLoggedIn = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool isOnboardingSeen = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initAuth();
  }

  Future<void> _initAuth() async {
    isOnboardingSeen.value = _storage.getBool(AppConstants.keyOnboardingSeen) ?? false;
    final user = await _authRepo.getCurrentUser();
    if (user != null) {
      currentUser.value = user;
      isLoggedIn.value = true;
    }
  }

  void completeOnboarding() {
    isOnboardingSeen.value = true;
    _storage.setBool(AppConstants.keyOnboardingSeen, true);
    Get.offAllNamed('/main');
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authRepo.login(email, password);
      currentUser.value = user;
      isLoggedIn.value = true;
      Get.snackbar(
        'Welcome Back',
        'Signed in as ${user.name}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.charcoal,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      Get.offAllNamed('/main');
      return true;
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        'Please verify your credentials and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authRepo.register(name, email, password);
      currentUser.value = user;
      isLoggedIn.value = true;
      Get.snackbar(
        'Welcome to Lumina',
        'Your account has been created successfully.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.rose,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      Get.offAllNamed('/main');
      return true;
    } catch (e) {
      Get.snackbar(
        'Registration Failed',
        'Unable to create account. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendPasswordReset(String email) async {
    isLoading.value = true;
    try {
      await _authRepo.sendPasswordReset(email);
      Get.snackbar(
        'Reset Link Sent',
        'We sent password recovery instructions to $email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.charcoal,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not send recovery email. Please check the address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.danger,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authRepo.logout();
    currentUser.value = null;
    isLoggedIn.value = false;
    Get.snackbar(
      'Signed Out',
      'You have been logged out of Lumina.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.charcoal,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
    Get.offAllNamed('/login');
  }

  Future<void> updateProfile({required String name, required String phone}) async {
    if (currentUser.value == null) return;
    isLoading.value = true;
    try {
      final updated = currentUser.value!.copyWith(name: name, phone: phone);
      final saved = await _authRepo.updateUser(updated);
      currentUser.value = saved;
      Get.snackbar(
        'Profile Updated',
        'Your profile changes have been saved.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.charcoal,
        colorText: AppColors.white,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveAddress(AddressModel address) async {
    final updatedList = await _authRepo.saveAddress(address);
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(addresses: updatedList);
    }
    Get.snackbar(
      'Address Saved',
      'Shipping address updated successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.charcoal,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> deleteAddress(String addressId) async {
    final updatedList = await _authRepo.deleteAddress(addressId);
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(addresses: updatedList);
    }
    Get.snackbar(
      'Address Removed',
      'The selected address has been deleted.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.charcoal,
      colorText: AppColors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
    );
  }

  Future<void> setDefaultAddress(String addressId) async {
    final updatedList = await _authRepo.setDefaultAddress(addressId);
    if (currentUser.value != null) {
      currentUser.value = currentUser.value!.copyWith(addresses: updatedList);
    }
  }
}
