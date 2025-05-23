import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/business_logic/CategoryCubit/category_cubit.dart';
import 'package:repairo_provider/business_logic/ItemsCubit/items_cubit.dart';
import 'package:repairo_provider/business_logic/LoginCubit/login_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/edit_profile_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_update_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/sub_category_cubit.dart';
import 'package:repairo_provider/business_logic/VerifyCubit/verification_cubit.dart';
import 'package:repairo_provider/constants/strings.dart';
import 'package:repairo_provider/data/repository/category_repository.dart';
import 'package:repairo_provider/data/repository/items_repository.dart';
import 'package:repairo_provider/data/repository/login_repository.dart';
import 'package:repairo_provider/data/repository/profile_repository1.dart';
import 'package:repairo_provider/data/repository/profile_repository2.dart';
import 'package:repairo_provider/data/repository/sub_category_repository.dart';
import 'package:repairo_provider/data/repository/verification_repository.dart';
import 'package:repairo_provider/data/web_services/Items_webservices.dart';
import 'package:repairo_provider/data/web_services/category_remote_data_source.dart';
import 'package:repairo_provider/data/web_services/login_webservice.dart';
import 'package:repairo_provider/data/web_services/profile_remote_data_source.dart';
import 'package:repairo_provider/data/web_services/profile_remote_data_source2.dart';
import 'package:repairo_provider/data/web_services/sub_category_remote_data_source.dart';
import 'package:repairo_provider/data/web_services/verification_webservices.dart';
import 'package:repairo_provider/presentation/screens/MultiStepProfileScreen.dart';
import 'package:repairo_provider/presentation/screens/category_screen.dart';
import 'package:repairo_provider/presentation/screens/edit_profile_screen.dart';
import 'package:repairo_provider/presentation/screens/items_details_screen.dart';
import 'package:repairo_provider/presentation/screens/login_screen.dart';
import 'package:repairo_provider/presentation/screens/sub_category_screen.dart';
import 'package:repairo_provider/presentation/screens/verification.dart';

class AppRouter {
  late ItemsRepository itemsRepository;
  late ItemsCubit itemsCubit;

  AppRouter() {
    itemsRepository = ItemsRepository(itemsWebservices: ItemsWebservices());
    itemsCubit = ItemsCubit(itemsRepository);
  }

  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case charecters_details_screen:
        return MaterialPageRoute(builder: (_) => const ItemsDetailsScreen());
      case '/':
      case 'login':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider.value(
                value: LoginCubit(AuthRepository(AuthWebService())),
                child: LoginScreen(),
              ),
        );
      case 'verification':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => VerificationCubit(
                      VerificationRepository(VerificationWebservices()),
                    ),
                child: Verification(),
              ),
        );

      case 'MultiStepProfileScreen':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => ProfileUpdateCubit(
                      ProfileRepository(
                        ProfileRemoteDataSource(
                          http.Client(),
                          "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwOi8vMTkyLjE2OC4xLjEwMTo4MDAwL2FwaS90ZWNobmljaWFuL2F1dGhlbnRpY2F0aW9uL2NoZWNrLWNvZGUiLCJpYXQiOjE3NDc0MDI4NDEsImV4cCI6MTc0NzQwNjQ0MSwibmJmIjoxNzQ3NDAyODQxLCJqdGkiOiJCeHpocVhIT1V2eFdNbWZDIiwic3ViIjoiOWVlY2U0N2YtOTkwZS00YWY3LTk1NjMtOWVhZjBlMGZmMTM4IiwicHJ2IjoiZTAzMGEyZDE0NmMzMzcwY2Q4MDBhZDFjNWJhOWFiYTNiNmE1MTFlNyJ9.ET1Ct6aVep2T2zv4PSMaTflsa2FIA5T2VUQIqauHGPY",
                        ),
                      ),
                    ),
                child: MultiStepProfileScreen(),
              ),
        );

      case 'categories':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => CategoryCubit(
                      CategoryRepository(
                        CategoryRemoteDataSource(http.Client()),
                      ),
                    )..getCategories(),
                child: const CategoryScreen(),
              ),
        );

      case 'sub_category':
        return MaterialPageRoute(
          builder:
              (_) => BlocProvider(
                create:
                    (context) => SubCategoryCubit(
                      SubCategoryRepository(
                        SubCategoryRemoteDataSource(http.Client()),
                      ),
                    )..loadSubCategories(),
                child: const SubCategoryScreen(),
              ),
        );
    }
    return null;
  }
}
