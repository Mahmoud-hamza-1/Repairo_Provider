import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repairo_provider/business_logic/TechLocationsCubit/tech_locations_states.dart';
import 'package:repairo_provider/data/models/tech_location_model.dart';
import 'package:repairo_provider/data/repository/all_locations_repository.dart';

class TechLocationsCubit extends Cubit<TechLocationsStates> {
  TechLocationsCubit(this.allLocationsRepository)
    : super(TechLocationsInitial());

  final AllLocationsRepository allLocationsRepository;
  late List<RUserLocationData> locations = [];

  Future<void> getLocations(String id) async {
    emit(TechLocationsLoading());

    try {
      final thelocations = await allLocationsRepository.getLocations(id);
      locations = thelocations;
      emit(TechLocationsLoaded(locations: thelocations));
    } catch (e) {
      emit(TechLocationsFailed(e.toString()));
    }
  }
}
