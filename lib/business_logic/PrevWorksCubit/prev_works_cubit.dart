import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/PrevWorksCubit/prev_works_states.dart';
import 'package:repairo_provider/data/models/prev_work_model.dart';
import 'package:repairo_provider/data/repository/previous_works_repository.dart';

class PrevWorksCubit extends Cubit<PrevWorksStates> {
  PrevWorksCubit(this.previousWorksRepository) : super(PrevWorksInitial());

  final PreviousWorksRepository previousWorksRepository;
  late List<RPrevWorkData> prevworks = [];

  Future<void> getAllprevWorks() async {
    emit(PrevWorksLoading());

    try {
      final theprevworks = await previousWorksRepository.getAllPrevWorks();
      prevworks = theprevworks;
      emit(PrevWorksLoaded(prevworks: theprevworks));
    } catch (e) {
      emit(PrevWorksFailed(e.toString()));
    }
  }
}
