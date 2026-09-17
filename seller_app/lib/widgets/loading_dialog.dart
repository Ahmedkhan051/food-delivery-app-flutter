import 'package:flutter/material.dart';
import 'package:seller_app/widgets/progress_bar.dart';

class LoadingDialog extends StatelessWidget {
  final String? message;

  const LoadingDialog({
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
            Icons.hourglass_top,
            color: darkBlue,
          ),
          SizedBox(width: 8),
          Text(
            "Please Wait",
            style: TextStyle(
              color: darkBlue,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          circularProgress(),
          const SizedBox(height: 12),
          Text(
            "${message ?? "Loading"}, please wait...",
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          const CircularProgressIndicator(
            color: mediumBlue,
            strokeWidth: 2,
          ),
        ],
      ),
    );
  }
}