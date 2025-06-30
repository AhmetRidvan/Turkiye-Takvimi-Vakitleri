import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:one_clock/one_clock.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/id_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/location_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/times_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/models/id_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/time_model.dart';
import 'package:url_launcher/url_launcher.dart';

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
  String _day = '30';
  String _day2 = 'Çarşamba';
  String _month = 'Ağustos';
  String _year = '2025';

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

  @override
  void initState() {
    super.initState();
    _getLocationAndId();
  }

  Future<void> _getLocationAndId() async {
    await context.read<LocationCubit>().getLocation();
  }

  Future<void> openSettings() async {
    await launchUrl(Uri.parse('app-settings:')).then((value) {});
  }

  @override
  Widget build(BuildContext context) {
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
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      content: Text(
                        'Konum izinleri olmaz ise doğru vakitler gönderilemez.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            await openSettings();
                          },
                          child: Text(
                            'Uygulamayı kapatıp konum izinlerini verip yeniden açmalısınız.',
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
            },
          ),
          BlocListener<IdCubit, IdModel?>(
            listener: (BuildContext context, IdModel? state) async {
              if (state != null) {
                final c = state.sehir![0];
                setState(() {
                  _locationCityName = c.cityNameTR!;
                  id = int.parse(c.iD!);
                  print(id);
                  context.read<TimesCubit>().getTimes(id: id!);
                });
              }
            },
          ),
        ],
        child: Scaffold(
          body:
              Stack(
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
                      hicri == null
                          ? CircularProgressIndicator()
                          : Text(
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
                          analogClock(),
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

                          analogClock(),
                        ],
                      ),
                      SizedBox(height: 3.h),
                      timeWidget(Icons.nightlight_round, Colors.deepOrange),
                      timeWidget(Icons.wb_twilight, Colors.orange),
                      timeWidget(Icons.wb_sunny, Colors.orangeAccent),
                      timeWidget(Icons.wb_sunny_outlined, Colors.yellow),
                      timeWidget(Icons.cloud_rounded, Colors.grey[400]!),
                      timeWidget(Icons.nightlight_sharp, Colors.brown),
                      timeWidget(Icons.nights_stay, Colors.indigo.shade300),
                    ],
                  ),
                ],
              ).animate().blur(
                begin: Offset(222, 222),
                duration: Duration(milliseconds: 1000),
              ),
        ),
      ),
    );
  }

  Widget timeWidget(IconData d1, Color c1) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 280.w,
              height: 50.h,
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(300),
              ),
            ),
            Positioned(
              bottom: 5.h,
              left: 7.w,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                width: 40.w,
                height: 40.h,
                child: Center(
                  child: Icon(d1, size: 20.w, color: c1),
                ),
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
                  child: _locationCityName == null
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.onPrimary,
                        )
                      : Text(
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

  Widget analogClock() {
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
            showSecondHand: true,
            numberColor: themeColor,
            showNumbers: true,
            showAllNumbers: true,
            textScaleFactor: 3.4.sp,
            showTicks: false,
            showDigitalClock: false,
            datetime: DateTime.now(),
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
