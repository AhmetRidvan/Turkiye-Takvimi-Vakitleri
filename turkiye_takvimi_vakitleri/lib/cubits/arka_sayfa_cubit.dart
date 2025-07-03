import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:turkiye_takvimi_vakitleri/repo/repo.dart';

class ArkaSayfaCubit extends Cubit<ArkaSayfaModel?> {
  ArkaSayfaCubit() : super(null);

  Future<void> getArkaSayfa(DateTime t1) async {
    final x = await Repo.getArkaSayfa(t1);
    emit(x);
  }
}
