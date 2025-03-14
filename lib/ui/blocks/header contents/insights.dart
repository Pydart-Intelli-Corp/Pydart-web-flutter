import 'package:flutter/material.dart';
import 'package:flutter_website/ui/blocks/header%20contents/hoverdropdown.dart';
import 'package:flutter_website/widgets/buttons/text_hover_button.dart';

class Insights extends StatefulWidget {
  final VoidCallback onItemPressed;
  final Function(String) openUrl;

  const Insights({
    Key? key,
    required this.onItemPressed,
    required this.openUrl,
  }) : super(key: key);

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  int _hoveredIndex = 0; // Start with the first item selected

  final List<InsightsItem> _Insights = [
    InsightsItem(
      title: "Industry Trends",
      subtitle: "Emerging market dynamics",
      description:
          "Stay ahead of the curve with our analysis of the latest market trends and emerging technologies. Our insights help you make informed decisions in a rapidly evolving landscape.",
      buttonLink: 'https://www.pydartintelli.com/industry-trends',
    ),
    InsightsItem(
      title: "Expert Analysis",
      subtitle: "In-depth industry insights",
      description:
          "Our team of experts provides comprehensive analysis of current events and breakthrough technologies. Gain valuable insights into industry shifts and strategic opportunities.",
      buttonLink: 'https://www.pydartintelli.com/expert-analysis',
    ),
    InsightsItem(
      title: "Case Studies",
      subtitle: "Real-world impact",
      description:
          "Explore detailed case studies showcasing how innovative solutions drive business success. Learn from real-world examples of transformative technology applications.",
      buttonLink: 'https://www.pydartintelli.com/case-studies',
    ),
  ];
  
  final Color navLinkColor = Colors.white;
  
  Widget _buildDivider(int dividerIndex) {
    final isHidden = _hoveredIndex == dividerIndex || _hoveredIndex == dividerIndex + 1;
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
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 1270, // Increased width for ample content display
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
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: menu items for each insight category
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HoverDropdownItem(
                    title: "Industry Trends",
                    subtitle: "Emerging market dynamics",
                    isActive: _hoveredIndex == 0,
                    onTap: () => widget.openUrl(_Insights[0].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 0 : _hoveredIndex),
                  ),
                  _buildDivider(0),
                  HoverDropdownItem(
                    title: "Expert Analysis",
                    subtitle: "In-depth industry insights",
                    isActive: _hoveredIndex == 1,
                    onTap: () => widget.openUrl(_Insights[1].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 1 : _hoveredIndex),
                  ),
                  _buildDivider(1),
                  HoverDropdownItem(
                    title: "Case Studies",
                    subtitle: "Real-world impact",
                    isActive: _hoveredIndex == 2,
                    onTap: () => widget.openUrl(_Insights[2].buttonLink),
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 2 : _hoveredIndex),
                  ),
                ],
              ),
            ),
            // Vertical divider between menu and content
            const VerticalDivider(
              color: Color(0xFF2D3847),
              width: 1,
              indent: 8,
              endIndent: 8,
            ),
            // Right side: display content for the selected insight
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _Insights[_hoveredIndex].title,
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
                        _Insights[_hoveredIndex].subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _Insights[_hoveredIndex].description,
                        textAlign: TextAlign.justify,
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
                            widget.onItemPressed();
                            widget.openUrl(_Insights[_hoveredIndex].buttonLink);
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
            ),
          ],
        ),
      ),
    );
  }
}

class InsightsItem {
  final String title;
  final String subtitle;
  final String description;
  final String buttonLink;

  InsightsItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLink,
  });
}
