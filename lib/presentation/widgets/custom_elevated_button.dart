import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  CustomElevatedButton({
    super.key,
    required this.onpressed,
    required this.text,
  });

  void Function()? onpressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 335,
      height: 45,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: onpressed,
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
