import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:turkiye_takvimi_vakitleri/repo/repo.dart';

class ArkaSayfaCubit2 extends Cubit<ArkaSayfaModel?> {
  ArkaSayfaCubit2() : super(null);

  Future<void> getArkaSayfa2(DateTime t1) async {
    final x = await Repo.getArkaSayfa2(t1);
    emit(x);
  }
}
