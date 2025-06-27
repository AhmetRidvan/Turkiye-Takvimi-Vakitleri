import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turkiye_takvimi_vakitleri/repo/main_page_repo.dart';

class MainPageCubit extends Cubit<Position?> {
  MainPageCubit() : super(null);

  Future<void> getLocation() async {
    final x = await MainPageRepo.getLocation();
    emit(x);
  }
}
