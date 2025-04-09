import 'package:flutter/material.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/Forms/enquiry_Page.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class WebDevelopmentBlock extends StatefulWidget {
  const WebDevelopmentBlock({super.key});

  @override
  State<WebDevelopmentBlock> createState() => _WebDevelopmentBlockState();
}

class _WebDevelopmentBlockState extends State<WebDevelopmentBlock> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = true;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Custom Web Development',
      'icon': Icons.code,
      'content': '''Building tailored solutions that scale:
- Enterprise-grade applications
- CMS development (WordPress, Strapi)
- E-commerce platforms (Shopify, WooCommerce)
- API integration & microservices
- Responsive design & mobile-first development
- SEO optimization & analytics integration
- Custom plugin & module developments''',
      'color': Colors.blueAccent
    },
    {
      'title': 'UI/UX Design',
      'icon': Icons.design_services,
      'content': '''Creating immersive digital experiences:
- User research & persona development
- Interactive prototyping
- Design systems development
- Motion design & micro-interactions
- Information architecture & wireframing
- Brand identity & visual storytelling
- Responsive design & adaptive layouts''',
      'color': Colors.greenAccent
    },
    {
      'title': 'Cloud Solutions',
      'icon': Icons.cloud,
      'content': '''Scalable infrastructure solutions:
- AWS & Google Cloud integration
- Serverless architecture
- DevOps & CI/CD pipelines
- Containerization (Docker, Kubernetes)
- Cost optimization & resource scaling
- Multi-cloud strategy & hybrid deployment
- Infrastructure as Code (Terraform, CloudFormation)''',
      'color': Colors.orangeAccent
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/website.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.play();
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(
        top: isMobile ? 40 : 60,
        bottom: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: const AssetImage('assets/images/services/webdev.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.9),
                      BlendMode.darken,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 30,
                vertical: isMobile ? 40 : 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Enterprise Web Development Solutions",
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
                        const SizedBox(height: 20),
                        Text(
                          "Transform your digital presence with our full-stack development expertise. "
                          "We deliver high-performance web solutions powered by modern technologies.",
                          style: headlineTextStyleMobile.copyWith(
                            fontFamily: "Montserrat",
                            color: Colors.white70,
                            fontSize: isMobile ? 15 : 18,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  // Video Section
                  Center(
                    child: Container(
                      width: isMobile
                          ? double.infinity
                          : isTablet
                              ? screenWidth * 0.9
                              : 800,
                      height: isMobile
                          ? 200
                          : isTablet
                              ? 300
                              : 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _controller.value.isInitialized
                                ? VideoPlayer(_controller)
                                : Container(
                                    color: Colors.black,
                                    child: const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3)
                                    ],
                                    stops: const [0.6, 1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 16,
                              bottom: 16,
                              child: IconButton(
                                icon: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _isVideoPlaying
                                        ? Icons.pause_rounded
                                        : Icons.play_arrow_rounded,
                                    color: Colors.white,
                                    size: isMobile ? 24 : 28,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isVideoPlaying
                                        ? _controller.pause()
                                        : _controller.play();
                                    _isVideoPlaying = !_isVideoPlaying;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Service Cards Section
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final gridDelegate =
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile
                              ? 1
                              : isTablet
                                  ? 2
                                  : 3,
                          crossAxisSpacing: isMobile ? 15 : 25,
                          mainAxisSpacing: isMobile ? 15 : 25,
                          childAspectRatio: isMobile
                              ? 1.1
                              : isTablet
                                  ? 1
                                  : 0.9,
                        );
                        
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: gridDelegate,
                          itemCount: services.length,
                          itemBuilder: (context, index) => _buildServiceCard(
                            services[index],
                            isMobile: isMobile,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Technology Ecosystem Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    padding: EdgeInsets.all(isMobile ? 15 : 25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Our Technology Ecosystem",
                          style: headlineTextStyle.copyWith(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 28,
                          ),
                        ),
                        SizedBox(height: isMobile ? 15 : 25),
                        Text(
                          "We leverage cutting-edge technologies to build future-proof solutions:",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white70,
                            fontSize: isMobile ? 14 : 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 30),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 4,
                            crossAxisSpacing: isMobile ? 12 : 20,
                            mainAxisSpacing: isMobile ? 12 : 20,
                            childAspectRatio: isMobile ? 2.5 : 3,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) => _buildTechItem(
                            [
                              "React/Next.js",
                              "Flutter Web",
                              "Node.js",
                              "GraphQL",
                              "AWS",
                              "Azure",
                              "Docker",
                              "Firebase"
                            ][index],
                            [
                              "assets/logos/react.png",
                              "assets/logos/flutter.png",
                              "assets/logos/nodejs.png",
                              "assets/logos/graphql.png",
                              "assets/logos/aws.png",
                              "assets/logos/azure.png",
                              "assets/logos/docker.png",
                              "assets/logos/firebase.png"
                            ][index],
                            isMobile,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Call-to-Action Button
                  Center(
                    child: PrimaryGradientButton(
                        onPressed: () => _showDetailsPopup(context, "Website"),
                        text: "Schedule Free Consultation →",
                        padding: isMobile
                            ? const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 14)
                            : const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isMobile ? 300 : null,
        padding: EdgeInsets.all(isMobile ? 15 : 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              service['color'].withOpacity(0.2),
              service['color'].withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: service['color'].withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: service['color'].withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service['icon'],
                color: service['color'].withOpacity(0.5),
              ),
            ),
            SizedBox(height: isMobile ? 15 : 20),
            Text(
              service['title'],
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: isMobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 15),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white70,
                  fontSize: isMobile ? 14 : 16,
                  height: isMobile ? 1.7 : 1.9,
                ),
                children: _processContent(service['content'], isMobile: isMobile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _processContent(String content, {required bool isMobile}) {
    List<TextSpan> spans = [];
    final lines = content.split('\n');

    for (var line in lines) {
      if (line.startsWith('-')) {
        spans.add(TextSpan(
          text: '• ',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 16 : 18,
          ),
        ));
        spans.add(TextSpan(
          text: line.replaceFirst('-', '') + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white70,
            fontSize: isMobile ? 15 : 16,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w500,
            height: isMobile ? 1.2 : 1.9,
          ),
        ));
      }
    }
    return spans;
  }

  Widget _buildTechItem(String name, String iconPath, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.2),
          ],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Image.asset(
              iconPath,
              width: isMobile ? 24 : 30,
              height: isMobile ? 24 : 30,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isMobile ? 10 : 15),
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return Center(
      child: PrimaryGradientButton(
        onPressed: () => _showDetailsPopup(context, "Website"),
        text: "Schedule Free Consultation →",
        padding: isMobile
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
            : const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }

  void _showDetailsPopup(BuildContext context, String dropdownValue) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ResponsiveDialog(dropdownValue: dropdownValue);
      },
    );
  }
}
