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

  // Location servisi açık mı kontrol et
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Servis kapalı ise İstanbul koordinatlarını döndür
    return Position(
      latitude: 41.0082,  // İstanbul enlemi
      longitude: 28.9784, // İstanbul boylamı
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,altitudeAccuracy: 0.0, headingAccuracy: 0.0,
    );
  }

  // İzin kontrolü
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Reddedilirse İstanbul'u döndür
      return Position(
        latitude: 41.0082,
        longitude: 28.9784,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,altitudeAccuracy: 0.0, headingAccuracy: 0.0
      );
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Sonsuza kadar reddedildiyse yine İstanbul'u döndür
    return Position(
      latitude: 41.0082,
      longitude: 28.9784,
      timestamp: DateTime.now(),
      accuracy: 1.0,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0, altitudeAccuracy: 0.0, headingAccuracy: 0.0,
    );
  }

  // Buraya gelirse izin var demektir, gerçek konumu döndür
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
