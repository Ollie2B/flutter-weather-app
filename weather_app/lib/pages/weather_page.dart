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

  // weather animations
  String getWeatherAnimation(
      String? condition, String? description, bool? isDay) {
    if (condition == null || isDay == null || description == null) {
      return "assets/sunny.json";
    }

    switch (condition.toLowerCase()) {
      case 'clouds':
        if (description == "scattered clouds" || description == "few clouds") {
          if (isDay) return "assets/fewclouds_day.json";
          return "assets/fewclouds_night.json";
        }
        return "assets/clouds.json";
      case 'mist':
      case 'smoke':
      case 'haze':
      case 'dust':
      case 'fog':
        return "assets/mist.json";
      case 'rain':
      case 'drizzle':
      case 'shower rain':
        if (isDay) return "assets/rain_day.json";
        return "assets/rain_night.json";
      case 'thunderstorm':
        return "assets/thunder.json";
      case 'snow':
        return "assets/snow.json";
      case 'clear':
        if (isDay) return "assets/sunny.json";
        return "assets/moon.json";
      default:
        return "assets/sunny.json";
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
                Lottie.asset(getWeatherAnimation(_weather?.condition,
                    _weather?.description, _weather?.isDay)),
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
