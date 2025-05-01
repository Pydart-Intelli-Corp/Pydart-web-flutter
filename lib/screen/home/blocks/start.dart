import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';

class HomeHead extends StatefulWidget {
  final ValueChanged<int>? onIndicatorTapped;
  final int currentIndex;
  final int totalItems;
  final VoidCallback onSwipeLeft;
  final VoidCallback onSwipeRight;
  final VoidCallback onExploreNowPressed;
  final String title;
  final String subtitle;

  const HomeHead({
    super.key,
    required this.onExploreNowPressed,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.totalItems,
    required this.onSwipeLeft,
    required this.onSwipeRight,
     this.onIndicatorTapped,
  });

  @override
  State<HomeHead> createState() => _HomeHeadState();
}

class _HomeHeadState extends State<HomeHead> {
  bool isMobile(BuildContext context) =>
      MediaQuery.of(context).size.width < 600;

  Widget _buildAnimatedTitle(String title) {
    final highlightWords = {
      'SOFTWARE',
      'HARDWARE',
      'MECHANICAL',
      'DESIGNS',
      'DIGITAL',
      'MARKETING',
      'CONSULTATION',
    };
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
            final upper = word.toUpperCase();
            final isHighlight = highlightWords.contains(upper) ||
                (upper == 'DIGITAL' &&
                    title.toUpperCase().contains('DIGITAL MARKETING')) ||
                (upper == 'MARKETING' &&
                    title.toUpperCase().contains('DIGITAL MARKETING'));

            return TextSpan(
              text: '$word ',
              style: TextStyle(
                fontSize: isMobile(context) ? 32 : 48,
                fontWeight: FontWeight.w900,
                color: isHighlight
                    ? AppColors.pydart
                    : const Color.fromARGB(255, 255, 255, 255),
                fontFamily: "Montserrat",
                shadows: const [
                  Shadow(color: Colors.black54, blurRadius: 10)
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

Widget _buildIndicator(int index) {
  return GestureDetector(
    onTap: () => widget.onIndicatorTapped?.call(index),
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: widget.currentIndex == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: widget.currentIndex == index
            ? AppColors.pydart
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    ),
  );
}

  Widget _buildServiceHeader(bool isMobile) {
    return Container(
      height: 400,
      child: Stack(
        children: [
          // Center content
          Center(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 20 : 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAnimatedTitle(widget.title),
                  const SizedBox(height: 20),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    transitionBuilder: (child, animation) =>
                        FadeTransition(opacity: animation, child: child),
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
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      widget.totalItems,
                      (index) => _buildIndicator(index),
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryGradientButton(
                    onPressed: widget.onExploreNowPressed,
                    text: "Explore Now →",
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                ],
              ),
            ),
          ),

          // Swipe hint at bottom
        
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity == null) return;
        if (details.primaryVelocity! < -20) {
          widget.onSwipeLeft();
        } else if (details.primaryVelocity! > 20) {
          widget.onSwipeRight();
        }
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(0),
          border: Border.all(color: AppColors.border),
        ),
        margin: blockMargin,
        padding: blockPadding(context),
        child: Column(
          children: [
            _buildServiceHeader(isMobile(context)),
          ],
        ),
      ),
    );
  }
}
