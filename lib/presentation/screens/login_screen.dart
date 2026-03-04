import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/presentation/screens/initiate_pages/dashboard_habit.dart';
import 'package:habitly_mission/presentation/screens/register_screen.dart';
import 'package:habitly_mission/widget/custom_field.dart';

import '../../style/app_color.dart';

class LoginScreen extends ConsumerStatefulWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> checkUser() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => isLoading = true);
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .login(
        EmailAuthCredentials(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        ),
      ).timeout(Duration(seconds: 15), onTimeout: () {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Connection timeout. Check your internet!')),
        );
      });

      final authState = ref.read(authNotifierProvider);
      authState.when(
        data: (user) {
          if (user != null) {
            if (!mounted) return;
            Navigator.pushReplacementNamed(context, DashboardHabit.routeName);
          }
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
          setState(() {
            isLoading = false;
          });
        },
        loading: () {},
      );
    }
    finally{
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);

    return Scaffold(
      backgroundColor: colors.background,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/logo_app.png', height: 320, width: 320),
              CustomField(
                // INSERT EMAIL HERE
                label: "email@domain.com",
                controller: emailController,
                backgroundColor: Colors.white,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email can’t be empty';
                  }
                  return null;
                },
              ),

              CustomField(
                // INSERT PASSWORD
                label: "password",
                controller: passwordController,
                backgroundColor: Colors.white,
                obsecure: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password can’t be empty';
                  }
                  return null;
                },
              ),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  onPressed: isLoading ? null : () async => await checkUser(), // ← update
                  child: isLoading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                      : const Text( // ← update
                    "Continue",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
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

              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    minimumSize: const Size(double.infinity, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(10),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      RegisterView.routeName,
                    );
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
