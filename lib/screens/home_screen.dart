import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:weather/models/weather_model.dart';
import 'package:weather/providers/weather_provider.dart';
import 'package:weather/utils/time_based_gradient.dart';
import 'package:weather/widgets/current_weather.dart';
import 'package:weather/widgets/forecast_section.dart';
import 'package:weather/widgets/search_bar.dart';
import 'package:weather/widgets/sun_path_chart.dart';
import 'package:weather/widgets/weather_details.dart';
import 'package:weather/widgets/loading_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch weather data when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchCurrentLocationWeather();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final weatherProvider = Provider.of<WeatherProvider>(context);
    final weather = weatherProvider.currentWeather;
    final forecast = weatherProvider.forecast;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          weather?.cityName ?? 'Weather App',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => weatherProvider.fetchCurrentLocationWeather(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: weather != null
              ? TimeBasedGradient.getGradientForWeather(weather.main)
              : TimeBasedGradient.getGradient(),
        ),
        child: weatherProvider.isLoading
            ? const LoadingWidget()
            : weatherProvider.error != null
                ? _buildErrorWidget(weatherProvider.error!)
                : weather != null
                    ? _buildWeatherContent(context, weather, forecast)
                    : const Center(
                        child: Text(
                          'No weather data available',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
      ),
      bottomSheet: WeatherSearchBar(
        controller: _searchController,
        onSubmitted: (city) {
          weatherProvider.fetchWeatherByCity(city);
          _searchController.clear();
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Widget _buildWeatherContent(
      BuildContext context, WeatherModel weather, ForecastModel? forecast) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () =>
            context.read<WeatherProvider>().fetchCurrentLocationWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CurrentWeather(weather: weather)
                    .animate()
                    .fade(duration: 500.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
                const SizedBox(height: 20),
                WeatherDetails(weather: weather)
                    .animate()
                    .fade(duration: 500.ms, delay: 200.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
                const SizedBox(height: 20),
                SunPathChart(
                  sunrise: weather.sunrise,
                  sunset: weather.sunset,
                  currentTime: weather.dt,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 400.ms)
                    .slideY(begin: 0.3, end: 0, duration: 500.ms),
                const SizedBox(height: 20),
                if (forecast != null)
                  ForecastSection(forecast: forecast)
                      .animate()
                      .fade(duration: 500.ms, delay: 600.ms)
                      .slideY(begin: 0.3, end: 0, duration: 500.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Oops! Something went wrong',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              error,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white70,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                context.read<WeatherProvider>().fetchCurrentLocationWeather();
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.blue,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
