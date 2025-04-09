import 'package:flutter/material.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/animations/loading_dots.dart';
// Ensure the LoadingDots widget is imported or defined in your project.

class PrimaryGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;
  final bool isLoading;
  final EdgeInsetsGeometry? padding;
  final Gradient? gradient;

  const PrimaryGradientButton({
    Key? key,
    required this.onPressed,
    this.text = " →",
    this.isLoading = false,
    this.padding,
    this.gradient,   icon,
  }) : super(key: key);

  @override
  _PrimaryGradientButtonState createState() => _PrimaryGradientButtonState();
}

class _PrimaryGradientButtonState extends State<PrimaryGradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Define the text style used in the button.
    final textStyle = buttonTextStyle.copyWith(
      fontSize: 13,
      fontWeight: FontWeight.w600,
    );
    // Measure the width of the text.
    final textPainter = TextPainter(
      text: TextSpan(text: widget.text, style: textStyle),
      textDirection: TextDirection.ltr,
    )..layout();

    final textWidth = textPainter.width;

    // Shadow offsets for normal and hovered states.
    final normalShadowOffset = const Offset(0, 8);
    final hoveredShadowOffset = const Offset(0, 2);

    // Scaling and translation values.
    final double scaleFactor = _isHovered ? 1.05 : 1.0;
    final double translationY = _isHovered ? -5.0 : 0.0;
    final Matrix4 transform = Matrix4.identity()
      ..scale(scaleFactor)
      ..translate(0.0, translationY / scaleFactor);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        decoration: BoxDecoration(
          gradient: widget.gradient ??
              const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
              ),
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withOpacity(0.3),
              blurRadius: 0,
              offset: _isHovered ? hoveredShadowOffset : normalShadowOffset,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.isLoading ? null : widget.onPressed,
            borderRadius: BorderRadius.circular(0),
            splashColor: Colors.white.withOpacity(0.3),
           child: Padding(
  padding: widget.padding ??
      const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
  child: Stack(
    alignment: Alignment.center,
    children: [
      // The text widget is always part of the layout, so the width is based on its content.
      // When loading, we set its opacity to 0, keeping its size but hiding it.
      Opacity(
        opacity: widget.isLoading ? 0.0 : 1.0,
        child: Text(
          widget.text,
          style: buttonTextStyle.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // The loading indicator is wrapped in Positioned.fill so it doesn't affect the intrinsic width.
      if (widget.isLoading)
        Positioned.fill(
          child: Center(
            child: LoadingDots(
              color: Colors.white,
              dotSize: 4.0,
              dotSpacing: 3.0,
              duration: const Duration(milliseconds: 800),
            ),
          ),
        ),
    ],
  ),
),

          ),
        ),
      ),
    );
  }
}

class SecondaryGradientButton extends StatefulWidget {
  final VoidCallback onPressed;
  final String text;

  const SecondaryGradientButton({
    Key? key,
    required this.onPressed,
    this.text = " →",
  }) : super(key: key);

  @override
  _SecondaryGradientButtonState createState() => _SecondaryGradientButtonState();
}

class _SecondaryGradientButtonState extends State<SecondaryGradientButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(0);
    // Shadow offsets for normal and hovered states.
    final normalShadowOffset = const Offset(0, 8);
    final hoveredShadowOffset = const Offset(0, 2);

    // Scaling and translation values.
    final double scaleFactor = _isHovered ? 1.05 : 1.0;
    final double translationY = _isHovered ? -5.0 : 0.0;
    // Combine scaling and translation.
    // We apply the scale first and then adjust the translation so that
    // the final (displayed) translation equals translationY.
    final Matrix4 transform = Matrix4.identity()
      ..scale(scaleFactor)
      ..translate(0.0, translationY / scaleFactor);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: transform,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [const Color.fromARGB(20, 210, 210, 210), const Color.fromARGB(20, 210, 210, 210)],
          ),
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(0, 63, 49, 49).withOpacity(0.1),
              blurRadius: 0,
              offset: _isHovered ? hoveredShadowOffset : normalShadowOffset,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: borderRadius,
            splashColor: Colors.white.withOpacity(0.3),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                widget.text,
                style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                         
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color:const Color.fromARGB(48, 0, 179, 170),
                                blurRadius: 10,
                              )
                            ],
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
