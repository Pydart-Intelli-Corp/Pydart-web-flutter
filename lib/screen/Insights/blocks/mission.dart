import 'package:flutter/material.dart';
import 'package:pydart/components/icons.dart';
import 'package:pydart/components/spacing.dart';
import 'package:pydart/components/colors.dart';
import 'package:pydart/core/extensions/color_extensions.dart';

class MissionBlock extends StatefulWidget {
  const MissionBlock({super.key});

  @override
  State<MissionBlock> createState() => _MissionBlockState();
}

class _MissionBlockState extends State<MissionBlock> {
  final List<Map<String, String>> missionValues = [
    {
      'icon': 'assets/icons/innovation.png',
      'title': 'Innovation',
      'description': 'We strive to push the boundaries of technology to create innovative solutions that solve real-world problems.',
    },
    {
      'icon': 'assets/icons/collaboration.png',
      'title': 'Collaboration',
      'description': 'We believe in the power of teamwork and collaboration to achieve extraordinary results.',
    },
    {
      'icon': 'assets/icons/integrity.png',
      'title': 'Integrity',
      'description': 'We are committed to maintaining the highest standards of integrity in everything we do.',
    },
    {
      'icon': 'assets/icons/customer_focus.png',
      'title': 'Customer Focus',
      'description': 'Our customers are at the heart of everything we do. We are dedicated to delivering exceptional value and service.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    
    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 40, bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 0,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            // Background with gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/others/mission.jpg'),
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
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),
            
            // Content container
            Container(
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      buildMaterialIconCircle("assets/icons/mission.png", 68),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Our Mission",
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
                              "To empower businesses and individuals through innovative technology solutions.",
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontSize: 16,
                                fontWeight: FontWeight.w500, // Medium
                                color: AppColors.whitegrey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Mission Values Grid
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: 24,
                        runSpacing: 24,
                        children: missionValues.map((value) {
                          return SizedBox(
                            width: 300,
                            height: 300,
                            child: _buildMissionValueCard(
                              icon: value['icon']!,
                              title: value['title']!,
                              description: value['description']!,
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMissionValueCard({required String icon, required String title, required String description}) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
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
              fontSize: 20,
              fontWeight: FontWeight.w600, // Semi-Bold
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 15,
              fontWeight: FontWeight.w400, // Regular
              color: Colors.white70,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
