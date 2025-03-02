import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather/models/weather_model.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ForecastSection extends StatelessWidget {
  final ForecastModel forecast;

  const ForecastSection({super.key, required this.forecast});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
          child: Text(
            '3-Day Forecast',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 150, // Fixed height to prevent overflow
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.daily.length,
            itemBuilder: (context, index) {
              final dailyForecast = forecast.daily[index];
              return ForecastCard(
                forecast: dailyForecast,
                index: index,
              );
            },
          ),
        ),
        SizedBox(height: 10), // Added spacing
      ],
    );
  }
}

class ForecastCard extends StatelessWidget {
  final DailyForecast forecast;
  final int index;

  const ForecastCard({
    super.key,
    required this.forecast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(left: index == 0 ? 0 : 8, right: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white.withOpacity(0.15),
      child: Container(
        height: 150, // Fixed height for each card
        width: 110, // Fixed width for each card
        padding: const EdgeInsets.all(12), // Reduced padding
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensure column takes minimum space
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly, // Distribute space evenly
          children: [
            Text(
              DateFormat('EEE').format(forecast.date),
              style: const TextStyle(
                fontSize: 16, // Slightly smaller font
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4), // Reduced spacing
            _buildWeatherIcon(forecast.iconCode)
                .animate()
                .fade(duration: 300.ms)
                .scaleXY(
                    begin: 0.8,
                    end: 1,
                    duration: 500.ms,
                    curve: Curves.elasticOut),
            const SizedBox(height: 4), // Reduced spacing
            Text(
              forecast.description,
              style: TextStyle(
                fontSize: 11,
                color: Colors.white.withOpacity(0.9),
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Handle overflow text
            ),
            const SizedBox(height: 4), // Reduced spacing
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${forecast.minTemp.round()}°',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${forecast.maxTemp.round()}°',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherIcon(String iconCode) {
    final bool isNight = iconCode.contains('n');
    IconData iconData;
    Color iconColor;

    if (isNight) {
      iconColor = Colors.grey.shade300;

      if (iconCode.contains('01')) {
        iconData = Icons.nightlight_round;
      } else if (iconCode.contains('02') ||
          iconCode.contains('03') ||
          iconCode.contains('04')) {
        iconData = Icons.nights_stay;
      } else if (iconCode.contains('09') || iconCode.contains('10')) {
        iconData = Icons.grain;
      } else if (iconCode.contains('11')) {
        iconData = Icons.flash_on;
      } else if (iconCode.contains('13')) {
        iconData = Icons.ac_unit;
      } else {
        iconData = Icons.cloud;
      }
    } else {
      iconColor = Colors.amber;

      if (iconCode.contains('01')) {
        iconData = Icons.wb_sunny;
      } else if (iconCode.contains('02') ||
          iconCode.contains('03') ||
          iconCode.contains('04')) {
        iconData = Icons.cloud;
      } else if (iconCode.contains('09') || iconCode.contains('10')) {
        iconData = Icons.grain;
      } else if (iconCode.contains('11')) {
        iconData = Icons.flash_on;
      } else if (iconCode.contains('13')) {
        iconData = Icons.ac_unit;
      } else {
        iconData = Icons.cloud;
      }
    }

    return Container(
      width: 40, // Smaller icon container
      height: 40, // Smaller icon container
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 24, // Smaller icon
      ),
    );
  }
}
