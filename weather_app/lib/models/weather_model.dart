class Weather {
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String condition;
  final String description;
  final bool isDay;

  const Weather({
    required this.temperature,
    required this.description,
    required this.condition,
    required this.tempMin,
    required this.tempMax,
    required this.isDay,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      condition: json['condition'],
      description: json['description'],
      temperature: json['temperature'].toDouble(),
      tempMin: json['tempMin'].toDouble(),
      tempMax: json['tempMax'].toDouble(),
      isDay: json['isDay'],
    );
  }
}
