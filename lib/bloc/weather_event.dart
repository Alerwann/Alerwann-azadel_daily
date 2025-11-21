abstract class WeatherEvent {}

class GetWeather extends WeatherEvent {
  final String cityName;
  GetWeather(this.cityName);
}
class GetWeatherByGps extends WeatherEvent {}
