import 'package:flutter/material.dart';

/// A simple widget that shows three dots pulsing sequentially.
class LoadingDots extends StatefulWidget {
  final Color color;
  final double dotSize;
  final double dotSpacing;
  final Duration duration;

  const LoadingDots({
    Key? key,
    this.color = Colors.blue,
    this.dotSize = 10.0,
    this.dotSpacing = 6.0,
    this.duration = const Duration(milliseconds: 1000),
  }) : super(key: key);

  @override
  _LoadingDotsState createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  Widget _buildDot(int index) {
    // Each dot starts its animation with a slight delay.
    double delay = index * 0.2;
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        double progress = (_controller.value + delay) % 1.0;
        // Pulse effect: scale goes from 0.5 -> 1.0 -> 0.5.
        double scale = 0.5 + 0.5 * (1 - (progress - 0.5).abs() * 2);
        return Container(
          margin: EdgeInsets.symmetric(horizontal: widget.dotSpacing),
          width: widget.dotSize * scale,
          height: widget.dotSize * scale,
          decoration: BoxDecoration(
            color: widget.color,
            shape: BoxShape.circle,
          ),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, _buildDot),
    );
  }
}
