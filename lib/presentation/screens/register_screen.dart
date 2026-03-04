import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitly_mission/domain/entities/auth_credentials.dart';
import 'package:habitly_mission/presentation/state/auth_providers.dart';
import 'package:habitly_mission/style/app_color.dart';
import 'package:habitly_mission/widget/custom_field.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  static const routeName = '/register';
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenLogic();
}

class _RegisterScreenLogic extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  List<String> gender = <String>['laki-laki', 'perempuan', 'tidak bersedia'];

  final namaInput = TextEditingController();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final passwordConfirmationInput = TextEditingController();
  String choosenGender = '';

  @override
  void dispose() {
    namaInput.dispose();
    emailInput.dispose();
    passwordInput.dispose();
    passwordConfirmationInput.dispose();
    super.dispose();
  }

  void onGenderChanged(String? value) {
    setState(() {
      choosenGender = value!;
    });
  }

  Future<void> addUser() async {
    if (!_formKey.currentState!.validate()) return;

    await ref
        .read(authNotifierProvider.notifier)
        .register(
          EmailAuthCredentials(
            email: emailInput.text.trim(),
            password: passwordInput.text.trim(),
          ),
        );

    if (!mounted) return;

    final authState = ref.read(authNotifierProvider);

    authState.when(
      data: (user) {
        if (user != null) {
          Navigator.pop(context);
        }
      },
      error: (e, _) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      },
      loading: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return RegisterView(
      formKey: _formKey,
      nama: namaInput,
      email: emailInput,
      password: passwordInput,
      passConfirmation: passwordConfirmationInput,
      choosenGender: choosenGender,
      genderDropdown: onGenderChanged,
      genderList: gender,
      onRegister: addUser,
    );
  }
}

class RegisterView extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nama;
  final TextEditingController email;
  final TextEditingController password;
  final TextEditingController passConfirmation;
  final String choosenGender;
  final ValueChanged<String?> genderDropdown;
  final List<String> genderList;
  final AsyncCallback onRegister;

  const RegisterView({
    super.key,
    required this.formKey,
    required this.nama,
    required this.email,
    required this.password,
    required this.passConfirmation,
    required this.choosenGender,
    required this.genderDropdown,
    required this.genderList,
    required this.onRegister,
  });
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Center(
              child: Image.asset(
                'assets/logo_app.png',
                height: 200,
                width: 200,
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 40),
              child: Form(
                key: formKey,
                child: Card(
                  color: Colors.black,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 24),
                        child: Text(
                          "Full Name",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      CustomField(
                        label: 'cth : disnaya',
                        controller: nama,
                        backgroundColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'cant be empty';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 24),
                        child: Text(
                          "Email",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      CustomField(
                        label: 'cth : abccompany@gmail.com',
                        controller: email,
                        backgroundColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'cant be empty';
                          }
                          return null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 24),
                        child: Text(
                          "Jenis Kelamin",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 24),
                        child: DropdownMenu<String>(
                          width: double.infinity,
                          inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          initialSelection: genderList[0],
                          dropdownMenuEntries: genderList.map((value) {
                            return DropdownMenuEntry<String>(
                              value: value,
                              label: value,
                            );
                          }).toList(),
                          onSelected: genderDropdown,
                        ),
                      ),
                      //Password Field---------------
                      SizedBox(height: 10),
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 24),
                        child: Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      CustomField(
                        obsecure: true,
                        label: 'password',
                        controller: password,
                        backgroundColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'cant be empty';
                          }
                          return null;
                        },
                      ), //--------------
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 24),
                        child: Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4),
                      CustomField(
                        obsecure: true,
                        label: 'confirm password',
                        controller: passConfirmation,
                        backgroundColor: Colors.white,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'cant be empty';
                          }
                          if (value != password.text) {
                            // ← check here
                            return 'password does not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // button create account dan pop
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 30),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2FB969),
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(10),
                  ),
                ),
                onPressed: onRegister,
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
    );
  }
}
