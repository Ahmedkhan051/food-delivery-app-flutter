import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final IconData? data;
  final String? hintText;
  final bool isObsecre;
  final bool enabled;

  const CustomTextField({
    super.key,
    this.controller,
    this.data,
    this.hintText,
    this.isObsecre = true,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    const Color mediumBlue = Color(0xFF42A5F5);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      child: TextFormField(
        enabled: enabled,
        controller: controller,
        obscureText: isObsecre,
        cursorColor: mediumBlue,
        style: const TextStyle(
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            data,
            color: mediumBlue,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
        ),
      ),
    );
  }
}