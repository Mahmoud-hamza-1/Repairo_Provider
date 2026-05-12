// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
// import 'package:repairo_provider/business_logic/ChatMessagesCubit/chat_cubit.dart';
// import 'package:repairo_provider/business_logic/LoginCubit/login_cubit.dart';
// import 'package:repairo_provider/business_logic/NotificationCubit/notification_cubit.dart';
// import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
// import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
// import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
// import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
// import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
// import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
// import 'package:repairo_provider/business_logic/VerifyCubit/verification_cubit.dart';
// import 'package:repairo_provider/data/repository/categories_repository.dart';
// import 'package:repairo_provider/data/repository/chat_repsitory.dart';
// import 'package:repairo_provider/data/repository/login_repository.dart';
// import 'package:repairo_provider/data/repository/notificcation_repository.dart';
// import 'package:repairo_provider/data/repository/profile_repository.dart';
// import 'package:repairo_provider/data/repository/services_repository.dart';
// import 'package:repairo_provider/data/repository/step_one_repository.dart';
// import 'package:repairo_provider/data/repository/step_three_repository.dart';
// import 'package:repairo_provider/data/repository/step_two_repository.dart';
// import 'package:repairo_provider/data/repository/subcategory_repository.dart';
// import 'package:repairo_provider/data/repository/verification_repository.dart';
// import 'package:repairo_provider/data/web_services/categories_webservices.dart';
// import 'package:repairo_provider/data/web_services/login_webservice.dart';
// import 'package:repairo_provider/data/web_services/profile_webservices.dart';
// import 'package:repairo_provider/data/web_services/services_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_one_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_three_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_two_webservices.dart';
// import 'package:repairo_provider/data/web_services/subcategories_webservice.dart';
// import 'package:repairo_provider/data/web_services/verification_webservices.dart';
// import 'package:repairo_provider/presentation/screens/MultiStepsScreen.dart';
// import 'package:repairo_provider/presentation/screens/chat_screen.dart';
// import 'package:repairo_provider/presentation/screens/login_screen.dart';
// import 'package:repairo_provider/presentation/screens/main_screen.dart';
// import 'package:repairo_provider/presentation/screens/notification_screen.dart';
// import 'package:repairo_provider/presentation/screens/step_two_screen.dart';
// import 'package:repairo_provider/presentation/screens/verification.dart';
// import 'package:repairo_provider/pusher_chat_service.dart';
// import 'package:repairo_provider/pusher_event.dart';

// class AppRouter {
//   AppRouter();

//   Route? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case 'login':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider.value(
//                 value: LoginCubit(AuthRepository(AuthWebService())),
//                 child: LoginScreen(),
//               ),
//         );

//       case 'verification':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (context) => VerificationCubit(
//                       VerificationRepository(VerificationWebservices()),
//                     ),
//                 child: Verification(),
//               ),
//         );

//       case 'mainscreen':
//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [
//                   // BlocProvider<AllcategoriesCubit>(
//                   //   create: (context) => allcategoriesCubit,
//                   // ),
//                   BlocProvider<ProfileCubit>(
//                     create:
//                         (context) => ProfileCubit(
//                           ProfileRepository(ProfileWebservices()),
//                         ),
//                   ),
//                 ],
//                 child: MainScreen(),
//               ),
//         );
//       case 'editServices':
//       // 1. اقرأ الـ arguments هنا
//         final args = settings.arguments as Map<String, dynamic>?;
//         final bool showButton = args?['showSaveButton'] ?? false;
//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [

//                   // هذه هي الـ Cubits التي تحتاجها شاشة StepTwoWidget لتعمل
//                   BlocProvider<StepTwoCubit>(
//                     create:
//                         (context) => StepTwoCubit(
//                           StepTwoRepository(StepTwoWebservices()),
//                         ),
//                   ),
//                   BlocProvider<AllcategoriesCubit>(
//                     create:
//                         (context) => AllcategoriesCubit(
//                           CategoriesRepository(
//                             categoriesWebservices: CategoriesWebservices(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<SubcategoryCubit>(
//                     create:
//                         (context) => SubcategoryCubit(
//                           SubcategoryRepository(
//                             subcategoriesWebservice: SubcategoriesWebservice(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<ServiceCubit>(
//                     create:
//                         (context) => ServiceCubit(
//                           ServiceRepository(
//                             serviceWebservices: ServiceWebservices(),
//                           ),
//                         ),
//                   ),
//                 ],
//                 // استدعِ StepTwoWidget مباشرة هنا
//                 child: const StepTwoWidget(),
//               ),
//         );
//       case 'notifications':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (context) =>
//                         NotificationCubit(NotificationRepository())
//                           ..loadNotifications(),
//                 child: NotificationPage(),
//               ),
//         );

