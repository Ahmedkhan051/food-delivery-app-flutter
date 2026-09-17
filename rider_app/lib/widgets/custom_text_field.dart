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
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        obscureText: isObsecre,
        cursorColor: const Color(0xFF1565C0),
        keyboardType: hintText == "Phone"
            ? TextInputType.phone
            : hintText == "Email"
            ? TextInputType.emailAddress
            : TextInputType.text,
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 16,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
          ),
          prefixIcon: Icon(
            data,
            color: const Color(0xFF1565C0),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}