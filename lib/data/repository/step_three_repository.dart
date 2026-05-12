import 'dart:io';
import 'package:repairo_provider/data/web_services/step_three_webservices.dart';

class StepThreeRepository {
  final StepThreeWebservices stepThreeWebservices;

  StepThreeRepository(this.stepThreeWebservices);

  Future<void> stepthree(File image) async {
    final data = await stepThreeWebservices.stepthree(image);
    print(data);
  }
}
