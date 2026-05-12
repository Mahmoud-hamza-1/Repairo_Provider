import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/TechServicesCubit/tech_services_cubit.dart';
import 'package:repairo_provider/business_logic/TechServicesCubit/tech_services_states.dart';
import 'package:repairo_provider/data/models/tech_services_model.dart';

// class TechServicesScreen extends StatefulWidget {
//   const TechServicesScreen({super.key});

//   @override
//   State<TechServicesScreen> createState() => _TechServicesScreenState();
// }

// class _TechServicesScreenState extends State<TechServicesScreen> {
//   @override
//   void initState() {
//     BlocProvider.of<TechServicesCubit>(context).getTechServices();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'خدمات المهني',
//           style: TextStyle(fontFamily: 'Cairo'),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.teal,
//       ),
//       body: BlocBuilder<TechServicesCubit, TechServicesStates>(
//         builder: (context, state) {
//           if (state is TechServicesLoading) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (state is TechServicesLoaded) {
//             final RTechServicesData techServices = state.techservices;
//             return SingleChildScrollView(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   _buildHeaderCard(techServices),
//                   const SizedBox(height: 20),
//                   _buildServicesList(techServices.services),
//                 ],
//               ),
//             );
//           } else if (state is TechServicesFailed) {
//             return Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'فشل في جلب البيانات: ${state.message}',
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     color: Colors.red,
//                     fontSize: 18,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//               ),
//             );
//           } else {
//             return const Center(
//               child: Text(
//                 'لا توجد بيانات متاحة حاليًا',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.grey,
//                   fontFamily: 'Cairo',
//                 ),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   // بناء بطاقة المعلومات الأساسية
//   Widget _buildHeaderCard(RTechServicesData techServices) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
//       child: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'معلومات الخدمات الأساسية',
//               style: TextStyle(
//                 fontSize: 22,
//                 fontWeight: FontWeight.bold,
//                 fontFamily: 'Cairo',
//                 color: Colors.teal,
//               ),
//             ),
//             const SizedBox(height: 10),
//             _buildInfoRow('معرف الفئة:', techServices.categoryId ?? 'غير محدد'),
//             const SizedBox(height: 8),
//             _buildInfoRow(
//               'فئات فرعية:',
//               techServices.subCategoryIds?.join(', ') ?? 'لا توجد',
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // دالة مساعدة لبناء صف من المعلومات
//   Widget _buildInfoRow(String label, String value) {
//     return Row(
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//             fontFamily: 'Cairo',
//             color: Colors.black87,
//           ),
//         ),
//         const SizedBox(width: 8),
//         Expanded(
//           child: Text(
//             value,
//             style: const TextStyle(
//               fontSize: 16,
//               fontFamily: 'Cairo',
//               color: Colors.black54,
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   // بناء قائمة الخدمات
//   Widget _buildServicesList(List<Services>? services) {
//     if (services == null || services.isEmpty) {
//       return const Center(
//         child: Text(
//           'لا توجد خدمات متاحة',
//           style: TextStyle(
//             fontSize: 16,
//             color: Colors.grey,
//             fontFamily: 'Cairo',
//           ),
//         ),
//       );
//     }
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'الخدمات المقدمة',
//           style: TextStyle(
//             fontSize: 22,
//             fontWeight: FontWeight.bold,
//             fontFamily: 'Cairo',
//             color: Colors.teal,
//           ),
//         ),
//         const SizedBox(height: 10),
//         ListView.builder(
//           physics: const NeverScrollableScrollPhysics(),
//           shrinkWrap: true,
//           itemCount: services.length,
//           itemBuilder: (context, index) {
//             final service = services[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(vertical: 8),
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: ListTile(
//                 leading: const Icon(Icons.build_circle, color: Colors.teal),
//                 title: Text(
//                   'معرف الخدمة: ${service.serviceId ?? 'غير محدد'}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//                 trailing: Text(
//                   '${service.price ?? 'غير محدد'} \$',
//                   style: const TextStyle(
//                     color: Colors.green,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                     fontFamily: 'Cairo',
//                   ),
//                 ),
//               ),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// ... imports
class TechServicesScreen extends StatefulWidget {
  const TechServicesScreen({super.key});

  @override
  _TechServicesScreenState createState() => _TechServicesScreenState();
}

class _TechServicesScreenState extends State<TechServicesScreen> {
  // متغيرات لتخزين الـ TextEditingControllers لكل خدمة
  // الهدف: حفظ القيمة المدخلة لكل خدمة لتعديل السعر بسهولة
  final Map<String, TextEditingController> _priceControllers = {};

  Widget _buildHeaderCard(RTechServicesData techServices) {
    return Card(
      elevation: 4, // ارتفاع الكارت عن الخلفية لإعطاء تأثير الظل
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ), // زوايا مستديرة
      child: Padding(
        padding: const EdgeInsets.all(20.0), // مسافة داخلية للكارت
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'معلومات الخدمات الأساسية',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: Colors.teal,
              ),
            ),
            const SizedBox(height: 10),
            // صف لعرض معرف الفئة
            _buildInfoRow('معرف الفئة:', techServices.categoryId ?? 'غير محدد'),
            const SizedBox(height: 8),
            // صف لعرض الفئات الفرعية، مفصولة بفواصل
            _buildInfoRow(
              'فئات فرعية:',
              techServices.subCategoryIds?.join(', ') ?? 'لا توجد',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
            color: Colors.black87,
          ),
        ),
        const SizedBox(width: 8), // مسافة بين النصين
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: 'Cairo',
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    BlocProvider.of<TechServicesCubit>(context).getTechServices();
    super.initState();
  }

  @override
  void dispose() {
    // التخلص من جميع الـ controllers عند التخلص من الشاشة لتجنب تسرب الذاكرة
    _priceControllers.forEach((key, controller) => controller.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'خدمات المهني',
          style: TextStyle(fontFamily: 'Cairo'), // استخدام خط Cairo
        ),
        centerTitle: true,
        backgroundColor: Colors.teal, // اللون الأساسي
      ),
      body: BlocListener<TechServicesCubit, TechServicesStates>(
        listener: (context, state) {
          // الاستماع لحالات الحفظ
          if (state is TechServicesSaved) {
            // حالة نجاح الحفظ
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم حفظ التعديلات بنجاح!')),
            );
          } else if (state is TechServicesSaveFailed) {
            // حالة فشل الحفظ
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('فشل الحفظ: ${state.message}')),
            );
          }
        },
        child: BlocBuilder<TechServicesCubit, TechServicesStates>(
          builder: (context, state) {
            if (state is TechServicesLoading || state is TechServicesSaving) {
              // عرض مؤشر التحميل أثناء جلب البيانات أو الحفظ
              return const Center(child: CircularProgressIndicator());
            } else if (state is TechServicesLoaded) {
              // البيانات جاهزة للعرض
              final RTechServicesData techServices = state.techservices;

              // تهيئة الـ controllers لكل خدمة إذا لم تكن موجودة مسبقاً
              for (var service in techServices.services ?? []) {
                if (!_priceControllers.containsKey(service.serviceId)) {
                  _priceControllers[service.serviceId!] = TextEditingController(
                    text: service.price?.toString(),
                  );
                }
              }

              // عرض المحتوى الرئيسي للشاشة
              return _buildContent(context, techServices);
            } else if (state is TechServicesFailed) {
              // حالة وجود خطأ عند جلب الخدمات
              return Center(child: Text('حدث خطأ: ${state.message}'));
            } else {
              // الحالة الابتدائية أو لا توجد بيانات
              return const Center(child: Text('لا توجد بيانات بعد'));
            }
          },
        ),
      ),
    );
  }

  // بناء المحتوى الرئيسي للشاشة
  Widget _buildContent(BuildContext context, RTechServicesData techServices) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // كارت عرض بيانات أساسية (يمكن إضافة معلومات أخرى لاحقاً)
          _buildHeaderCard(techServices),
          const SizedBox(height: 20),
          // قائمة الخدمات القابلة للتعديل
          _buildEditableServicesList(techServices),
          const SizedBox(height: 20),
          // زر حفظ التعديلات
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                _saveChanges(context, techServices);
              },
              icon: const Icon(Icons.save),
              label: const Text(
                'حفظ التعديلات',
                style: TextStyle(fontFamily: 'Cairo'),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // بناء قائمة الخدمات القابلة للتعديل
  Widget _buildEditableServicesList(RTechServicesData techServices) {
    if (techServices.services == null || techServices.services!.isEmpty) {
      // حالة عدم وجود خدمات
      return const Center(child: Text('لا توجد خدمات لتعديلها'));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تعديل أسعار الخدمات',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 10),
        // استخدام ListView.builder مع shrinkWrap لتجنب مشاكل الارتفاع داخل Column
        ListView.builder(
          physics: const NeverScrollableScrollPhysics(), // منع Scroll داخلي
          shrinkWrap: true, // يسمح بالارتفاع المناسب داخل Column
          itemCount: techServices.services!.length,
          itemBuilder: (context, index) {
            final service = techServices.services![index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Icon(Icons.build_circle, color: Colors.teal),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'الخدمة: ${service.serviceId}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                    // TextField لتعديل السعر
                    SizedBox(
                      width: 100,
                      child: TextField(
                        controller: _priceControllers[service.serviceId],
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'السعر (\$)',
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  // حفظ التعديلات وإرسالها عبر الـ Cubit
  void _saveChanges(BuildContext context, RTechServicesData currentServices) {
    final List<Services> updatedServices = [];

    // المرور على كل خدمة وتحديث السعر إذا تم تعديله
    currentServices.services?.forEach((service) {
      final priceController = _priceControllers[service.serviceId];
      if (priceController != null && priceController.text.isNotEmpty) {
        updatedServices.add(
          Services(
            serviceId: service.serviceId,
            price: int.tryParse(priceController.text) ?? service.price,
          ),
        );
      } else {
        // الاحتفاظ بالسعر القديم إذا لم يتم التعديل
        updatedServices.add(service);
      }
    });

    // إنشاء نسخة محدثة من البيانات لإرسالها إلى الـ Cubit
    final RTechServicesData updatedData = RTechServicesData(
      categoryId: currentServices.categoryId,
      subCategoryIds: currentServices.subCategoryIds,
      services: updatedServices,
    );

    // استدعاء دالة الـ Cubit لتحديث البيانات على السيرفر
    BlocProvider.of<TechServicesCubit>(context).updateTechServices(updatedData);
  }
}
