import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool isPass;
  final TextEditingController controller;
  final String hinttext;
  final Widget? suffixicon;
  final TextInputType? keybordtype;
  final String? Function(String?) valid;

  const CustomTextFormField({
    super.key,
    required this.isPass,
    required this.controller,
    required this.hinttext,
    required this.keybordtype,
    required this.valid,
    this.suffixicon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
          obscureText: isPass,
          controller: controller,
          decoration: InputDecoration(
            hintText: hinttext,
            hintStyle: const TextStyle(fontSize: 14),
            suffixIcon: suffixicon,
            filled: true,
            fillColor: const Color.fromARGB(255, 242, 244, 245),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide:
                  const BorderSide(color: Color.fromRGBO(95, 96, 185, 1)),
            ),
          ),
          keyboardType: keybordtype,
          validator: valid),
    );
  }
}
