import 'dart:io';

class Step1Request {
  final String name;
  final String place;
  final File? image;

  Step1Request({required this.name, required this.place, required this.image});
}
