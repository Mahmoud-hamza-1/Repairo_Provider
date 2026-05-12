import 'dart:io';

import 'package:repairo_provider/data/models/prev_work_model.dart';
import 'package:repairo_provider/data/web_services/previous_works_webservice.dart';

class PreviousWorksRepository {
  final PreviousWorksWebservice previousWorksWebservice;

  PreviousWorksRepository(this.previousWorksWebservice);



Future<List<RPrevWorkData>> getAllPrevWorks() async {
  final List<Map<String, dynamic>> responseData =
      await previousWorksWebservice.getAllPrevWorks();

  return responseData
      .map((item) => RPrevWorkData.fromJson(item))
      .toList();
}
  Future<void> addPrevWork(
      {
      required String title,
      required String description,
      required List<File> images,
      }) async {
    final data = await previousWorksWebservice.addPrevWork(
      description: description,
      title: title,
      images: images
      );
    print(data);
  }
}
