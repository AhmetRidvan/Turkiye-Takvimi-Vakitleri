import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: FlutterQiblah.androidDeviceSensorSupport(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError || snapshot.data == false) {
            return const Center(
              child: Text("Cihazınız yön sensörünü desteklemiyor."),
            );
          }

          return const QiblaCompass();
        },
      ),
    );
  }
}

class QiblaCompass extends StatelessWidget {
  const QiblaCompass({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        final qiblaDirection = snapshot.data!;
        final double qibla = qiblaDirection.qiblah;
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.error,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Transform.rotate(
                        angle: -qibla * (pi / 180),
                        child: Image.asset(
                          'images/qibla.png',
                          width: 70.w,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
