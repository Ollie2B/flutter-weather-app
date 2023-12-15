import 'dart:convert';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weather_app/utils/weather_icon.dart';

class Weather {
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String description;
  final String iconCode;

  const Weather(
      {required this.temperature,
      required this.description,
      required this.iconCode,
      required this.tempMin,
      required this.tempMax});

  factory Weather.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'temperature': double temperature,
        'description': String description,
        'iconCode': String iconCode,
        'tempMin': double tempMin,
        'tempMax': double tempMax,
      } =>
        Weather(
          temperature: temperature,
          description: description,
          iconCode: iconCode,
          tempMin: tempMin,
          tempMax: tempMax,
        ),
      _ => throw const FormatException('Failed to load weather.'),
    };
  }

  IconData getIconData() {
    switch (iconCode) {
      case '01d':
        return WeatherIcons.clearDay;
      case '01n':
        return WeatherIcons.clearNight;
      case '02d':
        return WeatherIcons.fewCloudsDay;
      case '02n':
        return WeatherIcons.fewCloudsDay;
      case '03d':
      case '04d':
        return WeatherIcons.cloudsDay;
      case '03n':
      case '04n':
        return WeatherIcons.clearNight;
      case '09d':
        return WeatherIcons.showerRainDay;
      case '09n':
        return WeatherIcons.showerRainNight;
      case '10d':
        return WeatherIcons.rainDay;
      case '10n':
        return WeatherIcons.rainNight;
      case '11d':
        return WeatherIcons.thunderStormDay;
      case '11n':
        return WeatherIcons.thunderStormNight;
      case '13d':
        return WeatherIcons.snowDay;
      case '13n':
        return WeatherIcons.snowNight;
      case '50d':
        return WeatherIcons.mistDay;
      case '50n':
        return WeatherIcons.mistNight;
      default:
        return WeatherIcons.clearDay;
    }
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather App'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _cityController = TextEditingController();
  Future<Weather>? _futureWeather;

  Future<Weather> getWeatherData(String city) async {
    const apiUrl = 'http://10.0.2.2:3000/weather';

    final response = await http.get(
      Uri.parse('$apiUrl?city=$city'),
    );

    if (response.statusCode == 200) {
      return Weather.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>);
    } else {
      // Handle error
      throw Exception('Failed to fetch data.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: _cityController,
              decoration: const InputDecoration(labelText: 'Enter city name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _futureWeather = getWeatherData(_cityController.text);
                });
              },
              child: const Text('Get Weather'),
            ),
            const SizedBox(height: 20),
            if (_futureWeather != null) buildFutureBuilder(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<Weather> buildFutureBuilder() {
    return FutureBuilder<Weather>(
      future: _futureWeather,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(
              snapshot.data!.getIconData(),
              size: 70,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(' ${snapshot.data!.temperature.round().toString()}°',
                // style: Theme.of(context).textTheme.headlineMedium,
                style: const TextStyle(
                  fontSize: 100,
                  fontWeight: FontWeight.w100,
                )),
            Text(
              snapshot.data!.description.capitalize(),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('H: ${snapshot.data!.tempMax.round().toString()}°'),
              const Padding(
                padding: EdgeInsets.only(left: 15, right: 15),
                child: Center(
                    child: SizedBox(
                  width: 1,
                  height: 30,
                )),
              ),
              Text('L: ${snapshot.data!.tempMin.round().toString()}°'),
            ]),
          ]);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
