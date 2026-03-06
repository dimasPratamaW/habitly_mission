import 'package:flutter/material.dart';
import 'package:habitly_mission/main.dart';

class CustomDialog {
  static Future<void> showNotifications({
    required String title,
    required String message,
    required String confirmText,
  }) {
    final context = navigatorKey.currentContext!;

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  static Future<void> showConfirmation({
    required String title,
    required String message,
    required String confirmText,
    required String cancellationText,
    VoidCallback? confirmationFunction,
  }) {
    final context = navigatorKey.currentContext!;
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsetsGeometry.symmetric(vertical: 10),
            ),
            child: Text(cancellationText),
          ),
          ElevatedButton(
            onPressed: (){
              Navigator.pop(context);
              confirmationFunction?.call();
            },
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}
