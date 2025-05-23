import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/CategoryCubit/category_cubit.dart';
import 'package:repairo_provider/business_logic/CategoryCubit/category_state.dart';
import 'package:repairo_provider/data/models/category_model.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('الأقسام')),
      body: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CategoryLoaded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                itemCount: state.categories.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // عدد العناصر في كل سطر
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 2, // للتحكم بشكل البطاقة
                ),
                itemBuilder: (context, index) {
                  final Category category = state.categories[index];
                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          category.displayName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          } else if (state is CategoryError) {
            return Center(child: Text(state.message));
          }
          return const Center(child: Text("لا توجد بيانات"));
        },
      ),
    );
  }
}
