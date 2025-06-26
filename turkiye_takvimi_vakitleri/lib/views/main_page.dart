import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/background.png', fit: BoxFit.fill),
          Positioned(child: customDrawerButton(), top: 0, left: 10),
        ],
      ),
    );
  }

  Widget customDrawerButton() {
    return Text("asd");
  }
}
