import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/weather_model.dart';

class CurrentWeather extends StatelessWidget {
  final WeatherModel weather;

  const CurrentWeather({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${weather.temperature.round()}°C',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      weather.description,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('EEEE, d MMMM').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              weather.dt * 1000)),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
                _buildWeatherIcon(weather.main, weather.iconCode),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _WeatherInfoItem(
                  icon: Icons.arrow_downward,
                  label: 'Min',
                  value: '${weather.minTemp.round()}°',
                ),
                _WeatherInfoItem(
                  icon: Icons.arrow_upward,
                  label: 'Max',
                  value: '${weather.maxTemp.round()}°',
                ),
                _WeatherInfoItem(
                  icon: Icons.thermostat,
                  label: 'Feels like',
                  value: '${weather.feelsLike.round()}°',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String main, String iconCode) {
    final bool isNight = iconCode.contains('n');

    IconData iconData;
    Color iconColor;
    double iconSize = 80;

    if (isNight) {
      iconColor = Colors.grey.shade300;
      // Night icons
      switch (main.toLowerCase()) {
        case 'clear':
          iconData = Icons.nightlight_round;
          break;
        case 'clouds':
          iconData = Icons.nights_stay;
          break;
        case 'rain':
        case 'drizzle':
          iconData = Icons.grain;
          break;
        case 'thunderstorm':
          iconData = Icons.flash_on;
          break;
        case 'snow':
          iconData = Icons.ac_unit;
          break;
        default:
          iconData = Icons.nightlight_round;
      }
    } else {
      iconColor = Colors.amber;
      // Day icons
      switch (main.toLowerCase()) {
        case 'clear':
          iconData = Icons.wb_sunny;
          break;
        case 'clouds':
          iconData = Icons.cloud;
          break;
        case 'rain':
        case 'drizzle':
          iconData = Icons.grain;
          break;
        case 'thunderstorm':
          iconData = Icons.flash_on;
          break;
        case 'snow':
          iconData = Icons.ac_unit;
          break;
        default:
          iconData = Icons.wb_sunny;
      }
    }

    return Container(
      width: 110,
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(55),
      ),
      child: AnimatedWeatherIcon(
        iconData: iconData,
        iconColor: iconColor,
        iconSize: iconSize,
      ),
    );
  }
}

class AnimatedWeatherIcon extends StatefulWidget {
  final IconData iconData;
  final Color iconColor;
  final double iconSize;

  const AnimatedWeatherIcon({
    super.key,
    required this.iconData,
    required this.iconColor,
    required this.iconSize,
  });

  @override
  State<AnimatedWeatherIcon> createState() => _AnimatedWeatherIconState();
}

class _AnimatedWeatherIconState extends State<AnimatedWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.scale(
            scale: _animation.value,
            child: Icon(
              widget.iconData,
              color: widget.iconColor,
              size: widget.iconSize,
            ),
          );
        },
      ),
    );
  }
}

class _WeatherInfoItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _WeatherInfoItem({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white70,
          size: 20,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.7),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
