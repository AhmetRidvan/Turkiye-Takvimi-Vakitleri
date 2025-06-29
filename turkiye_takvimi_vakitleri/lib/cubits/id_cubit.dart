import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkiye_takvimi_vakitleri/models/id_model.dart';
import 'package:turkiye_takvimi_vakitleri/repo/Repo.dart';

class IdCubit extends Cubit<IdModel?> {
  IdCubit() : super(null);

  Future<void> getId({required double lat, required double long}) async {
    emit(await Repo.getId(lat: lat,long: long));
      
  }
}
