import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;

  const ErrorDialog({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    const Color darkBlue = Color(0xFF1565C0);
    const Color mediumBlue = Color(0xFF42A5F5);

    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.error_outline,
            color: darkBlue,
          ),
          SizedBox(width: 8),
          Text(
            "Notice",
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Text(
        message ?? "Something went wrong.",
        style: const TextStyle(
          color: Colors.black87,
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: mediumBlue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "OK",
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}