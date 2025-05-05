import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';

class VisionBlock extends StatefulWidget {
  const VisionBlock({Key? key}) : super(key: key);

  @override
  State<VisionBlock> createState() => _VisionBlockState();
}

class _VisionBlockState extends State<VisionBlock> {
  final List<Map<String, String>> visionValues = [
    {
      'icon': 'assets/icons/future.png',
      'title': 'Foresight',
      'description': 'We envision a future where technology empowers every individual to achieve more.',
    },
    {
      'icon': 'assets/icons/creativity.png',
      'title': 'Creativity',
      'description': 'Our vision is to drive creativity that redefines possibilities and transforms lives.',
    },
    {
      'icon': 'assets/icons/quality.png',
      'title': 'Excellence',
      'description': 'We are committed to excellence in every aspect of our work, ensuring quality and precision.',
    },
    {
      'icon': 'assets/icons/inspiration.png',
      'title': 'Inspiration',
      'description': 'Our vision is to inspire creativity and push boundaries to shape a better tomorrow.',
    },
  ];

  @override
  Widget build(BuildContext context) {
        final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 40, bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 8),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/others/vision.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.85),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withOpacity(0.15),
                      AppColors.secondary.withOpacity(0.15),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: blockPadding(context).copyWith(top: 50, bottom: 50),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildMaterialIconCircle("assets/icons/vision.png", 70),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Our Vision",
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
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Inspiring innovation and excellence for a brighter future.",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontSize: 16,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: visionValues.map((value) {
                            return SizedBox(
                              width: 300,
                              height: 300,
                              child: _buildVisionValueCard(
                                icon: value['icon']!,
                                title: value['title']!,
                                description: value['description']!,
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVisionValueCard({
    required String icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(icon, width: 32, height: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Text(
              description,
              textAlign: TextAlign.start,
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 15,
                color: AppColors.whitegrey,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}