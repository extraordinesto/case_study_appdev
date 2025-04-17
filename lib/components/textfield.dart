import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Widget prefixicon;
  final Widget? suffixIcon;
  final FormFieldValidator validator;
  final bool isObsecure;

  const MyTextField({
    super.key,
    required this.hintText,
    required this.controller,
    required this.prefixicon,
    required this.suffixIcon,
    required this.validator,
    required this.isObsecure,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: isObsecure,
      decoration: InputDecoration(
        prefixIcon: prefixicon,
        hintText: hintText,
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(color: Colors.grey[500]),
        errorStyle: TextStyle(
          color: Colors.red,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        // filled: true,
        // fillColor: Colors.white,
        // enabledBorder: OutlineInputBorder(
        //   borderSide: BorderSide.none,
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // focusedBorder: OutlineInputBorder(
        //   borderSide: BorderSide(
        //     width: 2,
        //     color: Theme.of(context).colorScheme.inversePrimary,
        //   ),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // errorBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 2, color: Colors.red.shade200),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        // focusedErrorBorder: OutlineInputBorder(
        //   borderSide: BorderSide(width: 2, color: Colors.red.shade400),
        //   borderRadius: BorderRadius.circular(8),
        // ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
