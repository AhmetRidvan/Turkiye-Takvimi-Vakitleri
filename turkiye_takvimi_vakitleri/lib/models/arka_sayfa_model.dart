class ArkaSayfaModel {

  final Veri? veri;

  ArkaSayfaModel({required this.veri});

  factory ArkaSayfaModel.fromJson(Map<String, dynamic> json) {
    return ArkaSayfaModel(
      veri: Veri.fromJson(json['Veri']),
    );
  }
}

class Veri {
  final String miladiTarih;
  final String hicriTarih;
  final int hicriSemsi;
  final String rumi;
  final String hizirKasim;
  final String gunDurumu;
  final String ezaniDurum;
  final String gununSozu;
  final String gununOlayi;
  final String isimYemek;
  final Arkayuz arkayuz;

  Veri({
    required this.miladiTarih,
    required this.hicriTarih,
    required this.hicriSemsi,
    required this.rumi,
    required this.hizirKasim,
    required this.gunDurumu,
    required this.ezaniDurum,
    required this.gununSozu,
    required this.gununOlayi,
    required this.isimYemek,
    required this.arkayuz,
  });

  factory Veri.fromJson(Map<String, dynamic> json) {
    return Veri(
      miladiTarih: json['MiladiTarih'],
      hicriTarih: json['HicriTarih'],
      hicriSemsi: json['HicriSemsi'],
      rumi: json['Rumi'],
      hizirKasim: json['HizirKasim'],
      gunDurumu: json['GunDurumu'],
      ezaniDurum: json['EzaniDurum'],
      gununSozu: json['GununSozu'],
      gununOlayi: json['GununOlayi'],
      isimYemek: json['IsimYemek'],
      arkayuz: Arkayuz.fromJson(json['Arkayuz']),
    );
  }
}

class Arkayuz {
  final String baslik;
  final String yazi;

  Arkayuz({
    required this.baslik,
    required this.yazi,
  });

  factory Arkayuz.fromJson(Map<String, dynamic> json) {
    return Arkayuz(
      baslik: json['Baslik'],
      yazi: json['Yazi'],
    );
  }
}
