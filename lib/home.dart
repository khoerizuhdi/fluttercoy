import 'package:flutter/material.dart';

class WeatherHome extends StatelessWidget {
  const WeatherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Informasi Cuaca")),
      body: Column(
        children: [Text("data")
        ]),
    );
  }
}
