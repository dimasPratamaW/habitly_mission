import 'package:flutter/material.dart';

class CustomField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  final IconData? icon;
  final bool obsecure;
  final VoidCallback? toggle;
  final Color? backgroundColor;

  const CustomField({
    super.key,
    required this.label,
    required this.controller,
    this.validator,
    this.icon,
    this.obsecure = false,
    this.toggle,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      child: TextFormField(
        controller: controller,
        obscureText: obsecure,
        validator: validator,
        decoration: InputDecoration(
          filled: backgroundColor != null,
          fillColor: backgroundColor,
          hintText: label,
          suffixIcon: toggle != null
              ? IconButton(onPressed: toggle, icon: Icon(icon))
              : icon != null
              ? Icon(icon)
              : null,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
      ),
    );
  }
}
