import 'package:flutter/material.dart';

class WeatherHome extends StatelessWidget {
  const WeatherHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1513002749550-c59d786b8e6c?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8OHx8Y2xvdWR8ZW58MHx8MHx8fDA%3D",
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            color: Colors.white60,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: AppBar().preferredSize.height),
                Text("30°", style: TextStyle(fontSize: 80)),
                Text("Cerah Berawan", style: TextStyle(fontSize: 25)),
                Text("data"),
                Text("data"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
