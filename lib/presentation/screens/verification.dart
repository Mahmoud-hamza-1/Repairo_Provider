import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:repairo_provider/business_logic/AccountStatusCubit/account_status_cubit.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_cubit.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_states.dart';
import 'package:repairo_provider/data/repository/account_status_repository.dart';
import 'package:repairo_provider/data/web_services/account_status_webservice.dart';
import 'package:repairo_provider/presentation/screens/staging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Verification extends StatefulWidget {
  final String phone;
  const Verification({super.key, required this.phone});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  late Timer _timer;
  int _start = 60;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    // يجب إيقاف الـ Timer عند إغلاق الـ Widget لتجنب تسرب الذاكرة
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(oneSec, (Timer timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<VerificationCubit, VerificationStates>(
      listener: (context, state) {
        if (state is VerificationSuccess) {
          Get.offAll(
            () => BlocProvider(
              create:
                  (context) => AccountStatusCubit(
                    AccountStatusRepository(AccountStatusWebservice()),
                  ),
              child: Staging(),
            ),
          );

          // Get.toNamed("MultiStepProfileScreen");
        }
        if (state is VerificationLoading) {
          Get.defaultDialog(
            title: "...جاري التحميل ",
            titleStyle: TextStyle(fontFamily: "Cairo"),
            content: const Column(
              children: [
                CircularProgressIndicator(color: Colors.teal),
                SizedBox(height: 10),
                Text("الرجاء الانتظار.", style: TextStyle(fontFamily: "Cairo")),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          if (Get.isDialogOpen!) {
            Get.back();
          }
        }

        if (state is VerificationError) {
          Get.snackbar(
            "Error",
            state.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },

      child: BlocBuilder<VerificationCubit, VerificationStates>(
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(top: 70, left: 8, right: 8),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: CircleAvatar(
                              backgroundColor: Colors.grey[300],
                              radius: 14,
                              child: Icon(Icons.arrow_back_ios_new, size: 16),
                            ),
                          ),
                          SizedBox(width: 12),
                          // IconButton(
                          //     onPressed: () {},
                          //     icon: const Icon(
                          //       Icons.arrow_back_ios_new,
                          //       size: 16,
                          //     )),
                          const Text(
                            "تحقق من رقم هاتفك",
                            style: TextStyle(fontSize: 24, fontFamily: "Cairo"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    SizedBox(
                      width: 200.w,
                      height: 120.h,
                      child: Lottie.asset(
                        'assets/images/lottie/login.json',
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 96.h),
                    Column(
                      children: [
                        Text(
                          " +963أدخل الرمز الذي تم إرساله إلى ${widget.phone}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: "Cairo",
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 32.h),
                    OtpTextField(
                      focusedBorderColor: Colors.teal,

                      borderWidth: 1,
                      fillColor: Colors.grey,
                      cursorColor: Colors.grey,
                      showCursor: false,
                      borderRadius: BorderRadius.circular(10),
                      numberOfFields: 4,
                      borderColor: Colors.teal,
                      showFieldAsBox: true,
                      onCodeChanged: (String code) {},
                      onSubmit: (String verificationCode) async {
                        final prefs = await SharedPreferences.getInstance();
                        //var phone = prefs.getString('phone');

                        context.read<VerificationCubit>().verify(
                          widget.phone,
                          verificationCode,
                          "lkl",
                        );
                      }, // end onSubmit
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "  هذا يساعد في التحقق من هوية المستخدمين ",
                      style: TextStyle(fontFamily: "Cairo"),
                    ),

                    _start != 0
                        ? Text(
                          "00:$_start يمكنك طلب إعادة الإرسال بعد",
                          style: TextStyle(fontFamily: "Cairo"),
                        )
                        : TextButton(
                          onPressed: () {
                            setState(() {
                              startTimer();
                            });
                          },
                          child: const Text(
                            "إعادة إرسال الرمز",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Cairo",
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                          ),
                        ),
                    const SizedBox(height: 70),
                    // CustomElevatedButton(onpressed: () {}, text: 'Confirm')
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
