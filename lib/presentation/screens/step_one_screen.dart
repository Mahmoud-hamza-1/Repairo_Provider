import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_states.dart';

class StepOneWidget extends StatefulWidget {
  const StepOneWidget({super.key});

  @override
  State<StepOneWidget> createState() => StepOneWidgetState();
}

class StepOneWidgetState extends State<StepOneWidget> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  String selectedCity = 'دمشق';
  String selectedGender = 'ذكر';
  File? selectedImage;

  final cities = ['دمشق', 'حماة', 'حمص', 'اللاذقية', 'طرطوس'];
  final genders = ['ذكر', 'أنثى'];

  Map<String, dynamic>? getStepOneData() {
    if (!_formKey.currentState!.validate()) {
      Get.snackbar(
        "حقول ناقصة",
        "يرجى التأكد من تعبئة جميع الحقول بشكل صحيح.",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return null;
    }
    if (selectedImage == null) {
      Get.snackbar(
        "الصورة مطلوبة",
        "يرجى اختيار صورة شخصية.",
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // 🔹 لتفعيل RTL
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "أدخل معلوماتك",
            style: TextStyle(fontFamily: "Cairo"),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: BlocListener<StepOneCubit, StepOneStates>(
          listener: (context, state) {
            if (state is StepOneLoading) {
              Get.defaultDialog(
                title: "...جاري التحميل ",
                titleStyle: TextStyle(fontFamily: "Cairo"),
                content: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text(
                      "الرجاء الانتظار.",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),
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
                "خطأ",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildStepper(),
                  const SizedBox(height: 30),
                  _buildImagePicker(),
                  const SizedBox(height: 30),
                  _buildTextFormField(
                    controller: fullNameController,
                    label: 'الاسم الكامل',
                    icon: Icons.person_outline,
                  ),
                  // const SizedBox(height: 16),
                  // _buildTextFormField(
                  //   controller: emailController,
                  //   label: 'البريد الإلكتروني',
                  //   icon: Icons.email_outlined,
                  //   keyboardType: TextInputType.emailAddress,
                  // ),
                  const SizedBox(height: 16),
                  _buildDropdownFormField(
                    items: cities,
                    value: selectedCity,
                    label: 'المدينة',
                    icon: Icons.location_city_outlined,
                    onChanged: (val) => setState(() => selectedCity = val!),
                  ),
                  // const SizedBox(height: 16),
                  // _buildDropdownFormField(
                  //   items: genders,
                  //   value: selectedGender,
                  //   label: 'الجنس',
                  //   icon: Icons.wc_outlined,
                  //   onChanged: (val) => setState(() => selectedGender = val!),
                  // ),
                  const SizedBox(height: 16),
                  _buildTextFormField(
                    controller: addressController,
                    label: 'العنوان التفصيلي',
                    icon: Icons.location_on_outlined,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // 🔹 Stepper مبسط وأنيق
  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(number: '١', label: 'المعلومات', isActive: true),
        _buildStepConnector(),
        _buildStepIndicator(number: '٢', label: 'الخدمات'),
        _buildStepConnector(),
        _buildStepIndicator(number: '٣', label: 'الهوية'),
      ],
    );
  }

  Widget _buildStepIndicator({
    required String number,
    required String label,
    bool isActive = false,
    bool isCompleted = false,
  }) {
    final color =
        isActive
            ? Colors.teal
            : (isCompleted ? Colors.green : Colors.grey.shade400);
    return Column(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color,
          child:
              isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                    number,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                    ),
                  ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
            fontFamily: "Cairo",
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        color: Colors.grey.shade300,
      ),
    );
  }

  // 🔹 صورة البروفايل
  Widget _buildImagePicker() {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        CircleAvatar(
          radius: 60,
          backgroundColor: Colors.grey.shade200,
          backgroundImage:
              selectedImage != null ? FileImage(selectedImage!) : null,
          child:
              selectedImage == null
                  ? Icon(Icons.person, size: 60, color: Colors.grey.shade400)
                  : null,
        ),
        GestureDetector(
          onTap: pickImage,
          child: const CircleAvatar(
            radius: 20,
            backgroundColor: Colors.teal,
            child: Icon(Icons.camera_alt, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  // 🔹 حقول الإدخال
  InputDecoration _buildInputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: "Cairo", color: Colors.teal),
      prefixIcon: Icon(icon, color: Colors.teal),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.teal, width: 2),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      cursorColor: Colors.teal,
      controller: controller,
      keyboardType: keyboardType,
      decoration: _buildInputDecoration(label, icon),
      style: const TextStyle(fontFamily: "Cairo"),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'هذا الحقل لا يمكن أن يكون فارغاً';
        }
        return null;
      },
    );
  }

  Widget _buildDropdownFormField({
    required List<String> items,
    required String value,
    required String label,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      onChanged: onChanged,
      decoration: _buildInputDecoration(label, icon),
      style: const TextStyle(fontFamily: "Cairo", color: Colors.black87),
      items:
          items
              .map(
                (e) => DropdownMenuItem(
                  value: e,
                  child: Text(e, style: const TextStyle(fontFamily: "Cairo")),
                ),
              )
              .toList(),
      validator: (value) {
        if (value == null) {
          return 'يرجى اختيار خيار';
        }
        return null;
      },
    );
  }
}
