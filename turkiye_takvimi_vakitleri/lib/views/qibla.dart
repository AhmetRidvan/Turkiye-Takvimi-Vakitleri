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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: FutureBuilder(
        future: _deviceSupport,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Sensör hatası: ${snapshot.error}"));
          }

          if (snapshot.hasData) {
            return const QiblaCompassWidget();
          } else {
            return const Center(child: Text("Cihazınız sensör desteklemiyor."));
          }
        },
      ),
    );
  }
}

class QiblaCompassWidget extends StatelessWidget {
  const QiblaCompassWidget({super.key});
  double correctionOffset(double angle) {
    if (angle < 90) return -105;
    if (angle < 180) return -100;
    if (angle < 270) return -96;
    return -102;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return const Center(child: Text("Yön verisi alınamadı."));
        }

        final qiblahDirection = snapshot.data!;
        final qiblaAngle = qiblahDirection.qiblah;
        final deviceAngle = qiblahDirection.direction;

        // Kıble açısı 300-320 arasında ise ikon rengi yeşil olsun
        final bool isQiblaInRange = qiblaAngle >= 300 && qiblaAngle <= 320;
        final Color iconColor = isQiblaInRange
            ? Colors.green
            : Theme.of(context).colorScheme.error;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 30.h, horizontal: 16.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 300.w,
                      height: 300.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.background,
                            Theme.of(
                              context,
                            ).colorScheme.surface.withOpacity(0.95),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 18,
                            offset: Offset(0, 8),
                          ),
                        ],
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.primary.withOpacity(0.2),
                          width: 4,
                        ),
                      ),
                      child: Transform.rotate(
                        angle:
                            ((deviceAngle + correctionOffset(deviceAngle)) *
                            pi /
                            -180),
                        child: Image.asset(
                          'images/kible.png',
                          width: 300.w,
                          height: 300.h,
                          fit: BoxFit.contain,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Transform.rotate(
                      angle: pi, // 180 derece
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: iconColor.withOpacity(0.3),
                              blurRadius: 18.w,
                              spreadRadius: 130.w,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_circle_down,
                          size: 100.sp,
                          color: iconColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 28.h),
                Card(
                  elevation: 3,
                  color: Theme.of(
                    context,
                  ).colorScheme.surface.withOpacity(0.98),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 16.h,
                      horizontal: 12.w,
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Cihazı yatay ve sabit konumda tutunuz',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.onSurface,
                            letterSpacing: 0.2,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.device_hub,
                              color: Theme.of(context).colorScheme.secondary,
                              size: 22.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Cihaz Açısı: ${(deviceAngle).toStringAsFixed(0)}°',
                              style: TextStyle(
                                fontSize: 20.sp,
                                color: Theme.of(context).colorScheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16.h),
                FittedBox(
                  child: Card(
                    elevation: 0,
                    color: Theme.of(
                      context,
                    ).colorScheme.error.withOpacity(0.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10.h,
                        horizontal: 10.w,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.error,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Cihaz Açısı: 110° ile 95° arası olmalıdır',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
