import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turkiye_takvimi_vakitleri/repo/repo.dart';

class LocationCubit extends Cubit<Position?> {
  LocationCubit() : super(null);

  Future<void> getLocation() async {
    final x = await Repo.getLocation();
    emit(x);
  }
}