//       case 'MultiStepProfileScreen':
//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [
//                   BlocProvider<StepOneCubit>(
//                     create:
//                         (context) => StepOneCubit(
//                           StepOneRepository(StepOneWebservices()),
//                         ),
//                   ),
//                   BlocProvider<StepTwoCubit>(
//                     create:
//                         (context) => StepTwoCubit(
//                           StepTwoRepository(StepTwoWebservices()),
//                         ),
//                   ),
//                   BlocProvider<StepThreeCubit>(
//                     create:
//                         (context) => StepThreeCubit(
//                           StepThreeRepository(StepThreeWebservices()),
//                         ),
//                   ),
//                   BlocProvider<AllcategoriesCubit>(
//                     create:
//                         (context) => AllcategoriesCubit(
//                           CategoriesRepository(
//                             categoriesWebservices: CategoriesWebservices(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<SubcategoryCubit>(
//                     create:
//                         (context) => SubcategoryCubit(
//                           SubcategoryRepository(
//                             subcategoriesWebservice: SubcategoriesWebservice(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<ServiceCubit>(
//                     create:
//                         (context) => ServiceCubit(
//                           ServiceRepository(
//                             serviceWebservices: ServiceWebservices(),
//                           ),
//                         ),
//                   ),
//                 ],
//                 child: MultiStepsScreen(),
//               ),
//         );
//       case 'chat':
//         final args = settings.arguments as Map<String, dynamic>;
//         final orderId = args['orderId'] as String;

//         final repository = ChatRepository(
//           baseUrl: 'https://your-api.com',
//         ); // عدّل الـ URL حسب الحاجة
//         final pusherService = PusherChatService();

//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (_) =>
//                         ChatCubit(repository: repository, orderId: orderId)
//                           ..loadMessages()
//                           ..initPusher(
//                             pusherService,
//                             orderId,
//                           ), // سنضيف هذا في الخطوة القادمة
//                 child: ChatPage(orderId: orderId),
//               ),
//         );
//     }
//     return null;
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
// import 'package:repairo_provider/business_logic/ChatMessagesCubit/chat_cubit.dart';
// import 'package:repairo_provider/business_logic/LoginCubit/login_cubit.dart';
// import 'package:repairo_provider/business_logic/NotificationCubit/notification_cubit.dart';
// import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
// import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
// import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
// import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
// import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
// import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
// import 'package:repairo_provider/business_logic/VerifyCubit/verification_cubit.dart';
// import 'package:repairo_provider/data/repository/categories_repository.dart';
// import 'package:repairo_provider/data/repository/chat_repsitory.dart';
// import 'package:repairo_provider/data/repository/login_repository.dart';
// import 'package:repairo_provider/data/repository/notificcation_repository.dart';
// import 'package:repairo_provider/data/repository/profile_repository.dart';
// import 'package:repairo_provider/data/repository/services_repository.dart';
// import 'package:repairo_provider/data/repository/step_one_repository.dart';
// import 'package:repairo_provider/data/repository/step_three_repository.dart';
// import 'package:repairo_provider/data/repository/step_two_repository.dart';
// import 'package:repairo_provider/data/repository/subcategory_repository.dart';
// import 'package:repairo_provider/data/repository/verification_repository.dart';
// import 'package:repairo_provider/data/web_services/categories_webservices.dart';
// import 'package:repairo_provider/data/web_services/login_webservice.dart';
// import 'package:repairo_provider/data/web_services/profile_webservices.dart';
// import 'package:repairo_provider/data/web_services/services_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_one_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_three_webservices.dart';
// import 'package:repairo_provider/data/web_services/step_two_webservices.dart';
// import 'package:repairo_provider/data/web_services/subcategories_webservice.dart';
// import 'package:repairo_provider/data/web_services/verification_webservices.dart';
// import 'package:repairo_provider/presentation/screens/MultiStepsScreen.dart';
// import 'package:repairo_provider/presentation/screens/chat_screen.dart';
// import 'package:repairo_provider/presentation/screens/login_screen.dart';
// import 'package:repairo_provider/presentation/screens/main_screen.dart';
// import 'package:repairo_provider/presentation/screens/notification_screen.dart';
// import 'package:repairo_provider/presentation/screens/step_two_screen.dart';
// import 'package:repairo_provider/presentation/screens/verification.dart';
// import 'package:repairo_provider/pusher_chat_service.dart';

