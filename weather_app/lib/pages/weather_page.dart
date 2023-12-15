import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_app/models/weather_model.dart';
import 'package:weather_app/services/weather_service.dart';
import 'package:weather_app/utils/capitalize.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherState();
}

class _WeatherState extends State<WeatherPage> {
  final _weatherService = WeatherService();
  final TextEditingController _cityController = TextEditingController();
  Weather? _weather;
  bool loading = false;

  // fetch weather
  _fetchWeather() async {
    try {
      final weather =
          await _weatherService.getWeatherData(_cityController.text);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: const Text(
            "Flutter Weather",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white),
          ),
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                TextField(
                  textAlign: TextAlign.center,
                  controller: _cityController,
                  decoration: const InputDecoration(
                    hintText: 'Enter city name',
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _fetchWeather();
                  },
                  child: const Text('Get Weather'),
                ),
                const SizedBox(height: 20),
                Lottie.asset('assets/sun.json'),
                Text(' ${_weather?.temperature.round().toString()}°',
                    style: const TextStyle(
                      fontSize: 100,
                      fontWeight: FontWeight.w300,
                    )),
                Text(
                  (_weather != null) ? _weather!.description.capitalize() : '-',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('H: ${_weather?.tempMax.round().toString()}°'),
                      const Padding(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Center(
                            child: SizedBox(
                          width: 1,
                          height: 30,
                        )),
                      ),
                      Text('L: ${_weather?.tempMin.round().toString()}°'),
                    ]),
              ],
            ),
          ),
        ));
  }
}
