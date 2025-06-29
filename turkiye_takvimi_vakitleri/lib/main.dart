import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/id_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/cubits/location_cubit.dart';
import 'package:turkiye_takvimi_vakitleri/views/main_page.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp()); //konum reddediliince nolsun LocationCubit
}
// with .w height .h font .sp

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
                return IdCubit();
              },
            ),
          ],
          child: MaterialApp(
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.deepOrangeAccent,
              ),
            ),
            debugShowCheckedModeBanner: false,
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
          ),
        );
      },
    );
  }
}
