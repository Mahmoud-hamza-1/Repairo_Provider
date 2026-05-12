import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/AccountStatusCubit/account_status_cubit.dart';
import 'package:repairo_provider/business_logic/AccountStatusCubit/account_status_states.dart';
import 'package:repairo_provider/business_logic/AllCategoriesCubit/allcaterories_cubit.dart';
import 'package:repairo_provider/business_logic/ProfileCubit/profile_cubit.dart';
import 'package:repairo_provider/business_logic/ServiceCubit/service_cubit.dart';
import 'package:repairo_provider/business_logic/StepOneCubit/step_one_cubit.dart';
import 'package:repairo_provider/business_logic/StepThreeCubit/step_three_cubit.dart';
import 'package:repairo_provider/business_logic/StepTwoCubit/step_two_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/subcategory_cubit.dart';
import 'package:repairo_provider/data/repository/account_status_repository.dart';
import 'package:repairo_provider/data/repository/categories_repository.dart';
import 'package:repairo_provider/data/repository/profile_repository.dart';
import 'package:repairo_provider/data/repository/services_repository.dart';
import 'package:repairo_provider/data/repository/step_one_repository.dart';
import 'package:repairo_provider/data/repository/step_three_repository.dart';
import 'package:repairo_provider/data/repository/step_two_repository.dart';
import 'package:repairo_provider/data/repository/subcategory_repository.dart';
import 'package:repairo_provider/data/web_services/account_status_webservice.dart';
import 'package:repairo_provider/data/web_services/categories_webservices.dart';
import 'package:repairo_provider/data/web_services/profile_webservices.dart';
import 'package:repairo_provider/data/web_services/services_webservices.dart';
import 'package:repairo_provider/data/web_services/step_one_webservices.dart';
import 'package:repairo_provider/data/web_services/step_three_webservices.dart';
import 'package:repairo_provider/data/web_services/step_two_webservices.dart';
import 'package:repairo_provider/data/web_services/subcategories_webservice.dart';
import 'package:repairo_provider/presentation/screens/MultiStepsScreen.dart';
import 'package:repairo_provider/presentation/screens/main_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Staging extends StatefulWidget {
  const Staging({super.key});

  @override
  _StagingScreenState createState() => _StagingScreenState();
}

class _StagingScreenState extends State<Staging> {
  //late final List<Widget> pages;
  //late final subscription;

  @override
  void initState() {
    super.initState();
    //pages = [MultiStepsScreen(), MainScreen(isSubscribed: subscription)];
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ProfileCubit>(
          create: (_) => ProfileCubit(ProfileRepository(ProfileWebservices())),
        ),
        BlocProvider<AccountStatusCubit>(
          create:
              (_) => AccountStatusCubit(
                AccountStatusRepository(AccountStatusWebservice()),
              )..getAccountStatus(),
        ),
        BlocProvider<StepOneCubit>(
          create: (_) => StepOneCubit(StepOneRepository(StepOneWebservices())),
        ),
        BlocProvider<StepTwoCubit>(
          create: (_) => StepTwoCubit(StepTwoRepository(StepTwoWebservices())),
        ),
        BlocProvider<StepThreeCubit>(
          create:
              (_) =>
                  StepThreeCubit(StepThreeRepository(StepThreeWebservices())),
        ),
        BlocProvider<AllcategoriesCubit>(
          create:
              (_) => AllcategoriesCubit(
                CategoriesRepository(
                  categoriesWebservices: CategoriesWebservices(),
                ),
              ),
        ),
        BlocProvider<SubcategoryCubit>(
          create:
              (_) => SubcategoryCubit(
                SubcategoryRepository(
                  subcategoriesWebservice: SubcategoriesWebservice(),
                ),
              ),
        ),
        BlocProvider<ServiceCubit>(
          create:
              (_) => ServiceCubit(
                ServiceRepository(serviceWebservices: ServiceWebservices()),
              ),
        ),
      ],
      child: BlocBuilder<AccountStatusCubit, AccountStatusStates>(
        builder: (context, state) {
          if (state is AccountStatusLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is AccountStatusSuccess) {
            final subscription =
                state.techstatus.subscriptionStatus == "active" ? true : false;

            SharedPreferences.getInstance().then((prefs) {
              prefs.setBool('isSubscribed', subscription);
            });

            final stepStr = state.techstatus.step?.toString();
            if (stepStr != '3') {
              return MultiStepsScreen(isSubscribed: subscription);
            } else {
              return MainScreen(isSubscribed: subscription);
            }
          }
          return const Scaffold(body: Center(child: Text('Error Happened')));
        },
      ),
    );
  }
}
