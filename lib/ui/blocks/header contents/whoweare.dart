import 'package:flutter/material.dart';
import 'package:flutter_website/router.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'package:flutter_website/ui/blocks/header contents/hoverdropdown.dart';
import 'package:flutter_website/widgets/buttons/text_hover_button.dart';
import 'package:provider/provider.dart';

class WhoWeAreContent extends StatefulWidget {
  final VoidCallback onItemPressed;
  final Function(String) openUrl;

  const WhoWeAreContent({
    Key? key,
    required this.onItemPressed,
    required this.openUrl,
  }) : super(key: key);

  @override
  State<WhoWeAreContent> createState() => _WhoWeAreContentState();
}

class _WhoWeAreContentState extends State<WhoWeAreContent> {
  int _hoveredIndex = 0; // Start with the first item selected
  bool _isLearnMoreHovered = false; // New state for "Learn More" button hover

  final List<WhoWeAreItem> _whoWeAreContent = [
    WhoWeAreItem(
      title: "Our Story",
      subtitle: "From Startup to Innovator",
      description:
          "Founded as an ambitious startup, Pydart Intelli Corp emerged from a passion for innovation and a commitment to excellence. With a clear vision to help people and businesses harness the power of future technologies and AI, our journey is defined by transforming challenges into scalable opportunities and consistently pushing the boundaries of what's possible.",
      buttonLink: 'https://www.pydartintelli.com/our-story',
    ),
    WhoWeAreItem(
      title: "Our Mission",
      subtitle: "Empowering Through Innovation",
      description:
          "Our mission is to empower organizations and individuals by delivering state-of-the-art digital solutions that embrace the future. We integrate advanced AI and emerging technologies to create tailored applications, enabling people and businesses to thrive in a digital age. At Pydart Intelli Corp, we transform challenges into growth opportunities with innovation at the core.",
      buttonLink: 'https://www.pydartintelli.com/our-mission',
    ),
    WhoWeAreItem(
      title: "Our Vision",
      subtitle: "Pioneering a Smarter Future",
      description:
          "We envision a future where technology and artificial intelligence revolutionize everyday life and business. As a forward-thinking startup, our vision is to lead this transformation by developing innovative solutions that not only meet today's needs but also anticipate tomorrow's challenges. Our commitment is to build a more connected, efficient, and sustainable world for all.",
      buttonLink: 'https://www.pydartintelli.com/our-vision',
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

  /// Builds the content section (right side) with title, subtitle, description, and a button.
  Widget _buildContentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _whoWeAreContent[_hoveredIndex].title,
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
          _whoWeAreContent[_hoveredIndex].subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _whoWeAreContent[_hoveredIndex].description,
          textAlign: TextAlign.justify,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white.withOpacity(0.8),
            height: 1.5,
            fontFamily: 'Roboto',
          ),
        ),
        const SizedBox(height: 24),
        // Wrap the "Learn More" button in a MouseRegion to track hover events
        MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isLearnMoreHovered = true),
          onExit: (_) => setState(() => _isLearnMoreHovered = false),
          child: InkWell(
            onTap: () {
              widget.onItemPressed();
              widget.openUrl(_whoWeAreContent[_hoveredIndex].buttonLink);
            },
            hoverColor: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                // Here the underline is shown when _isLearnMoreHovered is true.
                isActive: _isLearnMoreHovered,
                onPressed: () {
                  widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'whoweare';
                  Navigator.pushReplacementNamed(context, Routes.whoweare);
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Calculate a dynamic container width:
          // If the available width is less than 1270, use 95% of available width.
          double containerWidth = constraints.maxWidth < 1270
              ? constraints.maxWidth * 0.95
              : 1270;
          // Determine if the layout should switch to vertical stacking on narrow screens.
          bool isNarrow = constraints.maxWidth < 800;
          // Wrap the entire container in a horizontal scroll view
          // to ensure any overflow is scrollable.
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Container(
              width: containerWidth,
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
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Menu items
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HoverDropdownItem(
                              title: "Our Story",
                              subtitle: "From Startup to Innovator",
                              isActive: _hoveredIndex == 0,
                              onTap: () => widget.openUrl(_whoWeAreContent[0].buttonLink),
                              onParentTap: widget.onItemPressed,
                              onHover: (isHovered) =>
                                  setState(() => _hoveredIndex = isHovered ? 0 : _hoveredIndex),
                            ),
                            _buildDivider(0),
                            HoverDropdownItem(
                              title: "Our Mission",
                              subtitle: "Empowering Through Innovation",
                              isActive: _hoveredIndex == 1,
                              onTap: () => widget.openUrl(_whoWeAreContent[1].buttonLink),
                              onParentTap: widget.onItemPressed,
                              onHover: (isHovered) =>
                                  setState(() => _hoveredIndex = isHovered ? 1 : _hoveredIndex),
                            ),
                            _buildDivider(1),
                            HoverDropdownItem(
                              title: "Our Vision",
                              subtitle: "Pioneering a Smarter Future",
                              isActive: _hoveredIndex == 2,
                              onTap: () => widget.openUrl(_whoWeAreContent[2].buttonLink),
                              onParentTap: widget.onItemPressed,
                              onHover: (isHovered) =>
                                  setState(() => _hoveredIndex = isHovered ? 2 : _hoveredIndex),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        const Divider(color: Color(0xFF2D3847)),
                        const SizedBox(height: 16),
                        // Content display for the selected section
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: _buildContentSection(),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side: menu items
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              HoverDropdownItem(
                                title: "Our Story",
                                subtitle: "From Startup to Innovator",
                                isActive: _hoveredIndex == 0,
                                onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'whoweare';
                  Navigator.pushReplacementNamed(context, Routes.whoweare);},
                                onParentTap: widget.onItemPressed,
                                onHover: (isHovered) =>
                                    setState(() => _hoveredIndex = isHovered ? 0 : _hoveredIndex),
                              ),
                              _buildDivider(0),
                              HoverDropdownItem(
                                title: "Our Mission",
                                subtitle: "Empowering Through Innovation",
                                isActive: _hoveredIndex == 1,
                                onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'whoweare';
                  Navigator.pushReplacementNamed(context, Routes.whoweare);},
                                onParentTap: widget.onItemPressed,
                                onHover: (isHovered) =>
                                    setState(() => _hoveredIndex = isHovered ? 1 : _hoveredIndex),
                              ),
                              _buildDivider(1),
                              HoverDropdownItem(
                                title: "Our Vision",
                                subtitle: "Pioneering a Smarter Future",
                                isActive: _hoveredIndex == 2,
                                onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'whoweare';
                  Navigator.pushReplacementNamed(context, Routes.whoweare);},
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
                        // Right side: display content for the selected section
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: SingleChildScrollView(child: _buildContentSection()),
                          ),
                        ),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }
}

class WhoWeAreItem {
  final String title;
  final String subtitle;
  final String description;
  final String buttonLink;

  WhoWeAreItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLink,
  });
}