// class AppRouter {
//   AppRouter();

//   Route? generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case 'login':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider.value(
//                 value: LoginCubit(AuthRepository(AuthWebService())),
//                 child: LoginScreen(),
//               ),
//         );

//       case 'verification':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (context) => VerificationCubit(
//                       VerificationRepository(VerificationWebservices()),
//                     ),
//                 child: Verification(),
//               ),
//         );

//       case 'mainscreen':
//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [
//                   BlocProvider<ProfileCubit>(
//                     create:
//                         (context) => ProfileCubit(
//                           ProfileRepository(ProfileWebservices()),
//                         ),
//                   ),
//                 ],
//                 child: MainScreen(),
//               ),
//         );

//       // --- هذا هو الجزء المعدل ---
//       case 'editServices':
//         final args = settings.arguments as Map<String, dynamic>?;
//         final bool showButton = args?['showSaveButton'] ?? false;

//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [
//                   BlocProvider<StepTwoCubit>(
//                     create:
//                         (context) => StepTwoCubit(
//                           StepTwoRepository(StepTwoWebservices()),
//                         ),
//                   ),
//                   BlocProvider<AllcategoriesCubit>(
//                     create:
//                         (context) => AllcategoriesCubit(
//                           CategoriesRepository(
//                             categoriesWebservices: CategoriesWebservices(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<SubcategoryCubit>(
//                     create:
//                         (context) => SubcategoryCubit(
//                           SubcategoryRepository(
//                             subcategoriesWebservice: SubcategoriesWebservice(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<ServiceCubit>(
//                     create:
//                         (context) => ServiceCubit(
//                           ServiceRepository(
//                             serviceWebservices: ServiceWebservices(),
//                           ),
//                         ),
//                   ),
//                 ],
//                 child: StepTwoWidget(showSaveButton: showButton),
//               ),
//         );

//       case 'notifications':
//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (context) =>
//                         NotificationCubit(NotificationRepository())
//                           ..loadNotifications(),
//                 child: NotificationPage(),
//               ),
//         );

//       case 'MultiStepProfileScreen':
//         return MaterialPageRoute(
//           builder:
//               (_) => MultiBlocProvider(
//                 providers: [
//                   BlocProvider<StepOneCubit>(
//                     create:
//                         (context) => StepOneCubit(
//                           StepOneRepository(StepOneWebservices()),
//                         ),
//                   ),
//                   BlocProvider<StepTwoCubit>(
//                     create:
//                         (context) => StepTwoCubit(
//                           StepTwoRepository(StepTwoWebservices()),
//                         ),
//                   ),
//                   BlocProvider<StepThreeCubit>(
//                     create:
//                         (context) => StepThreeCubit(
//                           StepThreeRepository(StepThreeWebservices()),
//                         ),
//                   ),
//                   BlocProvider<AllcategoriesCubit>(
//                     create:
//                         (context) => AllcategoriesCubit(
//                           CategoriesRepository(
//                             categoriesWebservices: CategoriesWebservices(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<SubcategoryCubit>(
//                     create:
//                         (context) => SubcategoryCubit(
//                           SubcategoryRepository(
//                             subcategoriesWebservice: SubcategoriesWebservice(),
//                           ),
//                         ),
//                   ),
//                   BlocProvider<ServiceCubit>(
//                     create:
//                         (context) => ServiceCubit(
//                           ServiceRepository(
//                             serviceWebservices: ServiceWebservices(),
//                           ),
//                         ),
//                   ),
//                 ],
//                 child: MultiStepsScreen(),
//               ),
//         );

//       case 'chat':
//         final args = settings.arguments as Map<String, dynamic>;
//         final orderId = args['orderId'] as String;

//         final repository = ChatRepository(baseUrl: 'https://your-api.com');
//         final pusherService = PusherChatService();

