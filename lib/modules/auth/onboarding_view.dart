import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_theme.dart';
import '../../shared/widgets/custom_button.dart';
import '../../shared/widgets/network_image_with_fallback.dart';
import 'auth_controller.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _slides = [
    {
      'image': 'https://images.unsplash.com/photo-1441986300917-64674bd600d8?q=80&w=1000',
      'title': 'Curated Modern Living',
      'subtitle':
          'Explore intentional designs crafted for mindful spaces, minimalist aesthetics, and timeless everyday function.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=1000',
      'title': 'Conscious Craftsmanship',
      'subtitle':
          'Every Lumina piece embodies premium tactile materials, sustainable engineering, and uncompromising acoustic and structural quality.',
    },
    {
      'image': 'https://images.unsplash.com/photo-1513519245088-0e12902e5a38?q=80&w=1000',
      'title': 'Seamless Experience',
      'subtitle':
          'Enjoy direct dispatch, real-time tracking, frictionless checkout, and complimentary express shipping on orders over \$150.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Skip Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'LUMINA',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 2.0,
                      color: AppColors.charcoal,
                    ),
                  ),
                  TextButton(
                    onPressed: () => authController.completeOnboarding(),
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Page View
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _slides.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image Card with Soft Shadow
                        Container(
                          height: MediaQuery.of(context).size.height * 0.42,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                            boxShadow: AppTheme.elevatedShadow,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(AppTheme.radiusXl),
                            child: NetworkImageWithFallback(
                              imageUrl: slide['image']!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(height: 36),
                        // Title
                        Text(
                          slide['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                            color: AppColors.charcoal,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 14),
                        // Subtitle
                        Text(
                          slide['subtitle']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14.5,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Indicators and Bottom Controls
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
              child: Column(
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _slides.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 6,
                        width: _currentPage == index ? 24 : 6,
                        decoration: BoxDecoration(
                          color: _currentPage == index ? AppColors.charcoal : AppColors.border,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Button
                  CustomButton(
                    text: _currentPage == _slides.length - 1 ? 'Get Started' : 'Continue',
                    onPressed: () {
                      if (_currentPage < _slides.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        authController.completeOnboarding();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
