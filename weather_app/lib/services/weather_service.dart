import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_app/models/weather_model.dart';

class WeatherService {
  static const apiUrl = 'http://10.0.2.2:3000/weather';

  Future<Weather> getWeatherData(String city) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?city=$city'),
      );

      if (response.statusCode == 200) {
        return Weather.fromJson(
            jsonDecode(response.body) as Map<String, dynamic>);
      } else {
        throw jsonDecode(response.body);
      }
    } catch (e) {
      throw Exception(e);
    }
  }
}
