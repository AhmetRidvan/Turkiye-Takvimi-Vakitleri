import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkiye_takvimi_vakitleri/models/time_model.dart';
import 'package:turkiye_takvimi_vakitleri/repo/repo.dart';

class TimesCubit extends Cubit<Times?>{
  TimesCubit():  super(null);

  Future<void> getTimes({required int id})async{
    emit(await Repo.getTimes(id: id));
  }
}