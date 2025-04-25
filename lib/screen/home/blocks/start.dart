import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';

import 'package:flutter_website/widgets/buttons/gradient_button.dart';

class HomeHead extends StatefulWidget {
  final VoidCallback onExploreNowPressed;
  final String title;
  final String subtitle;

  const HomeHead({
    super.key,
    required this.onExploreNowPressed,
    required this.title,
    required this.subtitle,
  });

  @override
  State<HomeHead> createState() => _HomeHeadState();
}

class _HomeHeadState extends State<HomeHead> {
  bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;
Widget _buildAnimatedTitle(String title) {
  // Define the words you want to color
  final highlightWords = {
    'SOFTWARE',
    'HARDWARE',
    'MECHANICAL',
    'DESIGNS',
    'DIGITAL',
    'MARKETING',
    'CONSULTATION',
  };

  // Split on space so we can color individual tokens
  final words = title.split(' ');

  return AnimatedSwitcher(
    duration: const Duration(milliseconds: 800),
    transitionBuilder: (child, animation) =>
        FadeTransition(opacity: animation, child: child),
    child: RichText(
      key: ValueKey(title),
      textAlign: TextAlign.center,
      text: TextSpan(
        children: words.map((word) {
          // Check if this word (or its base) is in our set
          final upper = word.toUpperCase();
          final isHighlight = highlightWords.contains(upper) ||
            // handle two-word key like "DIGITAL MARKETING"
            (upper == 'DIGITAL' && title.toUpperCase().contains('DIGITAL MARKETING')) ||
            (upper == 'MARKETING' && title.toUpperCase().contains('DIGITAL MARKETING'));
          
          return TextSpan(
            text: '$word ',
            style: TextStyle(
              fontSize: isMobile(context) ? 32 : 48,
              fontWeight: FontWeight.w900,
              color: isHighlight
                  ? AppColors.pydart
                  : const Color.fromARGB(255, 255, 255, 255),
              fontFamily: "Montserrat",
              shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
            ),
          );
        }).toList(),
      ),
    ),
  );
}

  Widget _buildServiceHeader(bool isMobile) {
    return Container(
      height: 400,
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isMobile ? 20 : 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildAnimatedTitle(widget.title),
              const SizedBox(height: 20),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: child,
                ),
                child: Text(
                  key: ValueKey(widget.subtitle),
                  widget.subtitle,
                  style: headlineTextStyleMobile.copyWith(
                    color: Colors.white70,
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              PrimaryGradientButton(
                onPressed: widget.onExploreNowPressed,
                text: "Explore Now →",
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: border),
      ),
      margin: blockMargin,
      padding: blockPadding(context),
      child: _buildServiceHeader(isMobile(context)),
    );
  }
}