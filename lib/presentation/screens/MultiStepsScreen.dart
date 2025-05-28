import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_states.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_states.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_states.dart';
import 'package:repairo_provider/presentation/screens/main_screen.dart';
import 'package:repairo_provider/presentation/screens/step_one_screen.dart';
import 'package:repairo_provider/presentation/screens/step_three_screen.dart';
import 'package:repairo_provider/presentation/screens/step_two_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MultiStepsScreen extends StatefulWidget {
  MultiStepsScreen({super.key});
  @override
  State<MultiStepsScreen> createState() => MultiStepsScreenState();
}

class MultiStepsScreenState extends State<MultiStepsScreen> {
  final GlobalKey<StepOneWidgetState> stepOneKey = GlobalKey();
  final GlobalKey<StepTwoWidgetState> stepTwoKey = GlobalKey();
  final GlobalKey<StepThreeWidgetState> stepThreeKey = GlobalKey();

  get selectedImage => null;
  int currentStep = 0;
  static final PageController _pageController = PageController();

  void previousPage() {
    if (currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      final page = _pageController.page?.round() ?? 0;
      if (currentStep != page) {
        setState(() {
          currentStep = page;
        });
      }
    });
  }

  void _handleFirstStep() {
    final data = stepOneKey.currentState?.getStepOneData();
    if (data != null) {
      context.read<StepOneCubit>().stepone(
        data['full_name'],
        data['image_file'],
        data['address'],
      );
    }
  }

  void _handleSecondStep() {
    final data = stepTwoKey.currentState?.getStepTwoData();
    if (data != null) {
      print(data.toJson()); // للتأكد
      context.read<StepTwoCubit>().steptwo(data);
    }
  }

  void _handleThirdStep() {
    final idImage = stepThreeKey.currentState?.getStepThreeData();
    if (idImage != null) {
      context.read<StepThreeCubit>().stepthree(idImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<StepOneCubit, StepOneStates>(
          listener: (context, state) {
            if (state is StepOneSuccess && currentStep == 0) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          },
        ),
        BlocListener<StepTwoCubit, StepTwoStates>(
          listener: (context, state) {
            if (state is StepTwoSuccess && currentStep == 1) {
              _pageController.nextPage(
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              );
            }
          },
        ),
        BlocListener<StepThreeCubit, StepThreeStates>(
          listener: (context, state) {
            if (state is StepThreeSuccess && currentStep == 2) {
              Get.back();
              Get.toNamed("mainscreen");
              //Get.to(() => MainScreen());
              // _pageController.nextPage(
              //   duration: Duration(milliseconds: 300),
              //   curve: Curves.ease,
              // );
            }
          },
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: const Color(0xFFF8F9FD),

        body: Column(
          children: [
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    currentStep = index;
                  });
                },
                children: [
                  StepOneWidget(key: stepOneKey),
                  StepTwoWidget(key: stepTwoKey),
                  StepThreeWidget(key: stepThreeKey),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                      right: 16,
                      left: 16,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurpleAccent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          switch (currentStep) {
                            case 0:
                              _handleFirstStep();
                              break;
                            case 1:
                              _handleSecondStep();
                              break;
                            case 2:
                              _handleThirdStep();
                              break;
                          }
                        },
                        child: Text(
                          currentStep == 2 ? "Submit" : "Next",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
