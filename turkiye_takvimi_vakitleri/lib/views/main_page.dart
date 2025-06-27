import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:one_clock/one_clock.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/main_page_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final GlobalKey<SliderDrawerState> _sliderDrawerKey =
      GlobalKey<SliderDrawerState>();
  String _locationCityName = 'İstanbul';
  String _day = '30';
  String _day2 = 'Çarşamba';
  String _month = 'Ağustos';
  String _year = '2025';
  String _hicri = '15.ŞEVVAl hicri';

  @override
  void initState() {
    super.initState();
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
      child: Scaffold(
        body: Stack(
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
                  _hicri,
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
              ],
            ),
          ],
        ),
      ),
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
          context.read<MainPageCubit>().getLocation();
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
                    _locationCityName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: themeColor.onPrimary,
                      fontSize: 25.sp,
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
            hourHandColor: Colors.black,
            minuteHandColor: Colors.black,
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
