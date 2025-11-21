import 'dart:convert';
import 'package:azadel_daily/data/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart'; // <--- Nouvel import

class WeatherRepository {
  // Ta méthode existante (on la garde au cas où)
  Future<Weather> getWeather(String city) async {
    final geoUrl = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$city&count=1&language=fr&format=json',
    );
    final geoResponse = await http.get(geoUrl);
    if (geoResponse.statusCode != 200) throw Exception("Erreur API Geo");
    final geoJson = jsonDecode(geoResponse.body);
    if (geoJson['results'] == null || (geoJson['results'] as List).isEmpty) {
      throw Exception("Ville introuvable");
    }
    final location = geoJson['results'][0];
    return _getWeatherFromCoords(
      location['latitude'],
      location['longitude'],
      location['name'],
    );
  }


  Future<Weather> getWeatherByLocation() async {
    // 1. Vérifier les permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('Le GPS est désactivé.');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Permission GPS refusée.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Permission GPS refusée définitivement.');
    }

    // 2. Récupérer la position actuelle
    Position position = await Geolocator.getCurrentPosition();

    // 3. Appeler la météo avec ces coordonnées
    // (On ne connait pas le nom de la ville, donc on met "Ma Position" ou on pourrait faire un reverse geocoding)
    return _getWeatherFromCoords(
      position.latitude,
      position.longitude,
      "Ma Position",
    );
  }

  // Petite méthode privée pour éviter de dupliquer le code de l'appel météo
  Future<Weather> _getWeatherFromCoords(
    double lat,
    double lon,
    String name,
  ) async {
    final weatherUrl = Uri.parse(
      'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current_weather=true',
    );
    final weatherResponse = await http.get(weatherUrl);
    if (weatherResponse.statusCode != 200) throw Exception("Erreur Météo");
    final weatherJson = jsonDecode(weatherResponse.body);
    return Weather.fromJson(weatherJson, name);
  }
}
