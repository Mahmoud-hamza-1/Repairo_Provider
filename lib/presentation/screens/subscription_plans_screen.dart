import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/Subscription/plans_bloc.dart';
import 'package:repairo_provider/business_logic/Subscription/plans_state.dart';
import 'package:repairo_provider/business_logic/Subscription/subscribe_bloc.dart';
import 'package:repairo_provider/business_logic/Subscription/subscribe_event.dart';
import 'package:repairo_provider/business_logic/Subscription/subscribe_state.dart';
import 'package:repairo_provider/data/models/subscription_plan.dart';

class SubscriptionPlansScreen extends StatelessWidget {
  const SubscriptionPlansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('باقات الاشتراك')),
      // نستخدم BlocListener للاستماع لحالة الاشتراك (للرسائل والتنبيهات)
      body: BlocListener<SubscribeBloc, SubscribeState>(
        listener: (context, state) {
          if (state is SubscribeInProgress) {
            // إظهار مؤشر تحميل عند الضغط على زر الاشتراك
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (context) => const Center(child: CircularProgressIndicator()),
            );
          } else if (state is SubscribeSuccess) {
            Navigator.of(context).pop(); // إخفاء مؤشر التحميل
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم الاشتراك بنجاح!'),
                backgroundColor: Colors.green,
              ),
            );
            // يمكنك الانتقال لشاشة أخرى بعد نجاح الاشتراك
            // Navigator.of(context).pushReplacementNamed('mainscreen');
          } else if (state is SubscribeFailure) {
            Navigator.of(context).pop(); // إخفاء مؤشر التحميل
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('فشل الاشتراك: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: buildPlansList(),
      ),
    );
  }

  // ودجت لعرض قائمة الباقات
  Widget buildPlansList() {
    // نستخدم BlocBuilder لإعادة بناء الواجهة بناءً على حالة جلب الباقات
    return BlocBuilder<PlansBloc, PlansState>(
      builder: (context, state) {
        if (state is PlansLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is PlansLoaded) {
          if (state.plans.isEmpty) {
            return const Center(child: Text('لا توجد باقات متاحة حاليًا.'));
          }
          return ListView.builder(
            itemCount: state.plans.length,
            itemBuilder: (context, index) {
              final plan = state.plans[index];
              return PlanCard(plan: plan);
            },
          );
        }
        if (state is PlansError) {
          return Center(child: Text('حدث خطأ: ${state.message}'));
        }
        return const Center(child: Text('جار التحميل...'));
      },
    );
  }
}

// ودجت لعرض تفاصيل الباقة الواحدة في بطاقة
class PlanCard extends StatelessWidget {
  final SubscriptionPlan plan;

  const PlanCard({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(plan.description),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${plan.price} ريال',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text('لمدة ${plan.durationDays} يوم'),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // إرسال حدث للاشتراك في هذه الباقة
                  context.read<SubscribeBloc>().add(
                    SubscribeRequested(
                      planId: plan.id,
                      paymentMethod: 'electronic', // يمكنك تغييرها لاحقًا
                    ),
                  );
                },
                child: const Text('اشترك الآن'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
