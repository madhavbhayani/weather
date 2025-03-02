import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:weather/models/weather_model.dart';

class WeatherService {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5';
  final String apiKey = dotenv.env['OPEN_WEATHER_API_KEY'] ?? '';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<WeatherModel> getCurrentWeather() async {
    try {
      final position = await getCurrentLocation();
      final response = await http.get(Uri.parse(
          '$baseUrl/weather?lat=${position.latitude}&lon=${position.longitude}&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<WeatherModel> getWeatherByCity(String city) async {
    try {
      final response = await http.get(
          Uri.parse('$baseUrl/weather?q=$city&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        return WeatherModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load weather data for $city');
      }
    } catch (e) {
      throw Exception('Error fetching weather data: $e');
    }
  }

  Future<ForecastModel> getForecast(double lat, double lon) async {
    try {
      final response = await http.get(Uri.parse(
          '$baseUrl/forecast?lat=$lat&lon=$lon&units=metric&appid=$apiKey'));

      if (response.statusCode == 200) {
        return ForecastModel.fromJson(json.decode(response.body));
      } else {
        throw Exception('Failed to load forecast data');
      }
    } catch (e) {
      throw Exception('Error fetching forecast data: $e');
    }
  }
}
