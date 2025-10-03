import 'package:belajarflutter1/bebas.dart';
import 'package:flutter/material.dart';
import 'package:belajarflutter1/home.dart';

void main() {
  runApp(MaterialApp(home: WeatherHome()));
}

class BelajarFlutter extends StatelessWidget {
  const BelajarFlutter({super.key});

  @override
  Widget build(BuildContext context) {
    var daftar_fasilitas = [
      {"icon": Icons.food_bank, "label": "Sarapan"},
      {"icon": Icons.ac_unit, "label": "Penyejuk Ruangan"},
      {"icon": Icons.access_alarm, "label": "Pengingat Bangun"},
      {"icon": Icons.smoke_free, "label": "Bebas Asap Rokok"},
    ];
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: Text("Hotel Flutter"), centerTitle: true),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                "https://assets.el-hotels.com/elhotel/1655e0e5-2119-46cf-920f-289c0775e6ef.png",
                height: 250,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hotel Flutter kemayoran",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 19,
                            ),
                          ),
                          Text(
                            "Kemayoran, Jakarta Pusat",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.star, color: Colors.amber, size: 30),
                    Text("120"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(children: [Icon(Icons.phone), Text("Call")]),
                    Column(children: [Icon(Icons.navigation), Text("Route")]),
                    Column(children: [Icon(Icons.share), Text("Share")]),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  "Fasilitas",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  spacing: 10,
                  children: daftar_fasilitas.map((data) {
                    return Row(
                      children: [
                        Icon(data["icon"] as IconData),
                        Text(data["label"] as String),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16, top: 20, right: 16),
                child: Text(
                  """ Indeks tahunan tersebut menilai lebih dari 100 kota global berdasarkan 70 indikator yang terbagi dalam empat kategori utama: pengelolaan destinasi, rantai pasokan, keberlanjutan sosial, dan kinerja lingkungan. Indikatornya mencakup manajemen wisatawan, dampak lingkungan dari transportasi, keselamatan, hingga komitmen terhadap perubahan iklim. "Helsinki terus menetapkan standar baru dalam pengelolaan destinasi regeneratif. Melalui aksi iklim yang progresif, strategi berkelanjutan yang inovatif, dan komitmen kuat terhadap transparansi, kota ini menunjukkan visi yang luar biasa," CEO GDS-Movement, Guy Bigwood.
                  Indeks tahunan tersebut menilai lebih dari 100 kota global berdasarkan 70 indikator yang terbagi dalam empat kategori utama: pengelolaan destinasi, rantai pasokan, keberlanjutan sosial, dan kinerja lingkungan. Indikatornya mencakup manajemen wisatawan, dampak lingkungan dari transportasi, keselamatan, hingga komitmen terhadap perubahan iklim. "Helsinki terus menetapkan standar baru dalam pengelolaan destinasi regeneratif. Melalui aksi iklim yang progresif, strategi berkelanjutan yang inovatif, dan komitmen kuat terhadap transparansi, kota ini menunjukkan visi yang luar biasa," CEO GDS-Movement, Guy Bigwood.""",
                  textAlign: TextAlign.justify,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
