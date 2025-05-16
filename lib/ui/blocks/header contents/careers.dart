import 'package:flutter/material.dart';
import 'package:pydart/ui/blocks/header%20contents/hoverdropdown.dart';

import '../../../widgets/buttons/text_hover_button.dart';

class CareersContent extends StatefulWidget {
  final VoidCallback onItemPressed;
  final Function(String) openUrl;

  const CareersContent({
    Key? key,
    required this.onItemPressed,
    required this.openUrl,
  }) : super(key: key);

  @override
  State<CareersContent> createState() => _CareersContentState();
}

class _CareersContentState extends State<CareersContent> {
  int _hoveredIndex = 0; // Start with the first item selected

  final List<CareerItem> _careerItems = [
    CareerItem(
      title: "Open Positions",
      subtitle: "Join Our Team",
      description:
          "Explore current job openings at Pydart Intelli Corp. We are constantly seeking talented professionals "
          "to help drive innovation and growth. Discover opportunities that match your skills and ambitions.",
      buttonLink: "https://www.pydartintelli.com/careers/open-positions",
    ),
    CareerItem(
      title: "Internship Programs",
      subtitle: "Kickstart Your Career",
      description:
          "Our internship programs offer hands-on experience in a dynamic environment, "
          "providing students and recent graduates with a pathway to kickstart their careers. "
          "Learn about our mentorship and development opportunities.",
      buttonLink: "https://www.pydartintelli.com/careers/internships",
    ),
    CareerItem(
      title: "Employee Culture",
      subtitle: "Life at Pydart",
      description:
          "At Pydart Intelli Corp, we foster a collaborative and inclusive work environment that values creativity, "
          "diversity, and professional growth. Discover our culture, employee benefits, and why our team loves working here.",
      buttonLink: "https://www.pydartintelli.com/careers/employee-culture",
    ),
  ];

  Widget _buildDivider(int dividerIndex) {
    final isHidden =
        _hoveredIndex == dividerIndex || _hoveredIndex == dividerIndex + 1;
    return Visibility(
      visible: !isHidden,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(color: Color(0xFF2D3847), height: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
      final Color navLinkColor = Colors.white;
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 1270, // Provides ample width for the layout
        decoration: BoxDecoration(
          color: const Color(0xFF1A2330),
          borderRadius: BorderRadius.circular(0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: Navigation menu for career topics
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HoverDropdownItem(
                    title: "Open Positions",
                    subtitle: "Join Our Team",
                    isActive: _hoveredIndex == 0,
                    onTap: () => widget.openUrl(_careerItems[0].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 0 : _hoveredIndex),
                  ),
                  _buildDivider(0),
                  HoverDropdownItem(
                    title: "Internship Programs",
                    subtitle: "Kickstart Your Career",
                    isActive: _hoveredIndex == 1,
                    onTap: () => widget.openUrl(_careerItems[1].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 1 : _hoveredIndex),
                  ),
                  _buildDivider(1),
                  HoverDropdownItem(
                    title: "Employee Culture",
                    subtitle: "Life at Pydart",
                    isActive: _hoveredIndex == 2,
                    onTap: () => widget.openUrl(_careerItems[2].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 2 : _hoveredIndex),
                  ),
                ],
              ),
            ),
            // Vertical divider between navigation and content display
            const VerticalDivider(
              color: Color(0xFF2D3847),
              width: 1,
              indent: 8,
              endIndent: 8,
            ),
            // Right side: Display detailed content for the selected career topic
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _careerItems[_hoveredIndex].title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Roboto',
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _careerItems[_hoveredIndex].subtitle,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _careerItems[_hoveredIndex].description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.5,
                        fontFamily: 'Roboto',
                      ),
                    ),
                    const SizedBox(height: 24),
                     MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: InkWell(
                          onTap: () {
                           
                          },
                          hoverColor: Colors.transparent,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(9, 82, 168, 255),
                              borderRadius: BorderRadius.circular(6),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: TextHoverButton(
                              label: "Learn More",
                              color: navLinkColor,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ),
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

class CareerItem {
  final String title;
  final String subtitle;
  final String description;
  final String buttonLink;

  CareerItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLink,
  });
}
