import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_update_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_update_state.dart';
import 'package:repairo_provider/data/web_services/profile_remote_data_source2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:file_picker/file_picker.dart';

class MultiStepProfileScreen extends StatefulWidget {
  //static TextEditingController namecontroller = TextEditingController();
  //static TextEditingController addressController = TextEditingController();
  // static File? selectedImage;
  MultiStepProfileScreen({super.key});

  @override
  State<MultiStepProfileScreen> createState() => _MultiStepProfileScreenState();
}

class _MultiStepProfileScreenState extends State<MultiStepProfileScreen> {
  get selectedImage => null;
  //StepOneWidget _oneWidget = StepOneWidget();
  //ProfileRemoteDataSource ProfileRemoteDataSource_ = ProfileRemoteDataSource();
  int currentStep = 0;
  final PageController _pageController = PageController();
  void nextPage() {
    if (currentStep == 0) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    if (currentStep == 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    if (currentStep == 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        title: const Text("تعديل الملف الشخصي"),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => currentStep = index);
              },
              children: [
                StepOneWidget(onNext: nextPage),
                StepTwoWidget(),
                StepThreeWidget(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: 3,
                  effect: WormEffect(
                    dotColor: Colors.grey.shade400,
                    activeDotColor: const Color.fromRGBO(95, 96, 185, 1),
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
                const SizedBox(height: 10),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     if (currentStep > 0)
                //       ElevatedButton(
                //         onPressed: previousPage,
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.grey,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         child: const Text("السابق"),
                //       ),
                //     ElevatedButton(
                //       onPressed: () async {
                //         print('Step1--- 1');
                //         // context.read<ProfileUpdateCubit>().submitStep1;
                //         print('Step1--- 2');

                //         nextPage();
                //       },
                //       style: ElevatedButton.styleFrom(
                //         backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(12),
                //         ),
                //       ),
                //       child: Text(currentStep == 2 ? "إنهاء" : "التالي"),
                //     ),
                //   ],
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StepOneWidget extends StatefulWidget {
  final VoidCallback onNext;
  StepOneWidget({Key? key, required this.onNext}) : super(key: key);

  @override
  State<StepOneWidget> createState() => _StepOneWidgetState();
}

class _StepOneWidgetState extends State<StepOneWidget> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController addressController = TextEditingController();
  File? selectedImage;
  Future<void> pickImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedImage = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileUpdateCubit, ProfileUpdateState>(
      builder: (context, state) {
        if (state is ProfileStepSuccess) {
          return Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "البيانات الشخصية",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // زر اختيار الصورة + معاينة
                      InkWell(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 60, // يمكنك تعديل الحجم حسب الرغبة
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : null,
                          child:
                              selectedImage == null
                                  ? const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                      ),

                      const SizedBox(height: 20),
                      // حقل الاسم
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "الاسم",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // حقل العنوان
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: "العنوان",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          widget.onNext();
                          context.read<ProfileUpdateCubit>().submitStep1(
                            name: nameController.text,
                            address: addressController.text,
                            image: selectedImage!.path,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("التالي"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        } else if (state is ProfileLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is ProfileError) {
          return Center(child: Text("Error Happened"));
        } else {
          return Center(
            child: SingleChildScrollView(
              child: Card(
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 8,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "البيانات الشخصية",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // زر اختيار الصورة + معاينة
                      InkWell(
                        onTap: pickImage,
                        child: CircleAvatar(
                          radius: 60, // يمكنك تعديل الحجم حسب الرغبة
                          backgroundColor: Colors.grey.shade200,
                          backgroundImage:
                              selectedImage != null
                                  ? FileImage(selectedImage!)
                                  : null,
                          child:
                              selectedImage == null
                                  ? const Icon(
                                    Icons.camera_alt,
                                    size: 40,
                                    color: Colors.grey,
                                  )
                                  : null,
                        ),
                      ),

                      const SizedBox(height: 20),
                      // حقل الاسم
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "الاسم",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // حقل العنوان
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: "العنوان",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () {
                          widget.onNext();
                          context.read<ProfileUpdateCubit>().submitStep1(
                            name: nameController.text,
                            address: addressController.text,
                            image: selectedImage!.path,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text("التالي"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class StepTwoWidget extends StatelessWidget {
  const StepTwoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                "الخدمات المقدمة",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Placeholder(fallbackHeight: 200),
            ],
          ),
        ),
      ),
    );
  }
}

class StepThreeWidget extends StatefulWidget {
  const StepThreeWidget({super.key});

  @override
  State<StepThreeWidget> createState() => _StepThreeWidgetState();
}

File? idImage;

class _StepThreeWidgetState extends State<StepThreeWidget> {
  Future<void> pickIdImage() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: false,
    );
    if (result != null && result.files.single.path != null) {
      setState(() {
        idImage = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 8,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "التحقق من الهوية",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              // زر اختيار الصورة + معاينة
              InkWell(
                onTap: pickIdImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:
                      idImage != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(idImage!, fit: BoxFit.cover),
                          )
                          : const Center(
                            child: Text("اضغط لإدخال صورة الهوية شخصية"),
                          ),
                ),
              ),
              SizedBox(height: 20),
              //   Placeholder(fallbackHeight: 200),
            ],
          ),
        ),
      ),
    );
  }
}
