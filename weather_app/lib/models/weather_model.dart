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
}
