import 'dart:io';

import 'package:repairo_provider/data/web_services/step_one_webservices.dart';

class StepOneRepository {
  final StepOneWebservices stepOneWebservices;

  StepOneRepository(this.stepOneWebservices);

  Future<void> stepone(String name, File image, String address) async {
    final data = await stepOneWebservices.stepone(name, image, address);
    print(data);
  }
}
