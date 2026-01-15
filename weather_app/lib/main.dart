import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:weather_app/models/weather.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pinkAccent, // Changed theme seed to pink
      ),
      home: const WeatherHomeScreen(),
    );
  }
}

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  final String _apiKey';
  Weather? _weather;
  bool _isLoading = false;
  String _error = '';
  final TextEditingController _cityController = TextEditingController(text: 'Manila');

  Future<void> fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    try {
      final url = 'https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$_apiKey&units=metric';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          _weather = Weather.fromJson(jsonDecode(response.body));
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'City not found or API error';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Failed to connect to the internet';
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchWeather('Manila');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFDEE9), // Soft Pink
              Color(0xFFB5FFFC), // Soft Cyan for a "colorful" contrast
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Colorful Search Bar
                TextField(
                  controller: _cityController,
                  style: const TextStyle(color: Colors.pinkAccent),
                  decoration: InputDecoration(
                    hintText: 'Enter city name...',
                    hintStyle: TextStyle(color: Colors.pink.withOpacity(0.5)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search, color: Colors.pinkAccent),
                      onPressed: () => fetchWeather(_cityController.text),
                    ),
                  ),
                  onSubmitted: fetchWeather,
                ),
                const SizedBox(height: 50),

                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.pinkAccent)
                else if (_error.isNotEmpty)
                  Text(_error, style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold))
                else if (_weather != null) ...[
                    // Main Weather Info with Pink Fonts
                    Text(
                      _weather!.city,
                      style: const TextStyle(
                          fontSize: 45,
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                          shadows: [Shadow(color: Colors.white, blurRadius: 10)]
                      ),
                    ),
                    Text(
                      '${_weather!.temperature.toStringAsFixed(1)}°C',
                      style: const TextStyle(
                          fontSize: 90,
                          color: Colors.pinkAccent,
                          fontWeight: FontWeight.w300
                      ),
                    ),
                    Text(
                      _weather!.description.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 22,
                          color: Color(0xFFD81B60), // Deep Pink
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Detail Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _detailTile(Icons.water_drop, 'Humidity', '${_weather!.humidity}%'),
                        _detailTile(Icons.air, 'Wind', '${_weather!.windSpeed} m/s'),
                      ],
                    ),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailTile(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.pink.withOpacity(0.1),
              blurRadius: 10,
              spreadRadius: 2,
            )
          ]
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.pinkAccent, size: 30),
          const SizedBox(height: 8),
          Text(
              label,
              style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600)
          ),
          Text(
              value,
              style: const TextStyle(
                  color: Colors.pink,
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              )
          ),
        ],
      ),
    );
  }
}
