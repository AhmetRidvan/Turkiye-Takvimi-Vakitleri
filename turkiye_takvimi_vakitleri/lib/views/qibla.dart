import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QiblaScreen extends StatefulWidget {
  const QiblaScreen({super.key});

  @override
  State<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends State<QiblaScreen> {
  final _deviceSupport = FlutterQiblah.androidDeviceSensorSupport();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error.toString()}"));
          }

          if (snapshot.hasData) {
            return const QiblahCompassWidget();
          } else {
            return const Center(
              child: Text("Cihaz sensör desteği bulunamadı."),
            );
          }
        },
      ),
    );
  }
}

class QiblahCompassWidget extends StatelessWidget {
  const QiblahCompassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final compassSvg = SizedBox(
      child: Image.asset(
        width: 350.w,
        height: 350.h,
        'images/kible.png',
        color: Theme.of(context).colorScheme.primary,
      ),
    );
    return StreamBuilder(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, AsyncSnapshot<QiblahDirection> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error.toString()}"));
        }

        if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text("Kıble yönü verisi alınamadı."));
        }

        final qiblahDirection = snapshot.data!;

        final qiblaAngle = (qiblahDirection.qiblah % 360).round();
        final deviceAngle = qiblahDirection.direction.round();
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Kıble açısı 340',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.rotate(
                        angle:
                            (qiblahDirection.direction * (pi / 180) * -1) +
                            pi +
                            (-50 * pi / 180),

                        child: compassSvg,
                      ),
                    ],
                  ),
                  Text(
                    'Anlık açınız ${qiblaAngle.toString()}',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 9.h),

                  Text(
                    '180 Derece zemine paralel-yatay olarak tutunuz.',
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: Theme.of(context).colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
