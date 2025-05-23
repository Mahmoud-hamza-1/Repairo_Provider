import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:repairo_provider/business_logic/SubCategoryCubit/sub_category_cubit.dart';
import 'package:repairo_provider/business_logic/SubCategoryCubit/sub_category_state.dart';
import 'package:repairo_provider/data/repository/sub_category_repository.dart';
import 'package:repairo_provider/data/web_services/sub_category_remote_data_source.dart';

class SubCategoryScreen extends StatelessWidget {
  const SubCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) => SubCategoryCubit(
            SubCategoryRepository(SubCategoryRemoteDataSource(http.Client())),
          )..loadSubCategories(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("المهن الفرعية"),
          backgroundColor: const Color.fromRGBO(95, 96, 185, 1),
        ),
        body: BlocBuilder<SubCategoryCubit, SubCategoryState>(
          builder: (context, state) {
            if (state is SubCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is SubCategoryLoaded) {
              return ListView.builder(
                itemCount: state.subCategories.length,
                itemBuilder: (context, index) {
                  final sub = state.subCategories[index];
                  return ListTile(title: Text(sub.displayName));
                },
              );
            } else if (state is SubCategoryError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
