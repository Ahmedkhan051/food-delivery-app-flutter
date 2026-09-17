import 'package:flutter/material.dart';

Widget circularProgress() {
  return const SizedBox(
    width: 28,
    height: 28,
    child: CircularProgressIndicator(
      strokeWidth: 3,
      valueColor: AlwaysStoppedAnimation<Color>(
        Color(0xFF1565C0),
      ),
    ),
  );
}