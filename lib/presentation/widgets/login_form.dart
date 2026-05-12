import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:lottie/lottie.dart';
import 'package:repairo_provider/business_logic/LoginCubit/login_cubit.dart';
import 'package:repairo_provider/business_logic/LoginCubit/login_states.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
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

        if (state is LoginError) {
          Get.snackbar(
            "Error",
            state.message,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      },
      child: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.only(top: 80),
            child: Column(
              children: [
                Text(
                  " تسجيل دخول / إنشاء حساب فني",
                  style: TextStyle(
                    fontFamily: "Cairo",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),

                SizedBox(
                  width: 200.w,
                  height: 120.h,
                  child: Lottie.asset(
                    'assets/images/lottie/loginn.json',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),

                // const Text(
                //   "Hello User !",
                //   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                // ),
                // const SizedBox(
                //   height: 16,
                // ),
                // const Text(
                //   "Welcome Back, you have been ",
                //   style: TextStyle(fontSize: 16),
                // ),
                SizedBox(height: 40.h),
                Padding(
                  padding: const EdgeInsets.only(left: 260),
                  child: const Text(
                    "رقم هاتفك",
                    style: TextStyle(fontSize: 16, fontFamily: 'Cairo'),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: IntlPhoneField(
                    //disableLengthCheck: true,
                    controller: context.read<LoginCubit>().phoneController,
                    decoration: InputDecoration(
                      hintStyle: const TextStyle(fontSize: 14),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 242, 244, 245),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 20.0,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                    ),
                    initialCountryCode: 'SY',

                    // الدولة الافتراضية
                    // onChanged: (value) {
                    //   print(value);
                    // },
                  ),
                ),
                // CustomTextFormField(
                //   isPass: false,
                //   controller: context.read<LoginCubit>().phoneController,
                //   hinttext: 'Phone Number',
                //   suffixicon: const Icon(Icons.phone_android_rounded),
                //   keybordtype: TextInputType.phone,
                //   valid: (value) {
                //     if (value == null || value.isEmpty) {
                //       return 'Please enter your phone';
                //     }
                //     return null;
                //   },
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: CustomElevatedButton(
                    text: '  <   التالي',
                    onpressed: () async {
                      print(context.read<LoginCubit>().phoneController.text);
                      context.read<LoginCubit>().login(
                        context.read<LoginCubit>().phoneController.text,
                      );
                    },
                  ),
                ),

                if (state is LoginError)
                  Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                Spacer(),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "الدخول كزائر",
                    style: TextStyle(
                      fontFamily: "Cairo",
                      fontSize: 12,
                      color: Colors.teal,
                    ),
                  ),
                ),
                Text(
                  "ترغب بالحصول على مساعدة لتسجيل الدخول ؟",
                  style: TextStyle(fontFamily: "Cairo", fontSize: 12),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: TextButton(
                    onPressed: () {},
                    child: Text(
                      "support@repairo.com",
                      style: TextStyle(
                        fontFamily: "Cairo",
                        fontSize: 12,
                        color: Colors.teal,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.teal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:intl_phone_field/intl_phone_field.dart';

// class LoginForm extends StatelessWidget {
//   const LoginForm({super.key});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             IntlPhoneField(
//               decoration: InputDecoration(

//                 //labelText: 'رقم هاتفك',
//                 border: OutlineInputBorder(
//                   borderSide: BorderSide(),
//                 ),
//               ),
//               initialCountryCode: 'AE', // الدولة الافتراضية
//               onChanged: (phone) {
//                 print(phone.completeNumber); // رقم كامل مع الكود
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                // shape: Outline,
//                 backgroundColor: Colors.purple,
//                 foregroundColor: Colors.white,
//                 minimumSize: Size(double.infinity, 50),
//               ),
//               onPressed: () {},
//               child: Text('التالي'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
