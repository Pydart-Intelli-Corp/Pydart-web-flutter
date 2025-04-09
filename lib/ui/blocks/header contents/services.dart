import 'package:flutter/material.dart';
import 'package:flutter_website/router.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'package:flutter_website/ui/blocks/header%20contents/hoverdropdown.dart';
import 'package:flutter_website/widgets/buttons/text_hover_button.dart';
import 'package:provider/provider.dart';

class OurServices extends StatefulWidget {
  final VoidCallback onItemPressed;
  final Function(String) openUrl;

  const OurServices({
    Key? key,
    required this.onItemPressed,
    required this.openUrl,
  }) : super(key: key);

  @override
  State<OurServices> createState() => _OurServicesState();
}

class _OurServicesState extends State<OurServices> {
  int _hoveredIndex = 0; // Start with the first service selected

  final List<ServicesItem> _ourServices = [
    ServicesItem(
      title: "Web Development",
      subtitle: "Crafting dynamic web experiences",
      description:
          "Our web development service harnesses the latest technologies to create responsive, engaging websites tailored to your business needs. Our expert team ensures robust performance, scalability, and a seamless user experience.",
      buttonLink: 'https://www.pydartintelli.com/web-development',
    ),
    ServicesItem(
      title: "Mobile App Development",
      subtitle: "Innovative solutions for mobile",
      description:
          "We deliver high-quality mobile applications for iOS and Android platforms. Our mobile app development service combines design and functionality to create intuitive apps that drive business growth.",
      buttonLink: 'https://www.pydartintelli.com/mobile-app-development',
    ),
    ServicesItem(
      title: "Cloud Solutions",
      subtitle: "Empowering businesses with cloud",
      description:
          "Our cloud solutions enable businesses to leverage the power of cloud computing. We offer scalable, secure, and cost-effective services to streamline operations and enhance productivity.",
      buttonLink: 'https://www.pydartintelli.com/cloud-solutions',
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left side: menu items for each service
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HoverDropdownItem(
                    title: _ourServices[0].title,
                    subtitle: _ourServices[0].subtitle,
                    isActive: _hoveredIndex == 0,
             onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'services';
                  Navigator.pushReplacementNamed(context, Routes.services);},
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 0 : _hoveredIndex),
                  ),
                  _buildDivider(0),
                  HoverDropdownItem(
                    title: _ourServices[1].title,
                    subtitle: _ourServices[1].subtitle,
                    isActive: _hoveredIndex == 1,
                  onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'services';
                  Navigator.pushReplacementNamed(context, Routes.services);},
                    onParentTap: widget.onItemPressed,
                    onHover: (isHovered) =>
                        setState(() => _hoveredIndex = isHovered ? 1 : _hoveredIndex),
                  ),
                  _buildDivider(1),
                  HoverDropdownItem(
                    title: _ourServices[2].title,
                    subtitle: _ourServices[2].subtitle,
                    isActive: _hoveredIndex == 2,
                     onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'services';
                  Navigator.pushReplacementNamed(context, Routes.services);},
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
            // Right side: display content for the selected service
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _ourServices[_hoveredIndex].title,
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
                        _ourServices[_hoveredIndex].subtitle,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _ourServices[_hoveredIndex].description,
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
                         onTap: (){widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'services';
                  Navigator.pushReplacementNamed(context, Routes.services);},
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
                              onPressed: () {  widget.onItemPressed();
                  Provider.of<NavigationProvider>(context, listen: false).active =
                      'services';
                  Navigator.pushReplacementNamed(context, Routes.services);},
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

class ServicesItem {
  final String title;
  final String subtitle;
  final String description;
  final String buttonLink;

  ServicesItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.buttonLink,
  });
}
