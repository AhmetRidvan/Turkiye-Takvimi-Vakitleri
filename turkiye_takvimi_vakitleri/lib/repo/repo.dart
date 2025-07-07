import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:geolocator/geolocator.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/id_model.dart';
import 'package:turkiye_takvimi_vakitleri/models/time_model.dart';

class Repo {
  static Future<Position> getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Konum izinleri geçerli değil.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Konum izni reddedildi.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error('Konum ayarları sonsuza kadar reddedildi.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  static Future<IdModel> getId({
    required double lat,
    required double long,
  }) async {
    final _url =
        'http://www.turktakvim.com/XMLservis.php?tip=konum&latitude=$lat&longitude=$long&limit=10&radius=45&format=json';
    final _response = await Dio().get(_url);
    final data = IdModel.fromJson(jsonDecode(_response.data));
    return data;
  }

  static Future<Times> getTimes({required int id}) async {
    final _url =
        'https://www.turktakvim.com/XMLservis.php?tip=vakit&cityID=$id&format=json';
    final response = await Dio().get(_url);
    final object = Times.fromJson(jsonDecode(response.data));
    return object;
  }

  static Future<ArkaSayfaModel> getArkaSayfa(DateTime tarih) async {
    final _url =
        'https://www.turktakvim.com/JSONservis_takvim.php?baslangic=$tarih&bitis=$tarih&format=json';
    final x = await Dio().get(_url);
    final jsonX = x.data as List; 
    return ArkaSayfaModel.fromJson(jsonX[1]);
  }
  static Future<ArkaSayfaModel> getArkaSayfa2(DateTime tarih) async {
    final _url =
        'https://www.turktakvim.com/JSONservis_takvim.php?baslangic=$tarih&bitis=$tarih&format=json';
    final x = await Dio().get(_url);
    final jsonX = x.data as List; 
    return ArkaSayfaModel.fromJson(jsonX[1]);
  }
}
