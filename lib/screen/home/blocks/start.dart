import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';

/// Data model for header slides
class HeaderSlide {
  final String title;
  final String subtitle;

  HeaderSlide({required this.title, required this.subtitle});
}

class HomeHead extends StatefulWidget {
  /// Callback when "Explore Now" is pressed
  final VoidCallback onExploreNowPressed;

  const HomeHead({Key? key, required this.onExploreNowPressed}) : super(key: key);

  @override
  State<HomeHead> createState() => _HomeHeadState();
}

class _HomeHeadState extends State<HomeHead> {
  late final List<HeaderSlide> _slides;
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _slides = [
      HeaderSlide(
        title: 'WELCOME TO PYDART INTELLI CORP',
        subtitle: 'Your gateway to innovation',
      ),
      HeaderSlide(
        title: 'WE DO SOFTWARES',
        subtitle: 'Custom software solutions',
      ),
      HeaderSlide(
        title: 'WE DO HARDWARES',
        subtitle: 'Robust hardware designs',
      ),
      HeaderSlide(
        title: 'WE DO CREATIVE DESIGNS',
        subtitle: 'Designs that inspire',
      ),
      HeaderSlide(
        title: 'WE DO DIGITAL MARKETING',
        subtitle: 'Grow your audience',
      ),
      HeaderSlide(
        title: 'BUILD YOUR BUSINESS WITH US',
        subtitle: 'Let’s scale together',
      ),
    ];
    // Cycle slides every 4 seconds
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      setState(() => _currentIndex = (_currentIndex + 1) % _slides.length);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  bool _isMobile(BuildContext context) => MediaQuery.of(context).size.width < 600;

  @override
  Widget build(BuildContext context) {
    final slide = _slides[_currentIndex];
    final isMobile = _isMobile(context);

    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/home_bg.jpg'),
          fit: BoxFit.cover,
        ),
        border: Border.all(color: border),
      ),
      margin: blockMargin,
      padding: blockPadding(context),
      child: Stack(
        children: [
          // Dark overlay for readability
          Container(color: Colors.black.withOpacity(0.4)),
          Center(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 800),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _buildSlide(slide, isMobile),
                layoutBuilder: (currentChild, previousChildren) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      ...previousChildren,
                      if (currentChild != null) currentChild,
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(HeaderSlide slide, bool isMobile) {
    // For AnimatedSwitcher, use a ValueKey to distinguish slides
    return Column(
      key: ValueKey<int>(_currentIndex),
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildStyledTitle(slide.title, isMobile),
        const SizedBox(height: 20),
        Text(
          slide.subtitle,
          style: headlineTextStyleMobile.copyWith(
            color: Colors.white70,
            fontSize: isMobile ? 18 : 24,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 40),
        PrimaryGradientButton(
          onPressed: widget.onExploreNowPressed,
          text: 'Explore Now →',
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
      ],
    );
  }

  Widget _buildStyledTitle(String text, bool isMobile) {
    // Split "WE DO" prefix if present
    const prefix = 'WE DO ';
    if (text.startsWith(prefix)) {
      final rest = text.substring(prefix.length);
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: prefix,
              style: TextStyle(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                fontFamily: 'Montserrat',
                shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
              ),
            ),
            TextSpan(
              text: rest,
              style: TextStyle(
                fontSize: isMobile ? 32 : 48,
                fontWeight: FontWeight.w900,
                color: AppColors.pydart,
                fontFamily: 'Montserrat',
                shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
              ),
            ),
          ],
        ),
      );
    }

    // Default full-white title
    return Text(
      text,
      style: TextStyle(
        fontSize: isMobile ? 32 : 48,
        fontWeight: FontWeight.w900,
        color: Colors.white,
        fontFamily: 'Montserrat',
        shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
      ),
      textAlign: TextAlign.center,
    );
  }
}
