class WeatherModel {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final double minTemp;
  final double maxTemp;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final String description;
  final String iconCode;
  final int sunrise;
  final int sunset;
  final int dt;
  final String main;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.minTemp,
    required this.maxTemp,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.description,
    required this.iconCode,
    required this.sunrise,
    required this.sunset,
    required this.dt,
    required this.main,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['name'] ?? 'Unknown',
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      minTemp: (json['main']['temp_min'] as num).toDouble(),
      maxTemp: (json['main']['temp_max'] as num).toDouble(),
      pressure: json['main']['pressure'] as int,
      humidity: json['main']['humidity'] as int,
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      description: (json['weather'][0]['description'] as String).capitalize(),
      iconCode: json['weather'][0]['icon'] as String,
      sunrise: json['sys']['sunrise'] as int,
      sunset: json['sys']['sunset'] as int,
      dt: json['dt'] as int,
      main: json['weather'][0]['main'] as String,
    );
  }
}

class ForecastModel {
  final List<DailyForecast> daily;

  ForecastModel({required this.daily});

  factory ForecastModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dailyData = json['list'];

    // Group forecasts by day
    final Map<String, List<dynamic>> groupedForecasts = {};
    for (var item in dailyData) {
      final date = DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final dateString = '${date.year}-${date.month}-${date.day}';

      if (!groupedForecasts.containsKey(dateString)) {
        groupedForecasts[dateString] = [];
      }

      groupedForecasts[dateString]!.add(item);
    }

    // Create daily forecasts from grouped data
    final List<DailyForecast> dailyForecasts = [];
    groupedForecasts.forEach((date, forecasts) {
      if (dailyForecasts.length < 3) {
        // Only take first 3 days
        dailyForecasts.add(DailyForecast.fromForecasts(forecasts));
      }
    });

    return ForecastModel(daily: dailyForecasts);
  }
}

class DailyForecast {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final String iconCode;
  final String description;

  DailyForecast({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.iconCode,
    required this.description,
  });

  factory DailyForecast.fromForecasts(List<dynamic> forecasts) {
    double maxTemp = -100;
    double minTemp = 100;
    String iconCode = '';
    String description = '';

    // Find min/max temperatures across all forecasts for the day
    for (var forecast in forecasts) {
      final temp = (forecast['main']['temp'] as num).toDouble();
      if (temp > maxTemp) maxTemp = temp;
      if (temp < minTemp) minTemp = temp;

      // Use noon forecast for icon if available
      final time = DateTime.fromMillisecondsSinceEpoch(forecast['dt'] * 1000);
      if (time.hour >= 11 && time.hour <= 13) {
        iconCode = forecast['weather'][0]['icon'];
        description = forecast['weather'][0]['description'];
      }
    }

    // If no noon forecast, use the first one
    if (iconCode.isEmpty) {
      iconCode = forecasts.first['weather'][0]['icon'];
      description = forecasts.first['weather'][0]['description'];
    }

    return DailyForecast(
      date: DateTime.fromMillisecondsSinceEpoch(forecasts.first['dt'] * 1000),
      maxTemp: maxTemp,
      minTemp: minTemp,
      iconCode: iconCode,
      description: description.capitalize(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return split(' ').map((word) {
      if (word.isEmpty) return '';
      return word[0].toUpperCase() + word.substring(1);
    }).join(' ');
  }
}
