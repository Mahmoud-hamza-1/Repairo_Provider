import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_states.dart';

class StepThreeWidget extends StatefulWidget {
  const StepThreeWidget({super.key});

  @override
  State<StepThreeWidget> createState() => StepThreeWidgetState();
}

class StepThreeWidgetState extends State<StepThreeWidget> {
  File? idImage;

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      setState(() {
        idImage = File(picked.path);
      });
    }
  }

  File? getStepThreeData() {
    if (idImage == null) {
      Get.snackbar(
        "Missing ID Image",
        "Please upload an image of your ID",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }
    return idImage;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StepThreeCubit, StepThreeStates>(
      listener: (context, state) {
        if (state is StepThreeLoading) {
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
        if (state is StepThreeError) {
          Get.snackbar(
            "Error",
            state.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Upload your ID",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 16),
              if (idImage == null)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "No image selected",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                )
              else
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        idImage!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: CircleAvatar(
                        backgroundColor: Colors.black54,
                        child: IconButton(
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          onPressed: () => setState(() => idImage = null),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // ElevatedButton.icon(
                  //   style: ButtonStyle(),
                  //   onPressed: () => pickImage(ImageSource.gallery),
                  GestureDetector(
                    onTap: () => pickImage(ImageSource.gallery),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.photo),
                            const Text(
                              "Gallery",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => pickImage(ImageSource.camera),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            const Icon(Icons.camera_alt),
                            const Text(
                              "Camera",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // ElevatedButton.icon(
              //   onPressed: () => pickImage(ImageSource.camera),
              //   icon: const Icon(Icons.camera_alt),
              //   label: const Text("Camera"),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
