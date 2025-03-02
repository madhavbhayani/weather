import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SunPathChart extends StatefulWidget {
  final int sunrise;
  final int sunset;
  final int currentTime;

  const SunPathChart({
    super.key,
    required this.sunrise,
    required this.sunset,
    required this.currentTime,
  });

  @override
  State<SunPathChart> createState() => _SunPathChartState();
}

class _SunPathChartState extends State<SunPathChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: calculateSunPosition(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double calculateSunPosition() {
    final sunriseTime =
        DateTime.fromMillisecondsSinceEpoch(widget.sunrise * 1000);
    final sunsetTime =
        DateTime.fromMillisecondsSinceEpoch(widget.sunset * 1000);
    final currentTime =
        DateTime.fromMillisecondsSinceEpoch(widget.currentTime * 1000);

    // If before sunrise or after sunset, return appropriate position
    if (currentTime.isBefore(sunriseTime)) return 0.0;
    if (currentTime.isAfter(sunsetTime)) return 1.0;

    // Calculate position between sunrise and sunset
    final totalDuration = sunsetTime.difference(sunriseTime).inSeconds;
    if (totalDuration <= 0) return 0.5; // Safeguard against invalid data

    final elapsedDuration = currentTime.difference(sunriseTime).inSeconds;

    // Ensure the result is between 0 and 1
    return (elapsedDuration / totalDuration).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Sun Path',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
              height: 80, // Reduced height to prevent overflow
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: _SunPathPainter(
                      sunPosition: _animation.value,
                      isNight: calculateSunPosition() >= 1.0 ||
                          calculateSunPosition() <= 0.0,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 55),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TimeDisplay(
                  icon: Icons.wb_sunny_outlined,
                  label: 'Sunrise',
                  time: DateTime.fromMillisecondsSinceEpoch(
                      widget.sunrise * 1000),
                ),
                _TimeDisplay(
                  icon: Icons.nights_stay_outlined,
                  label: 'Sunset',
                  time:
                      DateTime.fromMillisecondsSinceEpoch(widget.sunset * 1000),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SunPathPainter extends CustomPainter {
  final double sunPosition;
  final bool isNight;

  _SunPathPainter({required this.sunPosition, required this.isNight});

  @override
  void paint(Canvas canvas, Size size) {
    // Fixed height for the arc
    final arcHeight = size.height * 0.9;

    final Paint arcPaint = Paint()
      ..color = Colors.white.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final Paint progressPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint sunPaint = Paint()
      ..color = isNight ? Colors.grey : Colors.yellow
      ..style = PaintingStyle.fill;

    // Create a smaller rectangle to ensure the arc fits within the canvas
    final Rect arcRect = Rect.fromCenter(
      center: Offset(size.width / 2, size.height + arcHeight / 2),
      width: size.width * 0.9,
      height: arcHeight * 2,
    );

    // Draw the full arc (180 degrees from left to right)
    canvas.drawArc(
      arcRect,
      pi,
      pi,
      false,
      arcPaint,
    );

    // Draw the progress arc
    canvas.drawArc(
      arcRect,
      pi,
      pi * sunPosition,
      false,
      progressPaint,
    );

    // Calculate sun position on arc
    final double angle = pi + pi * sunPosition;
    final double sunRadius = 8; // Smaller sun to fit better
    final double sunX = arcRect.center.dx + arcRect.width / 2 * cos(angle);
    final double sunY = arcRect.center.dy + arcRect.height / 2 * sin(angle);

    // Ensure the sun stays within the visible area
    if (sunY < size.height - sunRadius) {
      // Draw sun
      canvas.drawCircle(Offset(sunX, sunY), sunRadius, sunPaint);

      // Add a subtle glow to the sun
      final Paint glowPaint = Paint()
        ..color = isNight
            ? Colors.grey.withOpacity(0.3)
            : Colors.yellow.withOpacity(0.3)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(sunX, sunY), sunRadius + 4, glowPaint);
    }

    // Draw horizon line
    final Paint horizonPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(0, size.height * 0.9),
      Offset(size.width, size.height * 0.9),
      horizonPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _SunPathPainter oldDelegate) {
    return oldDelegate.sunPosition != sunPosition ||
        oldDelegate.isNight != isNight;
  }
}

class _TimeDisplay extends StatelessWidget {
  final IconData icon;
  final String label;
  final DateTime time;

  const _TimeDisplay({
    required this.icon,
    required this.label,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            Text(
              DateFormat('h:mm a').format(time),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
