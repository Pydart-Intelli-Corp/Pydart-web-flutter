import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';

import 'package:flutter_website/widgets/buttons/gradient_button.dart';

class HomeHead extends StatefulWidget {
  // Add a callback function for when the "Explore Now" button is clicked
final VoidCallback onExploreNowPressed;

  const HomeHead({
    super.key, 
  required this.onExploreNowPressed
  });

  @override
  State<HomeHead> createState() => _HomeHeadState();
}

class _HomeHeadState extends State<HomeHead> {
  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
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
              Text(
                "WELCOME TO PYDART\nINTELLI CORP",
                style: TextStyle(
                  fontSize: isMobile ? 32 : 48,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  fontFamily: "Montserrat",
                  shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                "Innovate. Integrate. Inspire.",
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
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: border),
      ),
      margin: blockMargin,
      padding: blockPadding(context),
      child: _buildServiceHeader(isMobile(context)),
    );
  }
}