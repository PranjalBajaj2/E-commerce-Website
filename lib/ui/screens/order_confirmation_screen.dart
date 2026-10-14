import 'package:flutter/material.dart';
import '../../core/app_theme.dart';
import '../../view_models/ecommerce_view_model.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final EcommerceViewModel viewModel;

  const OrderConfirmationScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 48.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFDCFCE7),
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: AppTheme.success,
                    size: 48,
                  ),
                ),

                const SizedBox(height: 24),

                const Text(
                  'Thank You for Your Order!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary,
                  ),
                ),

                const SizedBox(height: 12),

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.backgroundSubtle,
                    borderRadius: BorderRadius.circular(AppTheme.radiusFull),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: const Text(
                    'Order #LUM-84920',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: AppTheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'We\'ve received your order and are preparing it for shipment. A confirmation email with tracking information will be sent to your inbox shortly.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: AppTheme.textMuted,
                    height: 1.6,
                  ),
                ),

                const SizedBox(height: 32),

                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    ElevatedButton(
                      onPressed: () => viewModel.navigateTo(AppPage.shop),
                      child: const Text('Continue Shopping'),
                    ),
                    OutlinedButton(
                      onPressed: () => viewModel.navigateTo(AppPage.home),
                      child: const Text('Back to Home'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
