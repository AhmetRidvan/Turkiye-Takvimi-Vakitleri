class Times {
    Times({
        required this.attributes,
        required this.cityinfo,
    });

    final TimesAttributes? attributes;
    final Cityinfo? cityinfo;

    factory Times.fromJson(Map<String, dynamic> json){ 
        return Times(
            attributes: json["@attributes"] == null ? null : TimesAttributes.fromJson(json["@attributes"]),
            cityinfo: json["cityinfo"] == null ? null : Cityinfo.fromJson(json["cityinfo"]),
        );
    }

}

class TimesAttributes {
    TimesAttributes({
        required this.encoding,
        required this.version,
    });

    final String? encoding;
    final String? version;

    factory TimesAttributes.fromJson(Map<String, dynamic> json){ 
        return TimesAttributes(
            encoding: json["encoding"],
            version: json["version"],
        );
    }

}

class Cityinfo {
    Cityinfo({
        required this.attributes,
        required this.vakit,
    });

    final CityinfoAttributes? attributes;
    final List<Vakit> vakit;

    factory Cityinfo.fromJson(Map<String, dynamic> json){ 
        return Cityinfo(
            attributes: json["@attributes"] == null ? null : CityinfoAttributes.fromJson(json["@attributes"]),
            vakit: json["vakit"] == null ? [] : List<Vakit>.from(json["vakit"]!.map((x) => Vakit.fromJson(x))),
        );
    }

}

class CityinfoAttributes {
    CityinfoAttributes({
        required this.id,
        required this.countryId,
        required this.cityNameTr,
        required this.cityNameEn,
        required this.cityStateTr,
        required this.cityStateEn,
        required this.arzDer,
        required this.arzDak,
        required this.arzYon,
        required this.tulDer,
        required this.tulDak,
        required this.tulYon,
        required this.sTulDer,
        required this.sTulDak,
        required this.sTulYon,
        required this.tchange,
        required this.height,
        required this.scale,
        required this.summerStart,
        required this.summerEnd,
        required this.qiblaangle,
        required this.magdeg,
    });

    final String? id;
    final String? countryId;
    final String? cityNameTr;
    final String? cityNameEn;
    final String? cityStateTr;
    final String? cityStateEn;
    final String? arzDer;
    final String? arzDak;
    final String? arzYon;
    final String? tulDer;
    final String? tulDak;
    final String? tulYon;
    final String? sTulDer;
    final String? sTulDak;
    final String? sTulYon;
    final String? tchange;
    final String? height;
    final String? scale;
    final String? summerStart;
    final String? summerEnd;
    final String? qiblaangle;
    final String? magdeg;

    factory CityinfoAttributes.fromJson(Map<String, dynamic> json){ 
        return CityinfoAttributes(
            id: json["ID"],
            countryId: json["countryID"],
            cityNameTr: json["cityNameTR"],
            cityNameEn: json["cityNameEN"],
            cityStateTr: json["cityStateTR"],
            cityStateEn: json["cityStateEN"],
            arzDer: json["arzDer"],
            arzDak: json["arzDak"],
            arzYon: json["arzYon"],
            tulDer: json["tulDer"],
            tulDak: json["tulDak"],
            tulYon: json["tulYon"],
            sTulDer: json["STulDer"],
            sTulDak: json["STulDak"],
            sTulYon: json["STulYon"],
            tchange: json["tchange"],
            height: json["height"],
            scale: json["scale"],
            summerStart: json["summerStart"],
            summerEnd: json["summerEnd"],
            qiblaangle: json["qiblaangle"],
            magdeg: json["magdeg"],
        );
    }

}

class Vakit {
    Vakit({
        required this.attributes,
        required this.imsak,
        required this.sabah,
        required this.gunes,
        required this.israk,
        required this.dahve,
        required this.kerahet,
        required this.ogle,
        required this.ikindi,
        required this.asrisani,
        required this.isfirar,
        required this.aksam,
        required this.istibak,
        required this.yatsi,
        required this.isaisani,
        required this.geceyarisi,
        required this.teheccud,
        required this.seher,
        required this.kible,
    });

    final VakitAttributes? attributes;
    final String? imsak;
    final String? sabah;
    final String? gunes;
    final String? israk;
    final String? dahve;
    final String? kerahet;
    final String? ogle;
    final String? ikindi;
    final String? asrisani;
    final String? isfirar;
    final String? aksam;
    final String? istibak;
    final String? yatsi;
    final String? isaisani;
    final String? geceyarisi;
    final String? teheccud;
    final String? seher;
    final String? kible;

    factory Vakit.fromJson(Map<String, dynamic> json){ 
        return Vakit(
            attributes: json["@attributes"] == null ? null : VakitAttributes.fromJson(json["@attributes"]),
            imsak: json["imsak"],
            sabah: json["sabah"],
            gunes: json["gunes"],
            israk: json["israk"],
            dahve: json["dahve"],
            kerahet: json["kerahet"],
            ogle: json["ogle"],
            ikindi: json["ikindi"],
            asrisani: json["asrisani"],
            isfirar: json["isfirar"],
            aksam: json["aksam"],
            istibak: json["istibak"],
            yatsi: json["yatsi"],
            isaisani: json["isaisani"],
            geceyarisi: json["geceyarisi"],
            teheccud: json["teheccud"],
            seher: json["seher"],
            kible: json["kible"],
        );
    }

}

class VakitAttributes {
    VakitAttributes({
        required this.tarih,
        required this.gun,
        required this.hicri,
    });

    final DateTime? tarih;
    final String? gun;
    final String? hicri;

    factory VakitAttributes.fromJson(Map<String, dynamic> json){ 
        return VakitAttributes(
            tarih: DateTime.tryParse(json["tarih"] ?? ""),
            gun: json["gun"],
            hicri: json["hicri"],
        );
    }

}
