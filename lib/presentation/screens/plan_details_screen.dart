import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:repairo_provider/business_logic/SubscriptionCubit/subscription_cubit.dart';
import 'package:repairo_provider/business_logic/planDataCubit/plan_data_cubit.dart';
import 'package:repairo_provider/business_logic/planDataCubit/plan_data_states.dart';
import 'package:repairo_provider/data/models/plan_details_model.dart';
import 'package:repairo_provider/data/repository/subscription_plan_repository.dart';
import 'package:repairo_provider/data/web_services/subscription_plan_webservice.dart';
import 'package:repairo_provider/presentation/screens/electronic_payment_screen.dart';
import 'package:repairo_provider/presentation/widgets/custom_elevated_button.dart';

class PlanDetailsPage extends StatefulWidget {
  final String id;
  final String name;
  final bool issubscribed;

  const PlanDetailsPage({
    super.key,
    required this.id,
    required this.name,
    required this.issubscribed,
  });

  @override
  State<PlanDetailsPage> createState() => _PlanDetailsPageState();
}

class _PlanDetailsPageState extends State<PlanDetailsPage> {
  late RPlanDetailsData plan;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<PlanDataCubit>(context).getPlanData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            widget.name,
            style: GoogleFonts.cairo(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocBuilder<PlanDataCubit, PlanDataStates>(
            builder: (context, state) {
              if (state is PlanDataLoaded) {
                plan = state.Plandata;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      plan.name ?? "",
                      style: GoogleFonts.cairo(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      plan.description ?? "",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "السعر: ${plan.price} ل.س",
                      style: GoogleFonts.cairo(
                        fontSize: 18,
                        color: Colors.teal,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "المدة: ${plan.durationDays} أيام",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const Spacer(),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.issubscribed == false
                                  ? Colors.teal
                                  : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed:
                            widget.issubscribed == false
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
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontFamily: "Cairo",
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    confirm: Padding(
                                      padding: const EdgeInsets.symmetric(
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
                                                    .read<SubscriptionCubit>()
                                                    .subscribeplan(
                                                      planid: plan.id!,
                                                      paymenttype: "wallet",
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
                                                      planid: plan.id,
                                                      paymentmethod:
                                                          "electronic",
                                                      amount: plan.price,
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
                    ),
                  ],
                );
              } else if (state is PlanDataFailed) {
                return Center(
                  child: Text(
                    "تعذر جلب تفاصيل الخطة",
                    style: GoogleFonts.cairo(fontSize: 16),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
