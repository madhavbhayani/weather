import 'package:flutter/material.dart';

class TimeBasedGradient {
  static LinearGradient getGradient() {
    final hour = DateTime.now().hour;

    // Early morning (5-8)
    if (hour >= 5 && hour < 8) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF7F7FD5),
          Color(0xFF86A8E7),
          Color(0xFF91EAE4),
        ],
      );
    }

    // Morning (8-11)
    if (hour >= 8 && hour < 11) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF2193b0),
          Color(0xFF6dd5ed),
        ],
      );
    }

    // Midday (11-16)
    if (hour >= 11 && hour < 16) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF00B4DB),
          Color(0xFF0083B0),
        ],
      );
    }

    // Afternoon (16-19)
    if (hour >= 16 && hour < 19) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFFFF8008),
          Color(0xFFFFC837),
        ],
      );
    }

    // Evening (19-22)
    if (hour >= 19 && hour < 22) {
      return const LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Color(0xFF3A1C71),
          Color(0xFFD76D77),
          Color(0xFFFFAF7B),
        ],
      );
    }

    // Night (22-5)
    return const LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        Color(0xFF0F2027),
        Color(0xFF203A43),
        Color(0xFF2C5364),
      ],
    );
  }

  static LinearGradient getGradientForWeather(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF56CCF2),
            Color(0xFF2F80ED),
          ],
        );
      case 'clouds':
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF757F9A),
            Color(0xFFD7DDE8),
          ],
        );
      case 'rain':
      case 'drizzle':
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF3A6073),
            Color(0xFF16222A),
          ],
        );
      case 'thunderstorm':
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF4B134F),
            Color(0xFF160E2C),
          ],
        );
      case 'snow':
        return const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFFE6DADA),
            Color(0xFF274046),
          ],
        );
      default:
        return getGradient(); // Default to time-based gradient
    }
  }
}
