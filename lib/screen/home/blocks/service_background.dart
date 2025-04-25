import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';

class ServicesBlock extends StatefulWidget {
  const ServicesBlock({super.key});

  @override
  State<ServicesBlock> createState() => _ServicesBlockState();
}

class _ServicesBlockState extends State<ServicesBlock> {
  final List<Service> services = [
    Service(
      title: "Web & Cloud Solutions",
      icon: Icons.cloud,
      color: AppColors.pydart,
      subtitle: "Build fast, secure, and search-friendly applications",
      features: [
        "Next.js/React/Angular/Flutter/.NET Core",
        "AI Integration (TensorFlow.js, Hugging Face)",
        "SEO-optimized SSR Experiences",
        "Progressive Web Apps (PWA)",
        "DevOps & Containerization (Docker/K8s)",
        "OWASP-hardened Security"
      ],
    ),
    Service(
      title: "Mobile & Embedded Apps",
      icon: Icons.phone_iphone,
      color: Colors.blueAccent,
      subtitle: "High-performance cross-platform experiences",
      features: [
        "Flutter & React Native",
        "Native iOS/Android Development",
        "AR/VR & IoT Integrations",
        "Wearable Tech Support",
        "App Store Deployment",
        "Automated Testing"
      ],
    ),
    Service(
      title: "Hardware & Automation",
      icon: Icons.settings,
      color: Colors.greenAccent,
      subtitle: "Embedded intelligence solutions",
      features: [
        "Custom PCB Design",
        "Firmware Development",
        "Industrial CAD & Robotics",
        "Qt/PyQt GUIs",
        "OTA Firmware Updates",
        "Diagnostic Tools"
      ],
    ),
    Service(
      title: "Digital Marketing",
      icon: Icons.campaign,
      color: Colors.orangeAccent,
      subtitle: "Brand elevation & audience growth",
      features: [
        "SEO & Content Strategy",
        "Social Media Management",
        "PPC & Programmatic Ads",
        "Video Production",
        "Motion Graphics",
        "Analytics & A/B Testing"
      ],
    ),
  ];

  int? hoveredIndex;
  int? expandedIndex;

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "https://images.unsplash.com/photo-1451187580459-43490279c0fa?auto=format&fit=crop&q=80&w=2944&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              const Color.fromARGB(255, 11, 11, 11).withOpacity(0.86), BlendMode.darken),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 80, horizontal: isMobile ? 20 : 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Full-Spectrum Digital Solutions",
                  style: TextStyle(
                    fontSize: isMobile ? 32 : 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontFamily: "Montserrat",
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  "From concept to deployment - we deliver end-to-end technology solutions",
                  style: TextStyle(
                    fontSize: isMobile ? 18 : 22,
                    color: AppColors.textPrimary,
                    fontFamily: "Montserrat",
                  ),
                ),
                const SizedBox(height: 60),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 1 : 2,
                    crossAxisSpacing: 30,
                    mainAxisSpacing: 30,
                    childAspectRatio: 1.1,
                  ),
                  itemCount: services.length,
                  itemBuilder: (context, index) => _ServiceCard(
                    service: services[index],
                    isExpanded: expandedIndex == index,
                    isHovered: hoveredIndex == index,
                    onTap: () => setState(() => expandedIndex = expandedIndex == index ? null : index),
                    onHover: (value) => setState(() => hoveredIndex = value ? index : null),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServiceCard extends StatefulWidget {
  final Service service;
  final bool isExpanded;
  final bool isHovered;
  final Function() onTap;
  final Function(bool) onHover;

  const _ServiceCard({
    required this.service,
    required this.isExpanded,
    required this.isHovered,
    required this.onTap,
    required this.onHover,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> {
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => widget.onHover(true),
      onExit: (_) => widget.onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          transform: Matrix4.identity()..scale(widget.isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(widget.isExpanded ? 0.95 : 0.7),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.service.color.withOpacity(widget.isHovered ? 0.6 : 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: widget.service.color.withOpacity(widget.isHovered ? 0.2 : 0.1),
                blurRadius: 20,
                spreadRadius: 2,
              )
            ],
          ),
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: widget.service.color.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(widget.service.icon, 
                          color: widget.service.color, size: 28),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        widget.service.title,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  widget.service.subtitle,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontFamily: "Montserrat",
                    height: 1.4,
                  ),
                ),
                if (widget.isExpanded) ...[
                  const SizedBox(height: 25),
                  ...widget.service.features.map((feature) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.arrow_forward, 
                            color: widget.service.color, size: 16),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            feature,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 15,
                              fontFamily: "Montserrat",
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
                const SizedBox(height: 15),
                AnimatedOpacity(
                  opacity: widget.isExpanded ? 0 : 1,
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    "Tap to expand →",
                    style: TextStyle(
                      color: widget.service.color,
                      fontSize: 14,
                      fontFamily: "Montserrat",
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final IconData icon;
  final Color color;
  final String subtitle;
  final List<String> features;

  Service({
    required this.title,
    required this.icon,
    required this.color,
    required this.subtitle,
    required this.features,
  });
}

