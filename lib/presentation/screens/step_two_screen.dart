import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/utils.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcategories_states.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_states.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_states.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_states.dart';
import 'package:repairo_provider/data/models/category_model.dart';
import 'package:repairo_provider/data/models/service_model.dart';
import 'package:repairo_provider/data/models/step_two_request_model.dart';
import 'package:repairo_provider/data/models/subcategory_model.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';

class StepTwoWidget extends StatefulWidget {
  const StepTwoWidget({super.key});

  @override
  State<StepTwoWidget> createState() => StepTwoWidgetState();
}

class StepTwoWidgetState extends State<StepTwoWidget> {
  RCategoryData? selectedMainCategory;
  RSubCategoryData? selectedSubCategory;
  List<RServiceData> services = [];
  Map<String, TextEditingController> servicePriceControllers = {};
  List<String> selectedServices = [];
  late List categories;

  ServicesRequestBody? getStepTwoData() {
    if (selectedMainCategory == null ||
        selectedSubCategory == null ||
        selectedServices.isEmpty) {
      Get.snackbar(
        "Missing fields",
        "Please fill all fields and choose services",
        backgroundColor: Colors.orangeAccent,
        colorText: Colors.white,
      );
      return null;
    }

    final servicesList =
        selectedServices.map((id) {
          final controller =
              servicePriceControllers.entries
                  .firstWhere(
                    (entry) => entry.key == id || entry.key.contains(id),
                  )
                  .value;

          final price = double.tryParse(controller.text.trim()) ?? 0.0;

          return ServiceData(serviceId: id, price: price);
        }).toList();

    return ServicesRequestBody(
      categoryId: selectedMainCategory!.id!,
      subCategories: [selectedSubCategory!.id!],
      services: servicesList,
    );
  }

  // Map<String, dynamic>? getStepTwoData() {
  //   if (selectedMainCategory.isNull ||
  //       selectedSubCategory.isNull ||
  //       !selectedServices.isNotEmpty) {
  //     Get.snackbar(
  //       "Missing fields",
  //       "Please fill all fields and choose an image",
  //       backgroundColor: Colors.orangeAccent,
  //       colorText: Colors.white,
  //     );
  //     return null;
  //   }

  //   return {
  //     "category": selectedMainCategory,
  //     "subcategory": selectedSubCategory,
  //     "services": []
  //   };
  // }

  @override
  void initState() {
    context.read<AllcategoriesCubit>().getAllCategories();
    super.initState();
  }

  @override
  void dispose() {
    for (var controller in servicePriceControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<StepTwoCubit, StepTwoStates>(
      listener: (context, state) {
        if (state is StepTwoLoading) {
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
        if (state is StepTwoError) {
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Main Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              BlocBuilder<AllcategoriesCubit, AllcategoriesStates>(
                builder: (context, state) {
                  if (state is AllcategoriesLoaded) {
                    return DropdownButtonFormField<RCategoryData>(
                      hint: Text("choose category"),
                      value: selectedMainCategory,
                      items:
                          context
                              .read<AllcategoriesCubit>()
                              .categories
                              .map(
                                (category) => DropdownMenuItem<RCategoryData>(
                                  value: category,
                                  child: Text(category.displayName ?? 'All'),
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedMainCategory = value!;
                          selectedSubCategory = null;
                        });

                        Future.microtask(() {
                          context.read<SubcategoryCubit>().getSubCategories(
                            value!.id!,
                          );
                        });
                      },
                    );
                  }
                  return DropdownButtonFormField<String>(
                    hint: Text("choose category"),
                    value: 'All',
                    items: [
                      DropdownMenuItem<String>(
                        value: 'All',
                        child: Text('All'),
                      ),
                    ],
                    onChanged: (val) {},
                  );
                },
              ),
              const SizedBox(height: 16),
              if (selectedMainCategory != null)
                BlocBuilder<SubcategoryCubit, SubcategoryStates>(
                  builder: (context, state) {
                    if (state is SubcategoriesLoaded) {
                      print("sucesssssss");
                      final subcategories = state.subcategories;
                      print(subcategories);
                      if (selectedSubCategory != null &&
                          !subcategories.any(
                            (e) => e.id == selectedSubCategory!.id,
                          )) {
                        selectedSubCategory = null;
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Sub Category",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<RSubCategoryData>(
                            value: selectedSubCategory,
                            hint: const Text("choose subcategory"),
                            items:
                                subcategories.map((subcategory) {
                                  return DropdownMenuItem<RSubCategoryData>(
                                    value: subcategory,
                                    child: Text(
                                      subcategory.displayName ?? 'All',
                                    ),
                                  );
                                }).toList(),
                            onChanged: (val) {
                              setState(() {
                                selectedSubCategory = val!;
                              });

                              Get.snackbar(
                                "please select one service atleast",
                                "you can edit your informations later",
                              );

                              Future.microtask(() {
                                context.read<ServiceCubit>().getServices(
                                  selectedSubCategory!.id!,
                                );
                              });
                            },
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
              const SizedBox(height: 24),
              if (selectedSubCategory != null)
                BlocBuilder<ServiceCubit, ServiceStates>(
                  builder: (context, state) {
                    if (state is ServiceLoaded) {
                      return Visibility(
                        visible: state.services.isNotEmpty,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "choose services and prices",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            ...state.services.map((service) {
                              servicePriceControllers.putIfAbsent(
                                service.id!,
                                () => TextEditingController(),
                              );
                              return Row(
                                children: [
                                  Checkbox(
                                    value: selectedServices.contains(
                                      service.id,
                                    ),
                                    onChanged: (val) {
                                      setState(() {
                                        if (val == true) {
                                          selectedServices.add(service.id!);
                                        } else {
                                          selectedServices.remove(service.id!);
                                          servicePriceControllers[service]
                                              ?.clear();
                                        }
                                      });
                                    },
                                  ),
                                  Expanded(child: Text(service.displayName!)),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 100,
                                    child: TextField(
                                      controller:
                                          servicePriceControllers[service.id],
                                      enabled: selectedServices.contains(
                                        service.id,
                                      ),
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        hintText: "السعر",
                                        isDense: true,
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),

                            const SizedBox(height: 24),
                          ],
                        ),
                      );
                    }
                    return SizedBox();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
