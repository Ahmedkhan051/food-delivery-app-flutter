import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;

  const ErrorDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Text(
        message ?? "Something went wrong.",
      ),
      actions: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1976D2),
              foregroundColor: Colors.white,
            ),
            child: const Text("OK"),
          ),
        ),
      ],
    );
  }
}