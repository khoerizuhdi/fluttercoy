import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_icons/weather_icons.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Weather App',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const WeatherHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key});

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  String selectedCity = 'Jakarta';
  Map<String, dynamic>? currentWeather;
  List<Map<String, dynamic>> hourlyForecast = [];

  final Map<String, LatLon> cityCoordinates = {
    'Jakarta': LatLon(latitude: -6.2088, longitude: 106.8456),
    'Surabaya': LatLon(latitude: -7.2504, longitude: 112.7688),
    'Bandung': LatLon(latitude: -6.9175, longitude: 107.6191),
    'Medan': LatLon(latitude: 3.5952, longitude: 98.6722),
    'Yogyakarta': LatLon(latitude: -7.7956, longitude: 110.3695),
  };

  String getWeatherDescription(int code) {
    switch (code) {
      case 0:
        return "Clear sky";
      case 1:
      case 2:
        return "Partly cloudy";
      case 3:
        return "Overcast";
      case 45:
      case 48:
        return "Fog";
      case 51:
      case 53:
      case 55:
        return "Drizzle";
      case 61:
      case 63:
      case 65:
        return "Rain";
      case 71:
      case 73:
      case 75:
        return "Snow";
      case 80:
      case 81:
      case 82:
        return "Rain showers";
      case 95:
        return "Thunderstorm";
      default:
        return "Unknown weather";
    }
  }

  IconData getWeatherIcon(int code) {
    switch (code) {
      case 0:
        return Icons.sunny;
      case 1:
      case 2:
        return Icons.cloud_queue;
      case 3:
        return Icons.cloud;
      case 45:
      case 48:
        return Icons.foggy;
      case 51:
      case 53:
      case 55:
        return Icons.grain;
      case 61:
      case 63:
      case 65:
        return WeatherIcons.rain;
      case 71:
      case 73:
      case 75:
        return Icons.snowing;
      case 80:
      case 81:
      case 82:
        return Icons.thunderstorm;
      case 95:
        return Icons.thunderstorm;
      default:
        return Icons.cloud;
    }
  }

  Future<void> fetchWeatherAndForecast(String city) async {
    final coords = cityCoordinates[city]!;
    final url = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=${coords.latitude}&longitude=${coords.longitude}'
      '&current=temperature_2m,relativehumidity_2m,precipitation,weathercode,windspeed_10m&hourly=temperature_2m,weathercode&timezone=Asia/Jakarta',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      final times = jsonResponse['hourly']['time'] as List<dynamic>;
      final temps = jsonResponse['hourly']['temperature_2m'] as List<dynamic>;
      final weatherCodes =
          jsonResponse['hourly']['weathercode'] as List<dynamic>;

      List<Map<String, dynamic>> nextHoursForecast = [];
      DateTime now = DateTime.now();
      for (int i = 0; i < times.length; i++) {
        DateTime forecastTime = DateTime.parse(times[i]);
        if (forecastTime.isAfter(now) && nextHoursForecast.length < 6) {
          nextHoursForecast.add({
            'time': forecastTime,
            'temperature': temps[i],
            'weathercode': weatherCodes[i],
          });
        }
        if (nextHoursForecast.length >= 6) break;
      }

      setState(() {
        currentWeather = jsonResponse['current'];
        hourlyForecast = nextHoursForecast;
      });
    } else {
      setState(() {
        currentWeather = null;
        hourlyForecast = [];
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to get weather data')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeatherAndForecast(selectedCity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.network(
            'https://images.pexels.com/photos/53594/blue-clouds-day-fluffy-53594.jpeg?cs=srgb&dl=pexels-pixabay-53594.jpg&fm=jpg&w=1280&h=960&_gl=1*1ski3ld*_ga*MjU0ODk4NTU3LjE3NTk4MDcxMjY.*_ga_8JE65Q40S6*czE3NjAzNDE0MDUkbzMkZzAkdDE3NjAzNDE0MDUkajYwJGwwJGgw',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.2),
            colorBlendMode: BlendMode.darken,
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      constraints: const BoxConstraints(maxWidth: 750),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white.withOpacity(0.85),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              getWeatherIcon(
                                currentWeather?['weathercode'] ?? 0,
                              ),
                              size: 80,
                              color: Colors.blue,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '${currentWeather?['temperature_2m'] ?? "--"}°C',
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge
                                  ?.copyWith(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            // Centered city name with dropdown functionality
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: DropdownButton<String>(
                                  value: selectedCity,
                                  isDense: true,
                                  isExpanded: false,
                                  alignment: Alignment
                                      .center, // Center the dropdown content
                                  icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Colors.blue,
                                  ),
                                  underline: Container(), // Remove underline
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.bold,
                                      ),
                                  onChanged: (String? newCity) {
                                    if (newCity != null) {
                                      setState(() {
                                        selectedCity = newCity;
                                        currentWeather = null;
                                        hourlyForecast = [];
                                      });
                                      fetchWeatherAndForecast(selectedCity);
                                    }
                                  },
                                  items: cityCoordinates.keys.map((city) {
                                    return DropdownMenuItem<String>(
                                      value: city,
                                      child: Center(
                                        // Center the dropdown menu item
                                        child: Text(city.toUpperCase()),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              getWeatherDescription(
                                currentWeather?['weathercode'] ?? 0,
                              ),
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                StatBox(
                                  icon: Icons.wind_power,
                                  label: "Wind Flow",
                                  value:
                                      "${currentWeather?['windspeed_10m'] ?? '--'} m/s",
                                ),
                                StatBox(
                                  icon: Icons.water_drop,
                                  label: "Precipitation",
                                  value:
                                      "${currentWeather?['precipitation'] ?? '--'} mm",
                                ),
                                StatBox(
                                  icon: WeatherIcons.humidity,
                                  label: "Humidity",
                                  value:
                                      "${currentWeather?['relativehumidity_2m'] ?? '--'}%",
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            Text(
                              "Hourly Forecast",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.9,
                                constraints: const BoxConstraints(
                                  maxWidth: 600,
                                ),
                                height: 100,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: hourlyForecast.length,
                                  itemBuilder: (context, index) {
                                    final item = hourlyForecast[index];
                                    final hour = item['time'].hour;
                                    final temp = item['temperature'];
                                    final weatherCode = item['weathercode'];

                                    return Container(
                                      width: 80,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.blue.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            getWeatherIcon(weatherCode),
                                            size: 24,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$hour:00',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(color: Colors.black),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '$temp°C',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class LatLon {
  final double latitude;
  final double longitude;
  LatLon({required this.latitude, required this.longitude});
}

class StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const StatBox({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue, size: 32),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
