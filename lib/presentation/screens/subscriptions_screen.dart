import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairo_provider/business_logic/PlansCubit/plans_cubit.dart';
import 'package:repairo_provider/business_logic/PlansCubit/plans_states.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_states.dart';
import 'package:repairo_provider/business_logic/planDataCubit/plan_data_cubit.dart';
import 'package:repairo_provider/data/repository/plan_details_repository.dart';
import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';
import 'package:repairo_provider/data/web_services/plan_details_webservice.dart';
import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';
import 'package:repairo_provider/presentation/screens/electronic_payment_screen.dart';
import 'package:repairo_provider/presentation/screens/plan_details_screen.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubscriptionPlansScreen extends StatefulWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  State<SubscriptionPlansScreen> createState() =>
      _SubscriptionPlansScreenState();
}

class _SubscriptionPlansScreenState extends State<SubscriptionPlansScreen> {
  bool? isSubscribed;

  Future<void> _loadSubscription() async {
    final prefs = await SharedPreferences.getInstance();
    final sub = prefs.getBool('isSubscribed') ?? false;
    setState(() {
      isSubscribed = sub;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AllplansCubit>(context).getAllplans();
    _loadSubscription();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // اللغة العربية
      child: BlocListener<SubscriptionCubit, SubscriptionPlanStates>(
        listener: (context, state) {
          if (state is SubscriptionPlanLoading) {
            Get.defaultDialog(
              title: "...جاري التحميل ",
              titleStyle: const TextStyle(fontFamily: "Cairo"),
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
          } else if (state is SubscriptionPlanSuccess) {
            Get.back();
            Get.defaultDialog(
              title: '',
              titlePadding: const EdgeInsets.all(0),
              content: Column(
                children: [
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: SvgPicture.asset(
                      (state).message == ""
                          ? "assets/images/svg/checkc.svg"
                          : "assets/images/png/warning.png",
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    (state).message == ""
                        ? "تم الدفع بنجاح"
                        : "فشلت عملية الدفع",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Cairo",
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              confirm: Padding(
                padding: const EdgeInsets.only(left: 63, right: 63, bottom: 12),
                child: CustomElevatedButton(
                  text: 'رجوع للرئيسية',
                  onpressed: () {
                    Get.toNamed("mainscreen");
                  },
                ),
              ),
              barrierDismissible: false,
            );
          } else {
            if (Get.isDialogOpen!) {
              Get.back();
            }
          }

          if (state is SubscriptionPlanError) {
            Get.snackbar(
              "خطأ",
              state.message,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
              snackPosition: SnackPosition.TOP,
              titleText: const Text(
                "خطأ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Cairo",
                ),
              ),
              messageText: Text(
                state.message,
                style: const TextStyle(
                  fontFamily: "Cairo",
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text("خطط الاشتراك", style: GoogleFonts.cairo()),
            backgroundColor: Colors.teal,
          ),
          body: BlocBuilder<AllplansCubit, AllplansStates>(
            builder: (context, state) {
              if (state is AllplansLoaded) {
                final allplans = state.plans;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: allplans.length,
                  itemBuilder: (context, index) {
                    final plan = allplans[index];
                    return InkWell(
                      onTap: () {
                        Get.to(
                          () => BlocProvider(
                            create:
                                (_) => PlanDataCubit(
                                  PlanDataRepository(
                                    planDataWebservices: PlanDataWebservices(),
                                  ),
                                ),
                            child: PlanDetailsPage(
                              id: plan.id!,
                              name: plan.name!,
                              issubscribed: isSubscribed!,
                            ),
                          ),
                        );
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                plan.name!,
                                style: GoogleFonts.cairo(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                plan.description!,
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: Colors.grey[700],
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${plan.price} ليرة/ ${plan.durationDays} يوم",
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          isSubscribed == false
                                              ? Colors.teal
                                              : Colors.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed:
                                        isSubscribed == false
                                            ? () {
                                              Get.defaultDialog(
                                                title: '',
                                                titlePadding: EdgeInsets.zero,
                                                content: Column(
                                                  children: [
                                                    SizedBox(
                                                      width: 48,
                                                      height: 48,
                                                      child: Image.asset(
                                                        "assets/images/png/warning.png",
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      "كيف ترغب بتسديد المبلغ المستحق ؟",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        fontFamily: "Cairo",
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                confirm: Padding(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 16,
                                                        vertical: 12,
                                                      ),
                                                  child: Row(
                                                    children: [
                                                      Expanded(
                                                        child: CustomElevatedButton(
                                                          text: 'محفظة',
                                                          onpressed: () {
                                                            context
                                                                .read<
                                                                  SubscriptionCubit
                                                                >()
                                                                .subscribeplan(
                                                                  planid:
                                                                      plan.id!,
                                                                  paymenttype:
                                                                      "wallet",
                                                                );
                                                          },
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Expanded(
                                                        child: CustomElevatedButton(
                                                          text: 'عبر بطاقة',

                                                          onpressed: () {
                                                            Get.to(
                                                              () => BlocProvider(
                                                                create:
                                                                    (
                                                                      context,
                                                                    ) => SubscriptionCubit(
                                                                      SubscriptionPlanRepository(
                                                                        SubscriptionPlanWebservice(),
                                                                      ),
                                                                    ),
                                                                child: PaymentScreen(
                                                                  planid:
                                                                      plan.id,
                                                                  paymentmethod:
                                                                      "electronic",
                                                                  amount:
                                                                      plan.price,
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                barrierDismissible: false,
                                              );

                                              // ScaffoldMessenger.of(
                                              //   context,
                                              // ).showSnackBar(
                                              //   SnackBar(
                                              //     content: Text(
                                              //       "تم اختيار ${plan.name}",
                                              //       style: GoogleFonts.cairo(),
                                              //     ),
                                              //   ),
                                              // );
                                            }
                                            : () {},

                                    child: Text(
                                      "اشترك",
                                      style: GoogleFonts.cairo(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is AllplansFailed) {
                return Center(
                  child: Text(
                    "لا يوجد خطط لعرضها ! ",
                    style: TextStyle(fontFamily: "Cairo"),
                  ),
                );
              }
              return Center(
                child: CircularProgressIndicator(color: Colors.teal),
              );
            },
          ),
        ),
      ),
    );
  }
}
