import 'package:board_datetime_picker/board_datetime_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/dom.dart' hide Text;
import 'package:html/parser.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/arka_sayfa_cubit2.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';

class ArkaSayfaPage extends StatefulWidget {
  ArkaSayfaPage({super.key});

  @override
  State<ArkaSayfaPage> createState() => _ArkaSayfaPageState();
}

class _ArkaSayfaPageState extends State<ArkaSayfaPage> {
  ArkaSayfaModel? a1;
  DateTime? d1 = DateTime.now();
  ArkaSayfaModel? ark;
  var ArkYazi;
  var ArkBaslik;

  @override
  void initState() {
    super.initState();
    getir();
  }

  Future<void> getir() async {
    await context.read<ArkaSayfaCubit2>().getArkaSayfa2(d1!);
  }

  void _openDatePicker(BuildContext context) async {
    await showBoardDateTimePicker(
      minimumDate: DateTime(2000),
      maximumDate: DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        DateTime.now().day + 1,
      ),
      initialDate: DateTime.now(),
      options: BoardDateTimeOptions(
        boardTitle: 'Tarih seçiniz',
        useResetButton: true,
        useAmpm: false,
        languages: BoardPickerLanguages(
          locale: 'tr',
          now: 'Şuan',
          today: 'Bugün',
          tomorrow: 'Yarın',
          yesterday: 'Dün',
        ),
      ),
      radius: 80.w,
      onChanged: (p0) {
        setState(() {
          d1 = p0;
        });
        getir();
      },

      context: context,
      pickerType: DateTimePickerType.date,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ArkaSayfaCubit2, ArkaSayfaModel?>(
          listener: (context, state) {
            if (state != null) {
              setState(() {
                ark = state;
                ArkYazi = ark!.veri!.arkayuz.yazi;
                ArkBaslik = ark!.veri!.arkayuz.baslik;
              });
            }
          },
        ),
      ],
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).colorScheme.primary,
          onPressed: () {
            _openDatePicker(context);
          },
          child: Icon(
            Icons.date_range_outlined,
            color: Theme.of(context).colorScheme.onPrimary,
          ),
        ),
        body: ark == null
            ? CircularProgressIndicator()
            : SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      child: SafeArea(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Html(
                              data: ArkBaslik,
                              style: {
                                // "body" seçicisi, HTML içeriğinin tamamına stil uygular.
                                "body": Style(
                                  // Yazı boyutunu buradan ayarlayabilirsiniz.
                                  // flutter_screenutil kullanıyorsanız .sp uzantısını kullanabilirsiniz.
                                  fontSize: FontSize(20.sp),

                                  // Diğer stil ayarları
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  textAlign: TextAlign.start,
                                ),

                                // İsterseniz sadece belirli etiketlere de (örn: paragraflara) stil verebilirsiniz.
                              },
                            ),
                            Divider(
                              thickness: 8.w,
                              color: Theme.of(context).colorScheme.primary,
                              radius: BorderRadius.circular(300.w),
                            ),
                            Html(
                              data: ArkYazi,
                              style: {
                                // "body" seçicisi, HTML içeriğinin tamamına stil uygular.
                                "body": Style(
                                  // Yazı boyutunu buradan ayarlayabilirsiniz.
                                  // flutter_screenutil kullanıyorsanız .sp uzantısını kullanabilirsiniz.
                                  fontSize: FontSize(20.sp),

                                  // Diğer stil ayarları
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.primary,
                                  textAlign: TextAlign.start,
                                ),

                                // İsterseniz sadece belirli etiketlere de (örn: paragraflara) stil verebilirsiniz.
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
