import 'package:flutter/material.dart';
import 'package:turkiye_takvimi_vakitleri/models/arka_sayfa_model.dart';

class ArkaSayfaPage extends StatefulWidget {
  ArkaSayfaPage({super.key});

  @override
  State<ArkaSayfaPage> createState() => _ArkaSayfaPageState();
}

class _ArkaSayfaPageState extends State<ArkaSayfaPage> {
  ArkaSayfaModel? a1;

  @override
  void initState()  {
    super.initState();
    getir();
  }

  Future<void> getir() async {
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center());
  }
}
