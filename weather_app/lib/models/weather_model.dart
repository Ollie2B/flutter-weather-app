class Weather {
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final String iconCode;
  final bool isDay;

  const Weather({
    required this.temperature,
    required this.description,
    required this.condition,
    required this.iconCode,
    required this.tempMin,
    required this.tempMax,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {
        'temperature': double temperature,
        'description': String description,
        'condition': String condition,
        'iconCode': String iconCode,
        'tempMin': double tempMin,
        'tempMax': double tempMax,
        'isDay': bool isDay,
      } =>
        Weather(
          temperature: temperature,
          description: description,
          condition: condition,
          iconCode: iconCode,
          tempMin: tempMin,
          tempMax: tempMax,
          isDay: isDay,
        ),
      _ => throw const FormatException('Failed to load weather.'),
    };
  }
}