//         return MaterialPageRoute(
//           builder:
//               (_) => BlocProvider(
//                 create:
//                     (_) =>
//                         ChatCubit(repository: repository, orderId: orderId)
//                           ..loadMessages()
//                           ..initPusher(pusherService, orderId),
//                 child: ChatPage(orderId: orderId),
//               ),
//         );
//     }
//     return null;
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// --- Imports for existing features ---
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:repairo_provider/business_logic/LoginCubit/login_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:repairo_provider/business_logic/Subscription/status_check_bloc.dart';
import 'package:repairo_provider/business_logic/Subscription/status_check_event.dart';
import 'package:repairo_provider/data/repository/categories_repository.dart';
import 'package:repairo_provider/data/repository/login_repository.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:repairo_provider/data/repository/services_repository.dart';
import 'package:repairo_provider/data/repository/step_one_repository.dart';
import 'package:repairo_provider/data/repository/step_three_repository.dart';
import 'package:repairo_provider/data/repository/step_two_repository.dart';
import 'package:repairo_provider/data/repository/subcategory_repository.dart';
import 'package:repairo_provider/data/web_services/categories_webservices.dart';
import 'package:repairo_provider/data/web_services/login_webservice.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';
import 'package:repairo_provider/data/web_services/services_webservices.dart';
import 'package:repairo_provider/data/web_services/step_one_webservices.dart';
import 'package:repairo_provider/data/web_services/step_three_webservices.dart';
import 'package:repairo_provider/data/web_services/step_two_webservices.dart';
import 'package:repairo_provider/data/web_services/subcategories_webservice.dart';
import 'package:repairo_provider/presentation/screens/MultiStepsScreen.dart';
import 'package:repairo_provider/presentation/screens/login_screen.dart';
import 'package:repairo_provider/presentation/screens/main_screen.dart';

class AppRouter {
  // --- Repositories for dependency injection ---
  //  late SubscriptionRepository subscriptionRepository;
  // أضف الـ repositories الأخرى هنا بنفس الطريقة إذا أردت

  AppRouter() {
    // Initialize repositories
    //  subscriptionRepository = SubscriptionRepository();
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case 'login':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: LoginCubit(AuthRepository(AuthWebService())),
                child: LoginScreen(),
              ),
        );

      // case 'verification':
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => BlocProvider(
      //           create:
      //               (context) => VerificationCubit(
      //                 VerificationRepository(VerificationWebservices()),
      //               ),
      //           child: Verification(),
      //         ),
      //   );

      case 'mainscreen':
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  // BlocProvider<AllcategoriesCubit>(
                  //   create: (context) => allcategoriesCubit,
                  // ),
                  BlocProvider<ProfileCubit>(
                    create:
                        (context) => ProfileCubit(
                          ProfileRepository(ProfileWebservices()),
                        ),
                  ),
                  // --- ✅ إضافة بلوك التحقق من الاشتراك ---
                  BlocProvider<SubscriptionStatusBloc>(
                    // عند إنشاء البلوك، نبدأ عملية التحقق فورًا
                    create:
                        (context) =>
                            SubscriptionStatusBloc()
                              ..add(CheckSubscriptionStatus()),
                  ),
                ],
                child: MainScreen(),
              ),
        );
      // case 'notifications':
      //   return MaterialPageRoute(
      //     builder:
      //         (_) => BlocProvider(
      //           create:
      //               (context) =>
      //                   NotificationCubit(NotificationRepository())
      //                     ..loadNotifications(),
      //           child: NotificationPage(),
      //         ),
      //   );

      case 'MultiStepProfileScreen':
        return MaterialPageRoute(
          builder:
              (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<StepOneCubit>(
                    create:
                        (context) => StepOneCubit(
                          StepOneRepository(StepOneWebservices()),
                        ),
                  ),
                  BlocProvider<StepTwoCubit>(
                    create:
                        (context) => StepTwoCubit(
                          StepTwoRepository(StepTwoWebservices()),
                        ),
                  ),
                  BlocProvider<StepThreeCubit>(
                    create:
                        (context) => StepThreeCubit(
                          StepThreeRepository(StepThreeWebservices()),
                        ),
                  ),
                  BlocProvider<AllcategoriesCubit>(
                    create:
                        (context) => AllcategoriesCubit(
                          CategoriesRepository(
                            categoriesWebservices: CategoriesWebservices(),
                          ),
                        ),
                  ),
                  BlocProvider<SubcategoryCubit>(
                    create:
                        (context) => SubcategoryCubit(
                          SubcategoryRepository(
                            subcategoriesWebservice: SubcategoriesWebservice(),
                          ),
                        ),
                  ),
                  BlocProvider<ServiceCubit>(
                    create:
                        (context) => ServiceCubit(
                          ServiceRepository(
                            serviceWebservices: ServiceWebservices(),
                          ),
                        ),
                  ),
                ],
                child: MultiStepsScreen(),
              ),
        );
    }
    return null;
  }
}
