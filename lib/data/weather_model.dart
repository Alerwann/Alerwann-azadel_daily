class Weather {
  final String townName;
  final double temperature;
  final String sunny;

  Weather({
    required this.townName,
    required this.temperature,
    required this.sunny,
  });

  factory Weather.fromJson(Map<String, dynamic> json, String cityName) {
    // L'API Open-Meteo renvoie la température dans "current_weather" -> "temperature"
    final current = json['current_weather'];
    final temp = current['temperature'];

    final code = current['weathercode'];
    String description = "Inconnu";
    if (code == 0) {
      description = "Ensoleillé";
    } else if (code <= 3) {
      description = "Nuageux";
    } else if (code >= 50) {
      description = "Pluvieux";
    }

    return Weather(
      townName: cityName,
      temperature: temp.toDouble(),
      sunny: description,
    );
  }
}
