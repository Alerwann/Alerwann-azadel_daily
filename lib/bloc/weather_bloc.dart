import 'package:azadel_daily/bloc/weather_event.dart';
import 'package:azadel_daily/bloc/weather_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/weather_repository.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository repository;

  WeatherBloc(this.repository) : super(WeatherInitial()) {
    on<GetWeather>((event, emit) async {
      print("🌤️ avant loading");

      emit(WeatherLoading("Chargement"));

      try {
        print("🌤️ début de try");
        final weather = await repository.getWeather(event.cityName);
        print("🌤️ je suis dans getweather");

        emit(WeatherLoaded(weather));
      } catch (e) {
        emit(WeatherError(e.toString()));
      }
    });

    on<GetWeatherByGps>((event, emit) async {
      emit(WeatherLoading("Localisation en cours..."));
      try {
        final weather = await repository.getWeatherByLocation();
        emit(WeatherLoaded(weather));
      } catch (e) {
  
        print("Erreur GPS ($e), bascule sur la ville par défaut.");
        add(GetWeather("Châtenoy-le-royal"));
      }
    });
  
  }
}
