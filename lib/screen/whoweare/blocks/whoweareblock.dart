import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';

class IntroBlock extends StatefulWidget {
  const IntroBlock({super.key});

  @override
  State<IntroBlock> createState() => _IntroBlockState();
}

class _IntroBlockState extends State<IntroBlock> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 40, bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
              color: AppColors.pydart.withOpacity(0.2),
              blurRadius: 32,
              spreadRadius: -12,
              offset: const Offset(0, 24)),
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 16,
            spreadRadius: -8,
            offset: const Offset(0, 16),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            // The background uses a preloaded image (ensure this image is pre-cached in main)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    // This AssetImage will be loaded from cache if it was pre-cached earlier.
                    image:
                        const AssetImage('assets/images/others/whoweare.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.pydart.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            // Content container
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: isMobile ? 40 : 60,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1200),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Section with an icon that is also preloaded.
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildMaterialIconCircle(
                          // This icon image is preloaded (from the asset pre-caching in main).
                          "assets/icons/whoweare.png",
                          isMobile ? 56 : 72,
                        ),
                        SizedBox(width: isMobile ? 16 : 24),
                        Text(
                          "Who we are ?",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: isMobile ? 28 : 40,
                            fontWeight: FontWeight.w600,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                blurRadius: 10,
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: isMobile ? 32 : 48),
                    // Content Card
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 26, 26, 26)
                            .withOpacity(0.4),
                        borderRadius: BorderRadius.circular(0),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.1),
                          width: 1,
                        ),
                      ),
                      child: RichText(
                        textAlign: TextAlign.justify,
                        text: TextSpan(
                          style: bodyTextStyle.copyWith(
                            fontFamily: "Montserrat",
                            color: Colors.white.withOpacity(0.95),
                            fontSize: isMobile ? 16 : 18,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                          children: const [
                            TextSpan(text: "At "),
                            TextSpan(
                              text: "Pydart Intelli Corp",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: AppColors.pydart,
                              ),
                            ),
                            TextSpan(
                              text:
                                  ", we create transformative digital solutions that redefine business potential. Harnessing ",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                            TextSpan(
                              text: "AI-driven innovation",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: AppColors.pydart,
                              ),
                            ),
                            TextSpan(
                                text:
                                    " and cutting-edge technologies, we engineer scalable platforms that deliver unparalleled user experiences. Our "),
                            TextSpan(
                              text: "commitment to excellence",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: AppColors.pydart,
                              ),
                            ),
                            TextSpan(
                                text:
                                    " drives us to transcend conventional boundaries, ensuring each solution not only meets but anticipates future challenges. Through "),
                            TextSpan(
                              text: "strategic innovation",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.w700,
                                color: AppColors.pydart,
                              ),
                            ),
                            TextSpan(
                                text:
                                    " and relentless pursuit of quality, we're shaping a connected ecosystem where visionary ideas become transformative realities."),
                          ],
                        ),
                      ),
                    ),
                    // CTA Button (shown on larger screens)
                    if (!isMobile) ...[
                      const SizedBox(height: 32),
                      PrimaryGradientButton(
                        onPressed: () {},
                        text: "Explore Our Vision →",
                        padding: isMobile
                            ? const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14)
                            : const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
