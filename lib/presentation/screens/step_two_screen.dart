// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:get/get.dart';
// import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcategories_states.dart';
// import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';

// import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
// import 'package:repairo_provider/business_logic/ServiceCubit/service_states.dart';
// import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
// import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_states.dart';
// import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
// import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_states.dart';
// import 'package:repairo_provider/data/models/category_model.dart';
// import 'package:repairo_provider/data/models/service_model.dart';
// import 'package:repairo_provider/data/models/step_two_request_model.dart';
// import 'package:repairo_provider/data/models/subcategory_model.dart';

// class StepTwoWidget extends StatefulWidget {
//   const StepTwoWidget({super.key});

//   @override
//   State<StepTwoWidget> createState() => StepTwoWidgetState();
// }

// class StepTwoWidgetState extends State<StepTwoWidget> {
//   // حالتك ومنطقك كما هو
//   RCategoryData? selectedMainCategory;
//   RSubCategoryData? selectedSubCategory;
//   Map<String, TextEditingController> servicePriceControllers = {};
//   List<String> selectedServices = [];

//   // دالة تجميع البيانات كما هي
//   ServicesRequestBody? getStepTwoData() {
//     if (selectedMainCategory == null ||
//         selectedSubCategory == null ||
//         selectedServices.isEmpty) {
//       Get.snackbar("Missing Fields", "Please complete all selections.");
//       return null;
//     }
//     final servicesList =
//         selectedServices.map((id) {
//           final controller = servicePriceControllers[id];
//           final price =
//               double.tryParse(controller?.text.trim() ?? '0.0') ?? 0.0;
//           return ServiceData(serviceId: id, price: price);
//         }).toList();
//     return ServicesRequestBody(
//       categoryId: selectedMainCategory!.id!,
//       subCategories: [selectedSubCategory!.id!],
//       services: servicesList,
//     );
//   }

//   @override
//   void initState() {
//     context.read<AllcategoriesCubit>().getAllCategories();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     for (var controller in servicePriceControllers.values) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Select Services"),
//         backgroundColor: const Color(0xFF6F4EC9),
//         centerTitle: true,
//       ),
//       body: BlocListener<StepTwoCubit, StepTwoStates>(
//         listener: (context, state) {
//           if (state is StepTwoLoading) {
//             Get.dialog(
//               const Center(child: CircularProgressIndicator()),
//               barrierDismissible: false,
//             );
//           } else {
//             if (Get.isDialogOpen!) Get.back();
//           }
//         },
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // --- مؤشر الخطوات الجديد ---
//               _buildStepper(),
//               const SizedBox(height: 30),

//               // --- القسم الأول: الفئة الرئيسية ---
//               const Text(
//                 "Main Category",
//                 style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 8),
//               BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
//                 builder: (context, state) {
//                   if (state is AllcategoriesLoading) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   List<RCategoryData> categories =
//                       context.read<AllcategoriesCubit>().categories;
//                   return DropdownButtonFormField<RCategoryData>(
//                     decoration: _inputDecoration("Choose a main category"),
//                     value: selectedMainCategory,
//                     items:
//                         categories
//                             .map(
//                               (cat) => DropdownMenuItem(
//                                 value: cat,
//                                 child: Text(cat.displayName ?? ''),
//                               ),
//                             )
//                             .toList(),
//                     onChanged: (value) {
//                       setState(() {
//                         selectedMainCategory = value;
//                         selectedSubCategory = null;
//                       });
//                       if (value != null) {
//                         context.read<SubcategoryCubit>().getSubCategories(
//                           value.id!,
//                         );
//                       }
//                     },
//                   );
//                 },
//               ),
//               const SizedBox(height: 20),

//               // --- القسم الثاني: الفئة الفرعية (تظهر عند الحاجة) ---
//               if (selectedMainCategory != null)
//                 BlocBuilder<SubcategoryCubit, SubcategoryStates>(
//                   builder: (context, state) {
//                     if (state is SubcategoriesLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (state is SubcategoriesLoaded) {
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Sub-Category",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           DropdownButtonFormField<RSubCategoryData>(
//                             decoration: _inputDecoration(
//                               "Choose a sub-category",
//                             ),
//                             value: selectedSubCategory,
//                             items:
//                                 state.subcategories
//                                     .map(
//                                       (sub) => DropdownMenuItem(
//                                         value: sub,
//                                         child: Text(sub.displayName ?? ''),
//                                       ),
//                                     )
//                                     .toList(),
//                             onChanged: (value) {
//                               setState(() => selectedSubCategory = value);
//                               if (value != null) {
//                                 context.read<ServiceCubit>().getServices(
//                                   value.id!,
//                                 );
//                               }
//                             },
//                           ),
//                           const SizedBox(height: 20),
//                         ],
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),

