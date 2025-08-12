import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/arka_sayfa_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/arka_sayfa_cubit2.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/id_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/location_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/theme_cubits.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/times_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/views/main_page.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final prefs = await SharedPreferences.getInstance();
  final colorValue = prefs.getInt('theme_color') ?? Colors.red.value;
  final initialColor = Color(colorValue);
  runApp(MyApp(initialColor: initialColor));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialColor});
  final Color initialColor;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      minTextAdapt: true,
      splitScreenMode: true,
      designSize: Size(393, 852), //Iphone 16
      builder: (context, child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) {
                return LocationCubit();
              },
            ),
            BlocProvider(
              create: (context) {
                return ArkaSayfaCubit2();
              },
            ),
            BlocProvider(
              create: (context) {
                return IdCubit();
              },
            ),

            BlocProvider(
              create: (context) {
                return TimesCubit();
              },
            ),
            BlocProvider(
              create: (context) {
                return ThemeCubits(initialColor);
              },
            ),
            BlocProvider(
              create: (context) {
                return ArkaSayfaCubit();
              },
            ),
          ],
          child: BlocBuilder<ThemeCubits, ThemeData>(
            builder: (context, state) {
              return MaterialApp(
                theme: state,
                debugShowCheckedModeBanner: false,
                builder: (context, child) {
                  final mediaQueryData = MediaQuery.of(context);
                  return MediaQuery(
                    data: mediaQueryData.copyWith(
                      textScaler: TextScaler.linear(1.0), // Sistem font büyüklüğünü sabitle
                    ),
                    child: child!,
                  );
                },
                home: FlutterSplashScreen.scale(
                  childWidget: SizedBox(
                    height: 100.h,
                    child: Image.asset('images/splash.png'),
                  ),
                  nextScreen: MainPage(),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [
                      Colors.lightBlueAccent,
                      Colors.deepOrange,
                      Colors.pinkAccent,
                    ],
                  ),
                  duration: Duration(seconds: 1),
                  animationDuration: Duration(seconds: 1),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
