import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';

import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart'
    show AppColors;
import 'package:flutter_website/widgets/buttons/gradient_button.dart';

class Service {
  final IconData icon;
  final String title;
  final String description;

  Service({required this.icon, required this.title, required this.description});
}

class WhatWeDoBlock extends StatelessWidget {
  WhatWeDoBlock({super.key});

  final List<Service> services = [
    Service(
      icon: Icons.developer_mode,
      title: "Custom Software Development",
      description:
          "Tailored solutions aligning with your unique business requirements",
    ),
    Service(
      icon: Icons.apps,
      title: "Mobile & Web Platforms",
      description:
          "Cross-platform applications with focus on UX and performance",
    ),
    Service(
      icon: Icons.cloud,
      title: "Cloud Infrastructure",
      description: "Scalable cloud solutions and seamless system integrations",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 80, bottom: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color.fromARGB(195, 0, 0, 0).withOpacity(1),
            const Color.fromARGB(193, 0, 0, 0)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.1, 0.9],
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 24 : 120,
            vertical: isMobile ? 60 : 100,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1400),
            child: isMobile
                ? _buildMobileLayout(context)
                : _buildDesktopLayout(context),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader(context, false),
              const SizedBox(height: 40),
              _buildCTASection(context),
            ],
          ),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 3,
          child: _buildContentCard(context, false),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(context, true),
        const SizedBox(height: 32),
        _buildContentCard(context, true),
        const SizedBox(height: 32),
        _buildCTASection(context),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildMaterialIconCircle(
              // This icon image is preloaded (from the asset pre-caching in main).
              "assets/icons/professional.png",
              isMobile ? 56 : 72,
            ),
            SizedBox(width: isMobile ? 16 : 24),
            Text(
              "What we do ?",
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
        // New sentence added under the heading
        const SizedBox(height: 12),
        Text(
          "We offer a diverse range of innovative services designed to elevate your business.",
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white.withOpacity(0.8),
            fontSize: isMobile ? 16 : 20,
            height: 1.4,
          ),
        ),
      ],
    );
  }

  Widget _buildContentCard(BuildContext context, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: const Color.fromARGB(20, 31, 31, 31),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(68, 0, 0, 0),
            blurRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              children: buildServiceChildren(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> buildServiceChildren() {
    List<Widget> children = [];
    for (int i = 0; i < services.length; i++) {
      children.add(_buildServiceItem(services[i]));
      if (i < services.length - 1) {
        children.add(_buildDivider());
      }
    }
    return children;
  }

  Widget _buildServiceItem(Service service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.deepSpace.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              service.icon,
              color: AppColors.pydart,
              size: 24,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.title,
                  style: const TextStyle(
                    fontFamily: "Montserrat",
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service.description,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      color: Colors.white.withOpacity(0.1),
    );
  }

  Widget _buildCTASection(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return PrimaryGradientButton(
      onPressed: () {},
      text: "Discover Our Services →",
      padding: isMobile
          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
          : const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );
  }
}
