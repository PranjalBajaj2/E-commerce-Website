import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'ui/main_shell.dart';
import 'view_models/ecommerce_view_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LuminaApp());
}

class LuminaApp extends StatefulWidget {
  const LuminaApp({super.key});

  @override
  State<LuminaApp> createState() => _LuminaAppState();
}

class _LuminaAppState extends State<LuminaApp> {
  late final EcommerceViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = EcommerceViewModel();
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LUMINA | Modern E-commerce Experience',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: MainShell(viewModel: _viewModel),
    );
  }
}
