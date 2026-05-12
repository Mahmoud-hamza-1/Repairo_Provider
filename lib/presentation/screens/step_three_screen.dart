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
        "مطلوب صورة الهوية",
        "يرجى رفع صورة واضحة لبطاقة الهوية",
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
    return idImage;
  }

  void _showImageSourceActionSheet(BuildContext context) {
    Get.bottomSheet(
      Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_library, color: Colors.teal),
                title: const Text(
                  "اختيار من المعرض",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.teal),
                title: const Text(
                  "التقاط صورة بالكاميرا",
                  style: TextStyle(fontFamily: "Cairo"),
                ),
                onTap: () {
                  Get.back();
                  pickImage(ImageSource.camera);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "رفع بطاقة الهوية",
            style: TextStyle(fontFamily: "Cairo"),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
        ),
        body: BlocListener<StepThreeCubit, StepThreeStates>(
          listener: (context, state) {
            if (state is StepThreeLoading) {
              Get.defaultDialog(
                title: "جاري التحميل...",
                titleStyle: const TextStyle(fontFamily: "Cairo"),
                content: const Column(
                  children: [
                    CircularProgressIndicator(color: Colors.teal),
                    SizedBox(height: 10),
                    Text(
                      "يرجى الانتظار",
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
            if (state is StepThreeError) {
              Get.snackbar(
                "خطأ",
                state.message,
                backgroundColor: Colors.redAccent,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
              );
            }
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                _buildStepper(),
                const SizedBox(height: 30),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const Text(
                          "يرجى رفع صورة واضحة لبطاقة الهوية",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Cairo",
                            color: Colors.teal,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        idImage == null
                            ? _buildImagePlaceholder()
                            : _buildImagePreview(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepper() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStepIndicator(number: '1', label: 'المعلومات', isCompleted: true),
        _buildStepConnector(),
        _buildStepIndicator(number: '2', label: 'الخدمات', isCompleted: true),
        _buildStepConnector(),
        _buildStepIndicator(number: '3', label: 'الهوية', isActive: true),
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
            : (isCompleted ? Colors.teal : Colors.grey.shade400);
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
            fontFamily: "Cairo",
            fontSize: 12,
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

  Widget _buildImagePlaceholder() {
    return GestureDetector(
      onTap: () => _showImageSourceActionSheet(context),
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.cloud_upload_outlined, color: Colors.teal, size: 50),
            SizedBox(height: 8),
            Text(
              "اضغط لرفع الصورة",
              style: TextStyle(color: Colors.teal, fontFamily: "Cairo"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Stack(
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
          left: 8,
          child: CircleAvatar(
            backgroundColor: Colors.teal,
            child: IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () => setState(() => idImage = null),
            ),
          ),
        ),
      ],
    );
  }
}

// import 'dart:io';
// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
// import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_states.dart';
// import 'package:repairo_provider/business_logic/Subscription/status_check_bloc.dart';
// import 'package:repairo_provider/business_logic/Subscription/status_check_state.dart';

// class StepThreeWidget extends StatefulWidget {
//   const StepThreeWidget({super.key});

//   @override
//   State<StepThreeWidget> createState() => StepThreeWidgetState();
// }

// class StepThreeWidgetState extends State<StepThreeWidget> {
//   // Your logic and variables remain unchanged
//   File? idImage;

//   Future<void> pickImage(ImageSource source) async {
//     final picked = await ImagePicker().pickImage(source: source);
//     if (picked != null) {
//       setState(() {
//         idImage = File(picked.path);
//       });
//     }
//   }

//   File? getStepThreeData() {
//     if (idImage == null) {
//       Get.snackbar(
//         "Missing ID Image",
//         "Please upload an image of your ID",
//         backgroundColor: Colors.redAccent,
//         colorText: Colors.white,
//       );
//       return null;
//     }
//     return idImage;
//   }

//   // --- دالة جديدة لعرض خيارات الكاميرا والاستوديو ---
//   void _showImageSourceActionSheet(BuildContext context) {
//     Get.bottomSheet(
//       Container(
//         decoration: const BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20),
//             topRight: Radius.circular(20),
//           ),
//         ),
//         child: Wrap(
//           children: <Widget>[
//             ListTile(
//               leading: const Icon(
//                 Icons.photo_library,
//                 color: Color(0xFF6F4EC9),
//               ),
//               title: const Text('Choose from Gallery'),
//               onTap: () {
//                 Get.back(); // Close the bottom sheet
//                 pickImage(ImageSource.gallery);
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.camera_alt, color: Color(0xFF6F4EC9)),
//               title: const Text('Take a Photo'),
//               onTap: () {
//                 Get.back(); // Close the bottom sheet
//                 pickImage(ImageSource.camera);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Upload ID"),
//         backgroundColor: const Color(0xFF6F4EC9),
//         centerTitle: true,
//       ),
//       // ✅ تم دمج منطق التحقق من الاشتراك هنا
//       body: BlocListener<SubscriptionStatusBloc, StatusCheckState>(
//         listener: (context, state) {
//           // --- هذا المستمع الجديد سيتعامل مع التوجيه ---

//           // إخفاء أي شاشة تحميل قد تكون ظاهرة
//           if (Get.isDialogOpen ?? false) {
//             Get.back();
//           }

//           if (state is StatusLoading) {
//             // إظهار شاشة تحميل أثناء التحقق من الاشتراك
//             Get.defaultDialog(
//               title: "Checking Subscription...",
//               content: const CircularProgressIndicator(),
//               barrierDismissible: false,
//             );
//           } else if (state is NavigateToSubscriptionPlans) {
//             // الحالة 1: غير مشترك -> اذهب لصفحة الاشتراكات
//             Navigator.of(context).pushReplacementNamed('subscription_plans');
//           } else if (state is SubscriptionIsExpired) {
//             // الحالة 2: اشتراك منتهي -> أظهر رسالة ثم اذهب لصفحة الاشتراكات
//             Get.snackbar(
//               "Subscription Expired",
//               "Please renew your subscription.",
//               backgroundColor: Colors.orangeAccent,
//               colorText: Colors.white,
//             );
//             Navigator.of(context).pushReplacementNamed('subscription_plans');
//           } else if (state is NavigateToMainApp) {
//             // الحالة 3: مشترك وفعال -> اذهب للصفحة الرئيسية
//             Navigator.of(context).pushReplacementNamed('mainscreen');
//           }
//         },
//         child: BlocListener<StepThreeCubit, StepThreeStates>(
//           listener: (context, state) {
//             // --- هذا هو المستمع القديم الخاص بك ---
//             if (state is StepThreeLoading) {
//               Get.defaultDialog(
//                 title: "Loading...",
//                 content: const Column(
//                   children: [
//                     CircularProgressIndicator(color: Color(0xFF6F4EC9)),
//                     SizedBox(height: 10),
//                     Text("Please wait..."),
//                   ],
//                 ),
//                 barrierDismissible: false,
//               );
//             } else {
//               if (Get.isDialogOpen ?? false) {
//                 Get.back();
//               }
//             }
//             if (state is StepThreeError) {
//               Get.snackbar(
//                 "Error",
//                 state.message,
//                 backgroundColor: Colors.redAccent,
//                 colorText: Colors.white,
//               );
//             }

//             // --- ✅ هنا سنقوم بتشغيل عملية التحقق بعد نجاح الخطوة الثالثة ---
//             // ملاحظة: تأكد من أن لديك حالة نجاح مثل StepThreeSuccess
//             // if (state is StepThreeSuccess) {
//             //   context.read<SubscriptionStatusBloc>().add(CheckSubscriptionStatus());
//             // }
//           },
//           child: SingleChildScrollView(
//             padding: const EdgeInsets.all(24.0),
//             child: Column(
//               children: [
//                 // --- مؤشر الخطوات المحدث ---
//                 _buildStepper(),
//                 const SizedBox(height: 30),

//                 // --- واجهة رفع الصورة الجديدة داخل بطاقة ---
//                 Card(
//                   elevation: 2,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(12),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       children: [
//                         const Text(
//                           "Upload a clear image of your ID",
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                             color: Color(0xFF4A2F8C),
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                         const SizedBox(height: 16),
//                         // --- صندوق عرض الصورة أو الرفع ---
//                         idImage == null
//                             ? _buildImagePlaceholder()
//                             : _buildImagePreview(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   // --- دوال مساعدة خاصة بالـ Stepper ---
//   Widget _buildStepper() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         _buildStepIndicator(number: '1', label: 'Info', isCompleted: true),
//         _buildStepConnector(),
//         _buildStepIndicator(number: '2', label: 'Services', isCompleted: true),
//         _buildStepConnector(),
//         _buildStepIndicator(number: '3', label: 'ID Card', isActive: true),
//       ],
//     );
//   }

//   Widget _buildStepIndicator({
//     required String number,
//     required String label,
//     bool isActive = false,
//     bool isCompleted = false,
//   }) {
//     final color =
//         isActive
//             ? const Color(0xFF6F4EC9)
//             : (isCompleted ? Colors.green : Colors.grey.shade400);
//     return Column(
//       children: [
//         CircleAvatar(
//           radius: 18,
//           backgroundColor: color,
//           child:
//               isCompleted
//                   ? const Icon(Icons.check, color: Colors.white, size: 20)
//                   : Text(
//                     number,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: color,
//             fontWeight: FontWeight.bold,
//             fontSize: 12,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildStepConnector() {
//     return Expanded(
//       child: Container(
//         height: 2,
//         margin: const EdgeInsets.symmetric(horizontal: 8),
//         color: Colors.grey.shade300,
//       ),
//     );
//   }

//   // --- دوال مساعدة لواجهة رفع الصورة ---
//   Widget _buildImagePlaceholder() {
//     return GestureDetector(
//       onTap: () => _showImageSourceActionSheet(context),
//       child: Container(
//         height: 200,
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(12),
//           border: Border.all(color: Colors.grey.shade300, width: 2),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(
//               Icons.cloud_upload_outlined,
//               color: Colors.grey.shade500,
//               size: 50,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               "Tap to upload an image",
//               style: TextStyle(color: Colors.grey.shade600),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildImagePreview() {
//     return Stack(
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(12),
//           child: Image.file(
//             idImage!,
//             width: double.infinity,
//             height: 250,
//             fit: BoxFit.cover,
//           ),
//         ),
//         Positioned(
//           top: 8,
//           right: 8,
//           child: CircleAvatar(
//             backgroundColor: const Color(0xFF6F4EC9),
//             child: IconButton(
//               icon: const Icon(Icons.refresh, color: Colors.white),
//               onPressed: () => setState(() => idImage = null),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
