import 'package:flutter/material.dart';

Widget circularProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Color(0xFF42A5F5),
      ),
    ),
  );
}

Widget linearProgress() {
  return Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.only(top: 12),
    child: const LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        Color(0xFF42A5F5),
      ),
    ),
  );
}