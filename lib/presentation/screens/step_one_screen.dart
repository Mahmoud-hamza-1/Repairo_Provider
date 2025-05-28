import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/route_manager.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_states.dart';

class StepOneWidget extends StatefulWidget {
  const StepOneWidget({Key? key}) : super(key: key);

  @override
  State<StepOneWidget> createState() => StepOneWidgetState();
}

class StepOneWidgetState extends State<StepOneWidget> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedCity = 'Damascus';
  String selectedGender = 'Male';

  File? selectedImage;

  Map<String, dynamic>? getStepOneData() {
    // تحقق إنو البيانات مو فاضية
    if (fullNameController.text.isEmpty ||
        emailController.text.isEmpty ||
        addressController.text.isEmpty ||
        selectedImage == null) {
      Get.snackbar(
        "Missing fields",
        "Please fill all fields and choose an image",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return null;
    }

    return {
      "full_name": fullNameController.text.trim(),
      "email": emailController.text.trim(),
      "address": addressController.text.trim(),
      "city": selectedCity,
      "gender": selectedGender,
      "image_file": selectedImage,
    };
  }

  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  final cities = ['Damascus', 'Hama', 'Homs', 'Lattakia', 'Tartous'];
  final genders = ['Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocListener<StepOneCubit, StepOneStates>(
          listener: (context, state) {
            if (state is StepOneLoading) {
              Get.defaultDialog(
                title: "Loading...",
                content: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.blueAccent),
                    SizedBox(height: 10),
                    Text("Please wait..."),
                  ],
                ),
                barrierDismissible: false,
              );
            } else {
              if (Get.isDialogOpen!) {
                Get.back();
              }
            }

            if (state is StepOneError) {
              Get.snackbar(
                "Error",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                GestureDetector(
                  onTap: pickImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage:
                        selectedImage != null
                            ? FileImage(selectedImage!)
                            : null,
                    child:
                        selectedImage == null
                            ? const Icon(
                              Icons.camera_alt,
                              size: 32,
                              color: Colors.grey,
                            )
                            : null,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: fullNameController,
                  label: 'Full name',
                ),
                _buildTextField(controller: emailController, label: 'Email'),
                SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: _buildDropdown(
                        cities,
                        selectedCity,
                        'City',
                        (val) => setState(() => selectedCity = val!),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _buildDropdown(
                        genders,
                        selectedGender,
                        'Gender',
                        (val) => setState(() => selectedGender = val!),
                      ),
                    ),
                  ],
                ),
                _buildTextField(
                  controller: addressController,
                  label: 'Address',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          filled: true,
          fillColor: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildDropdown(
    List<String> items,
    String value,
    String label,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.grey.shade100,
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }
}
