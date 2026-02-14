import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class RadarIndicator extends StatefulWidget {
  final double distance; // In meters

  const RadarIndicator({super.key, required this.distance});

  @override
  State<RadarIndicator> createState() => _RadarIndicatorState();
}

class _RadarIndicatorState extends State<RadarIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void didUpdateWidget(RadarIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Update animation speed based on distance
    // Closer = Faster
    double newDuration = max(0.2, min(2.0, widget.distance / 100));
    _controller.duration = Duration(milliseconds: (newDuration * 1000).toInt());
    if (!_controller.isAnimating) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Change color based on distance
    Color radarColor = widget.distance < 10
        ? AppTheme.primaryGreen
        : widget.distance < 50
            ? AppTheme.secondaryCyan
            : AppTheme.textMuted;

    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 150 * _controller.value,
              height: 150 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: radarColor.withOpacity(1 - _controller.value),
                  width: 2,
                ),
              ),
            );
          },
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: radarColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: radarColor.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
