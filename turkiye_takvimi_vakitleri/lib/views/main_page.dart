import 'dart:async';
import 'dart:math';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_clock/one_clock.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/arka_sayfa_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/id_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/location_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/times_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/id_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/time_model.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  double? latitude;
  double? longtitude;
  int? id;
  Times? times;
  DateTime todayDateTime = DateTime.now();

  String? _locationCityName;
  String _day = '';
  String _day2 = 'Çarşamba';
  String _month = '';
  String _year = '';
  String? aktifVakitAdi;

  List<String> turkishMonths = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık',
  ];

  List<String> turkishDays = [
    'Pazartesi',
    'Salı',
    'Çarşamba',
    'Perşembe',
    'Cuma',
    'Cumartesi',
    'Pazar',
  ];

  String? aksam;
  String? asriSani;
  String? hicri;
  String? dahve;
  String? geceYarisi;
  String? gunes;
  String? ikindi;
  String? imsak;
  String? isaisani;
  String? isfirar;
  String? israk;
  String? istibak;
  String? kerahet;
  String? kible;
  String? ogle;
  String? sabah;
  String? seher;
  String? teheccud;
  String? yatsi;
  Timer? checkLocation;

  Timer? _timer;
  String? kalanVakitLabel = '';
  Duration? kalanSure;

  @override
  void initState() {
    super.initState();

    _getLocationAndId();
  }

  void _updateKalanVakit() {
    List<String?> nullCheckList = [
      imsak,
      sabah,
      gunes,
      ogle,
      ikindi,
      aksam,
      yatsi,
    ]; //0..6
    if (nullCheckList.any((element) => element == null)) {
      return;
    }

    final now = DateTime.now();

    final vakitler1 = [
      {'ad': 'İmsaka', 'saat': imsak!},
      {'ad': 'Sabaha', 'saat': sabah!},
      {'ad': 'Güneşe', 'saat': gunes!},
      {'ad': 'Öğleye', 'saat': ogle!},
      {'ad': 'İkindiye', 'saat': ikindi!},
      {'ad': 'Akşama', 'saat': aksam!},
      {'ad': 'Yatsıya', 'saat': yatsi!},
    ];

    for (int i = 0; i < vakitler1.length; i++) {
      final dt = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(vakitler1[i]['saat']!.split(':')[0]),
        int.parse(vakitler1[i]['saat']!.split(':')[1]),
      );
      if (now.isBefore(dt)) {
        kalanVakitLabel = '${vakitler1[i]['ad']} kalan';
        kalanSure = dt.difference(now);
        aktifVakitAdi = vakitler1[i]['ad'];

        return;
      }
    }
    final yarinkiImsak = DateTime(
      now.year,
      now.month,
      now.day + 1,
      int.parse(imsak!.split(':')[0]),
      int.parse(imsak!.split(':')[1]),
    );
    kalanVakitLabel = 'İmsaka kalan';
    aktifVakitAdi = 'İmsaka kalan';

    kalanSure = yarinkiImsak.difference(now);
  }

  Future<void> showLocationPermissionDialog() async {
    await showDialog(
      barrierColor: Colors.transparent,
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          icon: Column(
            children: [
              TextButton(
                child: Text(
                  textAlign: TextAlign.center,
                  'İzinleri verdiyseniz tekrar denemek için dokununuz.',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 20.sp,
                  ),
                ),
                onPressed: () async {
                  final x = await Geolocator.checkPermission();
                  if (x == LocationPermission.whileInUse ||
                      x == LocationPermission.always) {
                    Navigator.pop(context);
                    _getLocationAndId();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Center(
                          child: Text(
                            'İzin yok.',
                            style: TextStyle(fontSize: 30.sp),
                          ),
                        ),
                        backgroundColor: Colors.redAccent,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          content: Text(
            textAlign: TextAlign.center,
            'Konum izinleri olmaz ise doğru vakitler gönderilemez.',
            style: TextStyle(fontSize: 20.sp),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                await openSettings();
              },
              child: Text(
                'Konum izni ver.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontSize: 20.sp,
                ),
              ),
            ),
          ],
          title: Text(
            'Konum izni reddedildi.',
            style: TextStyle(fontSize: 20.sp),
          ),
        );
      },
    );
  }

  String kalanSureFormat() {
    if (kalanSure == null) return '';
    final h = kalanSure!.inHours;
    final m = kalanSure!.inMinutes % 60;
    final s = kalanSure!.inSeconds % 60;

    String result = '';
    if (h > 0) result += '$h Saat ';
    if (m > 0) result += '$m Dakika ';
    if (s > 0) result += '$s Saniye';
    return result;
  }

  @override
  void dispose() {
    _timer!.cancel();
    checkLocation!.cancel();
    super.dispose();
  }

  Future<void> _getLocationAndId() async {
    await context.read<LocationCubit>().getLocation();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateKalanVakit();
      });
    });

    checkLocation = Timer.periodic(Duration(seconds: 30), (timer) async {
      await _getLocationAndId();
    });
    
  }

  Future<void> openSettings() async {
    await AppSettings.openAppSettings();
  }

  DateTime stringToDateTime(String stringTime) {
    final x = stringTime.split(':');
    final hour = int.parse(x[0]);
    final minute = int.parse(x[1]);
    return DateTime(2000, 1, 1, hour, minute);
  }

  @override
  Widget build(BuildContext context) {
    bool isEverythingReady() {
      return [
        _locationCityName,
        imsak,
        sabah,
        gunes,
        ogle,
        ikindi,
        aksam,
        yatsi,
        hicri,
      ].every((element) => element != null);
    }

    final themeColor = Theme.of(context).colorScheme;
    return SliderDrawer(
      isDraggable: true,
      key: _sliderDrawerKey,
      appBar: SizedBox.shrink(),
      slider: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary,
                themeColor.onPrimary,
              ],
            ),
          ),
          child: Center(child: Text("asd")),
        ),
      ),
      child: MultiBlocListener(
        listeners: [
          BlocListener<TimesCubit, Times?>(
            listener: (context, state) {
              if (state != null) {
                setState(() {
                  times = state;
                  final todayTime = times!.cityinfo!.vakit.firstWhere((
                    element,
                  ) {
                    return todayDateTime.day ==
                            element.attributes!.tarih!.day &&
                        todayDateTime.month ==
                            element.attributes!.tarih!.month &&
                        todayDateTime.year == element.attributes!.tarih!.year;
                  });

                  aksam = todayTime.aksam;
                  asriSani = todayTime.asrisani;
                  hicri = todayTime.attributes!.hicri;
                  dahve = todayTime.dahve;
                  geceYarisi = todayTime.geceyarisi;
                  gunes = todayTime.gunes;
                  ikindi = todayTime.ikindi;
                  imsak = todayTime.imsak;
                  isaisani = todayTime.isaisani;
                  isfirar = todayTime.isfirar;
                  israk = todayTime.israk;
                  istibak = todayTime.istibak;
                  kerahet = todayTime.kerahet;
                  kible = todayTime.kible;
                  ogle = todayTime.ogle;
                  sabah = todayTime.sabah;
                  seher = todayTime.seher;
                  teheccud = todayTime.teheccud;
                  yatsi = todayTime.yatsi;
                  _day = todayDateTime.day.toString();
                  _month = turkishMonths[todayDateTime.month - 1];
                  _year = todayDateTime.year.toString();
                  _day2 = turkishDays[todayDateTime.weekday - 1];
                });
              }
            },
          ),

          BlocListener<LocationCubit, Position?>(
            listener: (BuildContext context, Position? state) async {
              if (state != null) {
                setState(() {
                  latitude = state.latitude;
                  longtitude = state.longitude;
                  context.read<IdCubit>().getId(
                    lat: latitude!,
                    long: longtitude!,
                  );
                });
              } else {
                showLocationPermissionDialog();
              }
            },
          ),
          BlocListener<IdCubit, IdModel?>(
            listener: (BuildContext context, IdModel? state) async {
              if (state != null) {
                final c = state.sehir![0];
                setState(() {
                  _locationCityName = c.cityNameTR!;
                  id = int.parse(c.iD!);

                  context.read<TimesCubit>().getTimes(id: id!);
                });
              }
            },
          ),
        ],
        child: Scaffold(
          body: isEverythingReady()
              ? Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset('images/background.png', fit: BoxFit.fill),
                    customDrawerButton(),
                    customLocationDrawerButton(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 83.h),
                        customDivider(),
                        Text(
                          hicri!,
                          style: TextStyle(
                            color: themeColor.primary,
                            fontSize: 24.sp,
                            fontWeight: FontWeight.bold,
                            height: 0.8.h,
                          ),
                        ),
                        Transform.rotate(angle: pi, child: customDivider()),
                        SizedBox(height: 2.0.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            analogClock(stringToDateTime(gunes!), false),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: themeColor.primary,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: Text(
                                      _day,
                                      style: TextStyle(
                                        color: themeColor.onPrimary,
                                        fontSize: 30.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                text(_day2, 15),
                                text(_month, 15),
                                text(_year, 15),
                              ],
                            ),

                            analogClock(DateTime.now(), true),
                          ],
                        ),
                        SizedBox(height: 3.h),

                        timeWidget(
                          Icons.nightlight_round,
                          Colors.deepOrange,
                          'İmsak',
                          imsak!,
                          aktifVakitAdi == 'Sabaha'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.wb_twilight,
                          Colors.orange,
                          'Sabah',
                          sabah!,
                          aktifVakitAdi == 'Güneşe'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.wb_sunny,
                          Colors.orangeAccent,
                          'Güneş',
                          gunes!,
                          aktifVakitAdi == 'Öğleye'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.wb_sunny_outlined,
                          Colors.yellow,
                          'Öğle',
                          ogle!,
                          aktifVakitAdi == 'İkindiye'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.cloud_rounded,
                          Colors.grey[400]!,
                          'İkindi',
                          ikindi!,
                          aktifVakitAdi == 'Akşama'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.nightlight_sharp,
                          Colors.brown,
                          'Akşam',
                          aksam!,
                          aktifVakitAdi == 'Yatsıya'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        timeWidget(
                          Icons.nights_stay,
                          Colors.indigo.shade300,
                          'Yatsı',
                          yatsi!,
                          aktifVakitAdi == 'İmsaka kalan'
                              ? Theme.of(context).colorScheme.error
                              : Theme.of(context).colorScheme.primary,
                        ),
                        Image.asset(
                          width: 300.w,
                          'images/divider2.png',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 2.5.h),
                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 340.w,
                                  height: 75.h,
                                  decoration: BoxDecoration(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    borderRadius: BorderRadius.circular(300),
                                  ),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          kalanVakitLabel ?? '',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23.sp,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                        ),
                                        Text(
                                          kalanSureFormat(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 23.sp,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 25.h,
                      left: 125.w,

                      child: Center(
                        child: Image.asset('images/bottom.png', height: 50.h),
                      ),
                    ),
                  ],
                ).animate().blur(
                  begin: Offset(222, 222),
                  duration: Duration(milliseconds: 1000),
                )
              : Center(child: CircularProgressIndicator()),
        ),
      ),
    );
  }

  Widget timeWidget(
    IconData d1,
    Color c1,
    String text1,
    String text2,
    Color color,
  ) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 250.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(300),
              ),
            ),
            Positioned(
              bottom: 2.5.h,
              left: 5.w,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                width: 35.w,
                height: 35.h,
                child: Center(
                  child: Icon(d1, size: 30.w, color: c1),
                ),
              ),
            ),
            Positioned(
              width: 200.w,
              height: 40.h,
              left: 50.w,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      text1,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.sp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      text2,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 23.sp,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 3.h),
      ],
    );
  }

  Widget customDrawerButton() {
    final themeColor = Theme.of(context).colorScheme;
    return Positioned(
      left: 0.w,
      top: 50.h,
      child: GestureDetector(
        onTap: () {
          _sliderDrawerKey.currentState!.toggle();
        },
        child: Container(
          width: 50.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: themeColor.primary,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50),
              bottomRight: Radius.circular(50),
            ),
          ),
          child: Icon(Icons.menu, color: themeColor.onPrimary),
        ),
      ),
    );
  }

  Widget customLocationDrawerButton() {
    final themeColor = Theme.of(context).colorScheme;
    return Positioned(
      right: 0,
      top: 50.h,
      child: GestureDetector(
        onTap: () {
          _getLocationAndId();
        },
        child: Container(
          width: 160.w,
          height: 30.h,
          decoration: BoxDecoration(
            color: themeColor.primary,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              topLeft: Radius.circular(50),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Icon(
                Icons.location_on_outlined,
                color: themeColor.onPrimary,
                size: 30.w,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    _locationCityName!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeColor.onPrimary,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget analogClock(DateTime d1, bool show) {
    final themeColor = Theme.of(context).colorScheme.primary;
    return Stack(
      children: [
        Image.asset(
          'images/bell.png',
          color: themeColor,
          width: 100.w,
          fit: BoxFit.contain,
        ),
        Positioned(
          top: 34.w,
          left: 20.w,
          child: AnalogClock(
            height: 60.h,
            width: 60.w,
            isLive: true,
            hourHandColor: Theme.of(context).colorScheme.onSurface,
            minuteHandColor: Theme.of(context).colorScheme.onSurface,
            showSecondHand: show,
            numberColor: themeColor,
            showNumbers: true,
            showAllNumbers: true,
            textScaleFactor: 3.4.sp,
            showTicks: false,
            showDigitalClock: false,
            datetime: d1,
          ),
        ),
      ],
    );
  }

  Widget customDivider() {
    final themeColor = Theme.of(context).colorScheme.primary;
    return Image.asset('images/divider.png', width: 300.w, color: themeColor);
  }

  Widget text(String text, double font) {
    final themeColor = Theme.of(context).colorScheme.primary;
    return Text(
      text,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        color: themeColor,
        fontSize: font.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/*
// ..._MainPageState içinde...

Timer? _timer;
String kalanVakitLabel = '';
Duration? kalanSure;

@override
void initState() {
  super.initState();
  _getLocationAndId();
  _timer = Timer.periodic(Duration(seconds: 1), (_) => setState(() => _updateKalanVakit()));
  checkLocation = Timer.periodic(Duration(seconds: 30), (timer) async {
    await _getLocationAndId();
  });
}

@override
void dispose() {
  checkLocation?.cancel();
  _timer?.cancel();
  super.dispose();
}

void _updateKalanVakit() {
  if ([imsak, sabah, gunes, ogle, ikindi, aksam, yatsi].any((v) => v == null)) return;
  final now = DateTime.now();
  final vakitler = [
    {'ad': 'İmsak', 'saat': imsak!},
    {'ad': 'Sabah', 'saat': sabah!},
    {'ad': 'Güneş', 'saat': gunes!},
    {'ad': 'Öğle', 'saat': ogle!},
    {'ad': 'İkindi', 'saat': ikindi!},
    {'ad': 'Akşam', 'saat': aksam!},
    {'ad': 'Yatsı', 'saat': yatsi!},
  ];
  for (int i = 0; i < vakitler.length; i++) {
    final dt = DateTime(now.year, now.month, now.day,
        int.parse(vakitler[i]['saat']!.split(':')[0]),
        int.parse(vakitler[i]['saat']!.split(':')[1]));
    if (now.isBefore(dt)) {
      kalanVakitLabel = '${vakitler[i]['ad']}e kalan';
      kalanSure = dt.difference(now);
      return;
    }
  }
  // Gün bitti, yarının imsakına kadar göster
  final yarinImsak = DateTime(now.year, now.month, now.day + 1,
      int.parse(imsak!.split(':')[0]), int.parse(imsak!.split(':')[1]));
  kalanVakitLabel = 'İmsake kalan';
  kalanSure = yarinImsak.difference(now);
}

String kalanSureFormat() {
  if (kalanSure == null) return '';
  final h = kalanSure!.inHours;
  final m = kalanSure!.inMinutes % 60;
  final s = kalanSure!.inSeconds % 60;
  return '$h saat $m dakika $s saniye';
}
*/
