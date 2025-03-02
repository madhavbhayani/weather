import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/services/weather_service.dart';

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();

  WeatherModel? _currentWeather;
  ForecastModel? _forecast;
  bool _isLoading = false;
  String? _error;

  WeatherModel? get currentWeather => _currentWeather;
  ForecastModel? get forecast => _forecast;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCurrentLocationWeather() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getCurrentWeather();
      await _fetchForecast();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    if (city.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _currentWeather = await _weatherService.getWeatherByCity(city);
      await _fetchForecast();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _fetchForecast() async {
    if (_currentWeather == null) return;

    try {
      final position = await _weatherService.getCurrentLocation();
      _forecast = await _weatherService.getForecast(
          position.latitude, position.longitude);
    } catch (e) {
      _error = e.toString();
    }
  }
}
