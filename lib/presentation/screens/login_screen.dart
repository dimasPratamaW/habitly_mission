import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_habit.dart';
import 'package:habitly_mission/presentation/screens/register_screen.dart';
import 'package:habitly_mission/widget/custom_dialog.dart';
import 'package:habitly_mission/widget/custom_field.dart';

import '../../style/app_color.dart';
import '../../widget/custom_dialog.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> checkUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    await ref
        .read(authNotifierProvider.notifier)
        .login(
          EmailAuthCredentials(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          ),
        )
        .timeout(
          const Duration(seconds: 15),
          onTimeout: () {
            if(!mounted)return;
            setState(() => isLoading = false);
            CustomDialog.showNotifications(
              title: "Timeout",
              message:'Connection timeout. Check your internet!', confirmText: 'Confirm' ,
            );
          },
        );

    final authState = ref.read(authNotifierProvider);
    authState.when(
      data: (user) {
        if (user != null) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, DashboardHabit.routeName);
        }
      },
      error: (e, _) {
        setState(() {
          isLoading = false;
        });
        CustomDialog.showNotifications(
          title: "ERROR",
          confirmText: 'Confirm', message:e.toString() ,
        );
      },
      loading: () {},
    );
  }

  Widget _buildLoginButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: isLoading ? null : () async => await checkUser(),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                "Continue",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }

  Widget _buildRegisterButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey,
          minimumSize: const Size(double.infinity, 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, RegisterView.routeName);
        },
        child: const Text(
          "Register Account",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {//RENDER SCREEN----------------
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset('assets/logo_app.png', height: 320, width: 320),
                _EmailField(controller: _emailController),
                _PasswordField(controller: _passwordController),
                _buildLoginButton(), //<- LOGIN BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
                    children: [
                      Expanded(child: Divider(thickness: 2)),
                      Text(
                        ' or ',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Expanded(child: Divider(thickness: 2)),
                    ],
                  ),
                ),
                _buildRegisterButton(), //<-REGISTER BUTTON
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmailField extends StatelessWidget {
  final TextEditingController controller;

  const _EmailField({required this.controller});

  String? validatorInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomField(
      label: 'email@domain.com',
      controller: controller,
      validator: validatorInput,
    );
  }
}

class _PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const _PasswordField({required this.controller});

  @override
  State<_PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<_PasswordField> {
  bool _isObscure = true; // ← controls visibility

  String? validatorInput(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Password cannot be empty';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return CustomField(
      label: 'password',
      controller: widget.controller, // ← access via widget.
      obsecure: _isObscure,          // ← controlled by state
      validator: validatorInput,
      icon: _isObscure ? Icons.visibility_off : Icons.visibility,
      toggle: () => setState(() => _isObscure = !_isObscure),
    );
  }
}