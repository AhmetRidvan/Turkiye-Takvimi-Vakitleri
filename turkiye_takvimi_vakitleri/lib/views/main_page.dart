import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:home_widget/home_widget.dart';
import 'package:html/parser.dart';
import 'package:one_clock/one_clock.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/arka_sayfa_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/id_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/location_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/theme_cubits.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/times_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/id_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/time_model.dart';
import 'package:turkiye_takvimi_vakitleri/views/aciklama.dart';
import 'package:turkiye_takvimi_vakitleri/views/arka_sayfa_page.dart';
import 'package:turkiye_takvimi_vakitleri/views/qibla.dart';
import 'package:widget_zoom/widget_zoom.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _darkMode = false;
  Color color65 = Colors.transparent;
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  double? latitude;
  double? longtitude;
  int? id;
  Times? times;
  DateTime todayDateTime = DateTime.now();
  ArkaSayfaModel? ark;

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
                        backgroundColor: Theme.of(context).colorScheme.error,
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await context.read<LocationCubit>().getLocation();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _updateKalanVakit();
      });
    });

    checkLocation = Timer.periodic(Duration(seconds: 120), (timer) async {
      await _getLocationAndId();
    });
    context.read<ArkaSayfaCubit>().getArkaSayfa(DateTime.now());
  }

  Future<void> homeWidgetUpdate() async {
    String x = parse(ark!.veri!.gununOlayi).body!.text;
    print(x);
    String y = parse(ark!.veri!.gununSozu).body!.text;
    print(y);

    await HomeWidget.saveWidgetData('_imsak', imsak);
    await HomeWidget.saveWidgetData('_sabah', sabah);
    await HomeWidget.saveWidgetData('_gunes', gunes);
    await HomeWidget.saveWidgetData('_ogle', ogle);
    await HomeWidget.saveWidgetData('_ikindi', ikindi);
    await HomeWidget.saveWidgetData('_aksam', aksam);
    await HomeWidget.saveWidgetData('_yatsi', yatsi);
    await HomeWidget.saveWidgetData('_gununOlayi', x);
    await HomeWidget.saveWidgetData('_gununSozu', y);

    await HomeWidget.updateWidget(
      name: 'HomeScreenWidgetProvider',
      androidName: 'HomeScreenWidgetProvider',
      iOSName: 'HomeScreenWidgetProvider',
    );
  }

  Future<void> homeWidgetUpdateIOS() async {
    // HTML'den metin ayıklama
    final String gununOlayi = parse(ark!.veri!.gununOlayi).body!.text;
    final String gununSozu = parse(ark!.veri!.gununSozu).body!.text;

    // App Group ID ve Widget adı tanımlanıyor
    const String appGroupId = 'group.turkiyeTakvimiWidget';
    const String iosWidgetName = 'turkiye';

    // App Group üzerinden veri iletimi için hazırlık
    await HomeWidget.setAppGroupId(appGroupId);

    // Vakit bilgileri widget’a kaydediliyor
    await HomeWidget.saveWidgetData('_imsak', imsak);
    await HomeWidget.saveWidgetData('_sabah', sabah);
    await HomeWidget.saveWidgetData('_gunes', gunes);
    await HomeWidget.saveWidgetData('_ogle', ogle);
    await HomeWidget.saveWidgetData('_ikindi', ikindi);
    await HomeWidget.saveWidgetData('_aksam', aksam);
    await HomeWidget.saveWidgetData('_yatsi', yatsi);

    // Widget’ın kendini güncellemesi tetikleniyor
    await HomeWidget.updateWidget(iOSName: iosWidgetName);
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

  DateTime? geceninUcBirVakti() {
    if (aksam == null || imsak == null) return null;
    // Akşam ve imsak saatlerini bugünün ve yarının tarihleriyle oluştur
    final now = DateTime.now();
    final aksamDt = DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(aksam!.split(':')[0]),
      int.parse(aksam!.split(':')[1]),
    );
    final imsakDt = DateTime(
      now.year,
      now.month,
      now.day + 1,
      int.parse(imsak!.split(':')[0]),
      int.parse(imsak!.split(':')[1]),
    );
    final fark = imsakDt.difference(aksamDt);
    final ucBir = Duration(seconds: (fark.inSeconds / 3).round());
    return aksamDt.add(ucBir);
  }

  String? geceninUcBirString() {
    final dt = geceninUcBirVakti();
    if (dt == null) return 'Bilinmiyor';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }

  Widget drawerButtons(IconData icon, String text, Function func) {
    return ElevatedButton(
      onPressed: () {
        func();
      },
      child: Row(
        mainAxisSize: MainAxisSize.max,

        children: [
          Expanded(
            flex: 1,
            child: Icon(icon, color: Theme.of(context).colorScheme.primary),
          ),
          Expanded(
            flex: 5,
            child: Text(
              text,
              style: TextStyle(fontSize: 20.sp),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
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
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                drawerButtons(Icons.data_array_rounded, 'Günün sözü', () {
                  showDialog(
                    barrierColor: Theme.of(context).colorScheme.primary,
                    context: context,
                    builder: (context) {
                      final parsed = parse(ark!.veri!.gununSozu);
                      final parsed2 = parse(ark!.veri!.gununOlayi);
                      return WidgetZoom(
                        heroAnimationTag: 'se',
                        zoomWidget: Dialog(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: themeColor.onPrimary,
                                borderRadius: BorderRadius.circular(22),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      parsed.body!.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    Image.asset(
                                      width: 300.w,
                                      'images/divider2.png',
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.error,
                                    ),
                                    Text(
                                      parsed2.body!.text,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 20.sp,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      icon: Icon(
                                        size: 30.sp,
                                        Icons.keyboard_return_rounded,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
                drawerButtons(Icons.padding_outlined, 'Arka yaprak', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ArkaSayfaPage();
                      },
                    ),
                  );
                }),
                drawerButtons(
                  Icons.insert_chart_outlined_sharp,
                  'Diğer vakitler',
                  () {
                    showDialog(
                      barrierColor: Theme.of(context).colorScheme.primary,
                      context: context,
                      builder: (context) {
                        return WidgetZoom(
                          heroAnimationTag: 'asdq',
                          zoomWidget: Dialog(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: themeColor.onPrimary,
                                  borderRadius: BorderRadius.circular(22),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(20.w),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      digerVakitler(
                                        context,
                                        'Gece yarısı',
                                        geceYarisi ?? 'Bilinmiyor',
                                      ),

                                      digerVakitler(
                                        context,
                                        'Teheccüd',
                                        teheccud ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'Seher',
                                        seher ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'İsrak',
                                        israk ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'Dahve',
                                        dahve ?? 'Bilinmiyor',
                                      ),

                                      digerVakitler(
                                        context,
                                        'Kıble',
                                        kible ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'Kerâhet',
                                        kerahet ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'Asr-ı Sâni',
                                        asriSani ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'İsfirar',
                                        isfirar ?? 'Bilinmiyor',
                                      ),
                                      digerVakitler(
                                        context,
                                        'İştibâk',
                                        istibak ?? 'Bilinmiyor',
                                      ),

                                      digerVakitler(
                                        context,
                                        'İşa-i Sâni',
                                        isaisani ?? 'Bilinmiyor',
                                      ),

                                      digerVakitler(
                                        context,
                                        'Gecenin 3\'te biri',
                                        geceninUcBirString(),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          size: 30.sp,
                                          Icons.keyboard_return_rounded,
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                drawerButtons(
                  Icons.timer_sharp,
                  'Vakitlerle ilgili\naçıklama',
                  () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Aciklama();
                        },
                      ),
                    );
                  },
                ),

                drawerButtons(Icons.location_on_outlined, 'Kıble pusulası', () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return QiblaScreen();
                      },
                    ),
                  );
                }),
                drawerButtons(Icons.color_lens_outlined, 'Renk seç', () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return Dialog(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(20.0.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Show the color picker in sized box in a raised card.
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Card(
                                      elevation: 2,
                                      child: ColorPicker(
                                        pickersEnabled: {
                                          ColorPickerType.wheel: false,
                                          ColorPickerType.accent: false,
                                          ColorPickerType.both: false,
                                          ColorPickerType.bw: false,
                                          ColorPickerType.custom: false,
                                          ColorPickerType.customSecondary:
                                              false,
                                          ColorPickerType.primary: false,
                                        },
                                        color: color65,

                                        onColorChanged: (Color color2) {
                                          setState(() => color65 = color2);
                                          context
                                              .read<ThemeCubits>()
                                              .changeColor(color65);
                                        },

                                        width: 44.w,
                                        height: 44.h,
                                        borderRadius: 22.w,
                                        heading: Text(
                                          'Rengi seçiniz',
                                          style: TextStyle(fontSize: 25.sp),
                                        ),
                                        subheading: Text(
                                          'Opaklık seçiniz',
                                          style: TextStyle(fontSize: 25.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'Tamam',
                                    style: TextStyle(fontSize: 30.sp),
                                  ),
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6),
                                    child: Card(
                                      elevation: 2,
                                      child: ColorPicker(
                                        pickersEnabled: {
                                          ColorPickerType.wheel: true,
                                          ColorPickerType.accent: false,
                                          ColorPickerType.both: false,
                                          ColorPickerType.bw: false,
                                          ColorPickerType.custom: false,
                                          ColorPickerType.customSecondary:
                                              false,
                                          ColorPickerType.primary: false,
                                        },
                                        color: color65,

                                        onColorChanged: (Color color2) {
                                          setState(() => color65 = color2);
                                          context
                                              .read<ThemeCubits>()
                                              .changeColor(color65);
                                        },

                                        width: 44.w,
                                        height: 44.h,
                                        borderRadius: 22.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ).then((value) {});
                }),

                // Show the color picker in sized box in a raised card.
              ],
            ),
          ),
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
                  Platform.isAndroid ? homeWidgetUpdate() : null;
                  Platform.isIOS ? homeWidgetUpdateIOS() : null;
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
          BlocListener<ArkaSayfaCubit, ArkaSayfaModel?>(
            listener: (BuildContext context, ArkaSayfaModel? state) async {
              if (state != null) {
                setState(() {
                  ark = state;
                });
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
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('images/background.png'),
                          fit: BoxFit.fill,
                          colorFilter: ColorFilter.mode(
                            themeColor.primary,
                            BlendMode.color,
                          ),
                        ),
                      ),
                    ),
                    customDrawerButton(),
                    customLocationDrawerButton(),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 55.h),
                        Text(
                          hicri!,
                          style: TextStyle(
                            color: themeColor.primary,
                            fontSize: 18.sp,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            analogClock(stringToDateTime(gunes!), false),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(333),
                                    color: themeColor.primary,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.all(4.0.w),
                                    child: Text(
                                      _day,
                                      style: TextStyle(
                                        color: themeColor.onPrimary,
                                        fontSize: 35.sp,
                                      ),
                                    ),
                                  ),
                                ),
                                text(_month, 20),
                                text(_year, 20),
                                text(_day2, 20),
                              ],
                            ),

                            analogClock2(DateTime.now(), true),
                          ],
                        ),

                        Column(
                          children: [
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
                          ],
                        ),

                        Image.asset(
                          width: 300.w,
                          'images/divider2.png',
                          color: Theme.of(context).colorScheme.primary,
                        ),

                        Column(
                          children: [
                            Stack(
                              children: [
                                Container(
                                  width: 340.w,
                                  height: 75.h,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
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
                                            ).colorScheme.primary,
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
                                            ).colorScheme.primary,
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
                        SizedBox(height: 70.h),
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

  Widget digerVakitler(BuildContext context, String? text56, String? text57) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Text(
            text56!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        Icon(
          Icons.arrow_forward_sharp,
          size: 25.w,
          color: Theme.of(context).colorScheme.error,
        ),
        Expanded(
          child: Text(
            text57!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.sp,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget timeWidget(
    IconData d1,
    Color c1,
    String text1,
    String text2,
    Color color,
  ) {
    final base = Column(
      children: [
        Stack(
          children: [
            // Parlayan ve bulanık arkaplan
            Container(
              width: 250.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(300),
              ),
            ),

            // Statik icon ve metinler
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
    if (color == Theme.of(context).colorScheme.error) {
      return base
          .animate(onComplete: (controller) => controller.repeat(reverse: true))
          .fade(
            begin: 0.1,
            end: 1.0,
            duration: 1000.ms,
            curve: Curves.easeInOut,
          );
    } else {
      return base;
    }
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
            isLive: false,
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

  Widget analogClock2(DateTime d1, bool show) {
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
