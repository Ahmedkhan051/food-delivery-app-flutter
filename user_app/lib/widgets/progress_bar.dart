import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation(
        Color(0xFF1976D2),
      ),
    ),
  );
}