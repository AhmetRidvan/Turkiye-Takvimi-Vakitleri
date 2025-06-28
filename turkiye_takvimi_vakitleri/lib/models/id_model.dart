class IdModel {
  List<Sehir>? sehir;

  IdModel({this.sehir});

  IdModel.fromJson(Map<String, dynamic> json) {
    if (json['sehir'] != null) {
      sehir = <Sehir>[];
      json['sehir'].forEach((v) {
        sehir!.add(Sehir.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (sehir != null) {
      data['sehir'] = sehir!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Sehir {
  String? iD;
  String? cityNameEN;
  String? cityNameTR;
  String? cityStateTR;
  String? arz;
  String? tul;
  String? mesafe;

  Sehir(
      {this.iD,
      this.cityNameEN,
      this.cityNameTR,
      this.cityStateTR,
      this.arz,
      this.tul,
      this.mesafe});

  Sehir.fromJson(Map<String, dynamic> json) {
    iD = json['ID'];
    cityNameEN = json['CityNameEN'];
    cityNameTR = json['CityNameTR'];
    cityStateTR = json['CityStateTR'];
    arz = json['arz'];
    tul = json['tul'];
    mesafe = json['mesafe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ID'] = iD;
    data['CityNameEN'] = cityNameEN;
    data['CityNameTR'] = cityNameTR;
    data['CityStateTR'] = cityStateTR;
    data['arz'] = arz;
    data['tul'] = tul;
    data['mesafe'] = mesafe;
    return data;
  }
}