//               // --- القسم الثالث: الخدمات (تظهر عند الحاجة) ---
//               if (selectedSubCategory != null)
//                 BlocBuilder<ServiceCubit, ServiceStates>(
//                   builder: (context, state) {
//                     if (state is ServiceLoading) {
//                       return const Center(child: CircularProgressIndicator());
//                     }
//                     if (state is ServiceLoaded) {
//                       if (state.services.isEmpty) {
//                         return const Center(
//                           child: Text("No services available."),
//                         );
//                       }
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             "Services & Prices",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           ListView.builder(
//                             itemCount: state.services.length,
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemBuilder: (context, index) {
//                               final service = state.services[index];
//                               servicePriceControllers.putIfAbsent(
//                                 service.id!,
//                                 () => TextEditingController(),
//                               );
//                               bool isSelected = selectedServices.contains(
//                                 service.id,
//                               );
//                               return Card(
//                                 margin: const EdgeInsets.symmetric(vertical: 4),
//                                 color:
//                                     isSelected
//                                         ? Colors.purple.withOpacity(0.05)
//                                         : Colors.white,
//                                 child: ListTile(
//                                   leading: Checkbox(
//                                     value: isSelected,
//                                     onChanged: (val) {
//                                       setState(() {
//                                         if (val == true) {
//                                           selectedServices.add(service.id!);
//                                         } else {
//                                           selectedServices.remove(service.id!);
//                                         }
//                                       });
//                                     },
//                                   ),
//                                   title: Text(service.displayName ?? ''),
//                                   trailing:
//                                       isSelected
//                                           ? SizedBox(
//                                             width: 100,
//                                             child: TextField(
//                                               controller:
//                                                   servicePriceControllers[service
//                                                       .id],
//                                               keyboardType:
//                                                   TextInputType.number,
//                                               decoration: _inputDecoration(
//                                                 "Price",
//                                               ),
//                                             ),
//                                           )
//                                           : null,
//                                 ),
//                               );
//                             },
//                           ),
//                         ],
//                       );
//                     }
//                     return const SizedBox.shrink();
//                   },
//                 ),
//             ],
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
//         _buildStepIndicator(number: '2', label: 'Services', isActive: true),
//         _buildStepConnector(),
//         _buildStepIndicator(number: '3', label: 'Done'),
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

//   // دالة مساعدة لتنسيق حقول الإدخال
//   InputDecoration _inputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: BorderSide(color: Colors.grey.shade300),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(12),
//         borderSide: const BorderSide(color: Color(0xFF6F4EC9), width: 2),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_states.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_states.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:repairo_provider/data/models/category_model.dart';
import 'package:repairo_provider/data/models/step_two_request_model.dart';
import 'package:repairo_provider/data/models/subcategory_model.dart';

class StepTwoWidget extends StatefulWidget {
  final bool showSaveButton;

  // 2. قم بتحديث الـ constructor لاستقبال القيمة
  const StepTwoWidget({
    super.key,
    this.showSaveButton = false, // القيمة الافتراضية هي false
  });

  @override
  State<StepTwoWidget> createState() => StepTwoWidgetState();
}

class StepTwoWidgetState extends State<StepTwoWidget> {
  RCategoryData? selectedMainCategory;
  RSubCategoryData? selectedSubCategory;
  Map<String, TextEditingController> servicePriceControllers = {};
  List<String> selectedServices = [];

  ServicesRequestBody? getStepTwoData() {
    if (selectedMainCategory == null ||
        selectedSubCategory == null ||
        selectedServices.isEmpty) {
      Get.snackbar(
        "حقول ناقصة",
        "الرجاء إكمال جميع الحقول المطلوبة.",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
    final servicesList =
        selectedServices.map((id) {
          final controller = servicePriceControllers[id];
          final price =
              double.tryParse(controller?.text.trim() ?? '0.0') ?? 0.0;
          return ServiceData(serviceId: id, price: price);
        }).toList();
    return ServicesRequestBody(
      categoryId: selectedMainCategory!.id!,
      subCategories: [selectedSubCategory!.id!],
      services: servicesList,
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<AllcategoriesCubit>().getAllCategories();
  }

  @override
  void dispose() {
    for (var controller in servicePriceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _saveAndGoBack() {
    final requestBody = getStepTwoData();
    if (requestBody != null) {
      // ✅ استدعاء الدالة الصحيحة من الـ Cubit
      context.read<StepTwoCubit>().steptwo(requestBody);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // مهم للغة العربية
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "اختر الخدمات",
            style: TextStyle(fontFamily: 'Cairo'),
          ),
          backgroundColor: Colors.teal,
          centerTitle: true,
          elevation: 0,
        ),
        body: BlocListener<StepTwoCubit, StepTwoStates>(
          listener: (context, state) {
            if (state is StepTwoLoading) {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                ),
                barrierDismissible: false,
              );
            } else {
              if (Get.isDialogOpen!) Get.back();
            }
            if (state is StepTwoError) {
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStepper(),
                const SizedBox(height: 30),

                // الفئة الرئيسية
                Row(
                  children: [
                    const Text(
                      "الفئة الرئيسية",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(width: 10.w),
                    const Text(
                      "(اختر مهنتك الأساسية)",
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
                  builder: (context, state) {
                    if (state is AllcategoriesLoading) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.teal),
                      );
                    }
                    List<RCategoryData> categories =
                        context.read<AllcategoriesCubit>().categories;
                    return Directionality(
                      textDirection: TextDirection.rtl,
                      child: DropdownButtonFormField<RCategoryData>(
                        decoration: _inputDecoration("اختر فئة رئيسية"),
                        value: selectedMainCategory,
                        items:
                            categories
                                .map(
                                  (cat) => DropdownMenuItem(
                                    value: cat,
                                    child: Text(
                                      cat.displayName ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedMainCategory = value;
                            selectedSubCategory = null;
                            selectedServices.clear();
                          });
                          if (value != null) {
                            context.read<SubcategoryCubit>().getSubCategories(
                              value.id!,
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // الفئة الفرعية
                if (selectedMainCategory != null)
                  BlocBuilder<SubcategoryCubit, SubcategoryStates>(
                    builder: (context, state) {
                      if (state is SubcategoriesLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        );
                      }
                      if (state is SubcategoriesLoaded) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "الفئة الفرعية",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<RSubCategoryData>(
                              decoration: _inputDecoration("اختر فئة فرعية"),
                              value: selectedSubCategory,
                              items:
                                  state.subcategories
                                      .map(
                                        (sub) => DropdownMenuItem(
                                          value: sub,
                                          child: Text(
                                            sub.displayName ?? '',
                                            style: const TextStyle(
                                              fontFamily: 'Cairo',
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                              onChanged: (value) {
                                setState(() => selectedSubCategory = value);
                                if (value != null) {
                                  context.read<ServiceCubit>().getServices(
                                    value.id!,
                                  );
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),

                // الخدمات
                if (selectedSubCategory != null)
                  BlocBuilder<ServiceCubit, ServiceStates>(
                    builder: (context, state) {
                      if (state is ServiceLoading) {
                        return const Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        );
                      }
                      if (state is ServiceLoaded) {
                        if (state.services.isEmpty) {
                          return const Center(
                            child: Text(
                              "لا توجد خدمات متاحة",
                              style: TextStyle(fontFamily: 'Cairo'),
                            ),
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "الخدمات والأسعار",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                Text(
                                  "(يمكنك التعديل لاحقا من حسابك الشخصي)",
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                    fontFamily: 'Cairo',
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ListView.builder(
                              itemCount: state.services.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final service = state.services[index];
                                servicePriceControllers.putIfAbsent(
                                  service.id!,
                                  () => TextEditingController(),
                                );
                                bool isSelected = selectedServices.contains(
                                  service.id,
                                );
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 2,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  color: Colors.white,
                                  child: ListTile(
                                    leading: Checkbox(
                                      activeColor: Colors.teal,
                                      value: isSelected,
                                      onChanged: (val) {
                                        setState(() {
                                          if (val == true) {
                                            selectedServices.add(service.id!);
                                          } else {
                                            selectedServices.remove(
                                              service.id!,
                                            );
                                          }
                                        });
                                      },
                                    ),
                                    title: Text(
                                      service.displayName ?? '',
                                      style: const TextStyle(
                                        fontFamily: 'Cairo',
                                      ),
                                    ),
                                    trailing:
                                        isSelected
                                            ? SizedBox(
                                              width: 100,
                                              child: TextField(
                                                controller:
                                                    servicePriceControllers[service
                                                        .id],
                                                keyboardType:
                                                    TextInputType.number,
                                                decoration: _inputDecoration(
                                                  "السعر",
                                                ),
                                              ),
                                            )
                                            : null,
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    },
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
        _buildStepIndicator(number: '2', label: 'الخدمات', isActive: true),
        _buildStepConnector(),
        _buildStepIndicator(number: '3', label: 'تم'),
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
                      fontFamily: 'Cairo',
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
            fontFamily: 'Cairo',
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

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(fontFamily: 'Cairo', color: Colors.teal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
}
