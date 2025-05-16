import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pydart/core/extensions/color_extensions.dart';
import 'package:pydart/components/spacing.dart';
import 'package:pydart/components/typography.dart';
import 'package:pydart/widgets/Forms/enquiry_Page.dart';
import 'package:pydart/widgets/buttons/gradient_button.dart';

class IndustryTrendsBlock extends StatefulWidget {
  const IndustryTrendsBlock({super.key});

  @override
  State<IndustryTrendsBlock> createState() => _IndustryTrendsBlockState();
}

class _IndustryTrendsBlockState extends State<IndustryTrendsBlock> {
  // List of images for the slider (replace with industry-relevant images).
  final List<String> sliderImages = [
    'assets/images/insights/robot.jpg',
    'assets/images/insights/iot.jpg',
    'assets/images/insights/digital.jpg',
  ];

  int _currentPage = 0;
  late PageController _pageController;
  Timer? _sliderTimer;

  // List of industry trends (customize titles, icons, content, and colors)
  final List<Map<String, dynamic>> trends = [
    {
      'title': 'AI & Machine Learning',
      'icon': Icons.auto_graph,
      'content': '''Harnessing AI for smarter solutions:
- Predictive analytics
- Personalized user experiences
- Automation and robotics
- Advanced data processing
- Enhanced decision making''',
      'color': Colors.purpleAccent
    },
    {
      'title': 'IoT & Connectivity',
      'icon': Icons.wifi,
      'content': '''Interconnected systems are redefining industries:
- Seamless device integration
- Edge computing advancements
- Real-time data exchange
- Security and privacy challenges
- Scalable cloud solutions''',
      'color': Colors.tealAccent
    },
    {
      'title': 'Digital Transformation',
      'icon': Icons.transform,
      'content': '''Businesses embracing digital change:
- E-commerce innovations
- Mobile-first strategies
- Automation of core processes
- Enhanced customer engagement
- Agility in operations''',
      'color': Colors.orangeAccent
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    // Shuffle images at startup
    sliderImages.shuffle();

    // Auto-slide every 5 seconds.
    _sliderTimer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageController.hasClients) {
        _currentPage++;

        if (_currentPage >= sliderImages.length) {
          _currentPage = 0;
          sliderImages.shuffle(); // Shuffle again when looping back
        }

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
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
            // Background Image for Industry Trends
            Positioned.fill(
              child: Container(
                color: const Color.fromARGB(
                    147, 0, 0, 0), // Fills the container with black color
              ),
            ),

            // Main Content
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 30,
                vertical: isMobile ? 40 : 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Description
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Leading Industry Trends",
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
                          "At Pydart IntelliCorp, we stay ahead by leveraging the latest trends in AI, IoT, and digital transformation to build tomorrow’s solutions.",
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
                  // Image Slider (Carousel)
                  Center(
                    child: Container(
                      width: double.infinity,
                      height: isMobile
                          ? 200
                          : isTablet
                              ? 300
                              : 400,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        child: Stack(
                          children: [
                            PageView.builder(
                              controller: _pageController,
                              itemCount: sliderImages.length,
                              itemBuilder: (context, index) {
                                return Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Image.asset(
                                      sliderImages[index],
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                    ),
                                    // Dark Overlay
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                            // Gradient Overlay
                            Positioned.fill(
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.3),
                                    ],
                                    stops: const [0.6, 1],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Trends Grid
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
                          itemCount: trends.length,
                          itemBuilder: (context, index) => _buildTrendCard(
                            trends[index],
                            isMobile: isMobile,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Core Technologies & Tools Section (optional for industry context)
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
                          "Emerging Technologies",
                          style: headlineTextStyle.copyWith(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 28,
                          ),
                        ),
                        SizedBox(height: isMobile ? 15 : 25),
                        Text(
                          "Driving innovation with next-gen tools and platforms:",
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
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 4,
                            crossAxisSpacing: isMobile ? 12 : 20,
                            mainAxisSpacing: isMobile ? 12 : 20,
                            childAspectRatio: isMobile ? 2.5 : 3,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) => _buildTechItem(
                            [
                              "AI",
                              "Big Data",
                              "Cloud",
                              "IoT",
                              "Blockchain",
                              "Cybersecurity",
                              "AR/VR",
                              "5G"
                            ][index],
                            [
                              "assets/logos/insights/ai.png",
                              "assets/logos/insights/bigdata.png",
                              "assets/logos/insights/cloud.png",
                              "assets/logos/insights/iot.png",
                              "assets/logos/insights/blockchain.png",
                              "assets/logos/insights/cybersecurity.png",
                              "assets/logos/insights/vr.png",
                              "assets/logos/insights/nlp.png"
                            ][index],
                            isMobile,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Call-to-Action Button
                  // Center(
                  //   child: PrimaryGradientButton(
                  //     onPressed: () =>
                  //         _showDetailsPopup(context, "Industry Trends"),
                  //     text: "Discover Our Insights →",
                  //     padding: isMobile
                  //         ? const EdgeInsets.symmetric(
                  //             horizontal: 24, vertical: 14)
                  //         : const EdgeInsets.symmetric(
                  //             horizontal: 32, vertical: 16),
                  //   ),
                  // )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendCard(Map<String, dynamic> trend, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isMobile ? 300 : null,
        padding: EdgeInsets.all(isMobile ? 15 : 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              trend['color'].withOpacity(0.15),
              trend['color'].withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: trend['color'].withOpacity(0.3),
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: trend['color'].withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 1,
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
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: trend['color'].withOpacity(0.2),
                ),
              ),
              child: Icon(
                trend['icon'],
                color: trend['color'].withOpacity(0.7),
              ),
            ),
            SizedBox(height: isMobile ? 15 : 20),
            Text(
              trend['title'],
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
                children: _processContent(trend['content'], isMobile: isMobile),
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
          text: '▹ ',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 14 : 16,
          ),
        ));
        spans.add(TextSpan(
          text: line.replaceFirst('-', '') + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white70,
            fontSize: isMobile ? 14 : 16,
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
          Container(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                bottomLeft: Radius.circular(8),
              ),
            ),
            child: Image.asset(
              iconPath,
              width: isMobile ? 24 : 30,
              height: isMobile ? 24 : 30,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 15),
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
        onPressed: () => _showDetailsPopup(context, "Industry Trends"),
        text: "Learn More →",
        padding: isMobile
            ? const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
            : const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      ),
    );
  }
}

void _showDetailsPopup(BuildContext context, String dropdownValue) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveDialog(dropdownValue: dropdownValue);
    },
  );
}
