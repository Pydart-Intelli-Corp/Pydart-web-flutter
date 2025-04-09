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

class MobileAppDevelopmentBlock extends StatefulWidget {
  const MobileAppDevelopmentBlock({super.key});

  @override
  State<MobileAppDevelopmentBlock> createState() =>
      _MobileAppDevelopmentBlockState();
}

class _MobileAppDevelopmentBlockState extends State<MobileAppDevelopmentBlock> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = true;
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Cross-Platform Apps',
      'icon': Icons.phone_iphone,
      'content': '''Build once, deploy everywhere:
- Flutter & React Native expertise
- Native-like performance
- Custom widget libraries
- Platform-specific optimizations
- CI/CD pipeline integration
- Seamless hardware integration
- Optimized OS compatibility''',
      'color': Colors.purpleAccent,
    },
    {
      'title': 'UI/UX Design',
      'icon': Icons.animation,
      'content': '''Mobile-first experiences:
- Gesture-based interactions
- Material & Cupertino design
- Motion design & animations
- Optimized user flows
- Accessibility standards
- Intuitive navigation
- Responsive layouts''',
      'color': Colors.tealAccent,
    },
    {
      'title': 'Backend Integration',
      'icon': Icons.cloud_sync,
      'content': '''Full-stack mobile solutions:
- Firebase & Supabase integration
- REST/GraphQL API development
- Real-time database management
- Push notifications setup
- Analytics & crash reporting
- Secure authentication & authorization
- Enterprise-grade .NET & Azure integration''',
      'color': Colors.orangeAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/mobile.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.setLooping(true); // Loop the video.
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

    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(
        top: isMobile ? 40 : 60,
        bottom: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.9),
            const Color.fromARGB(255, 17, 9, 51).withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
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
                          "Next-Gen Mobile App Development",
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
                          "Transform ideas into seamless mobile experiences with our full-cycle development process. From concept to App Store deployment - we handle it all.",
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
                  // Video Player Section
                  Center(
                    child: Container(
                      width: isMobile ? double.infinity : 800,
                      height: isMobile ? 220 : 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.deepPurple.withOpacity(0.4),
                            blurRadius: 20,
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
                                      Colors.black.withOpacity(0.4)
                                    ],
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
                          childAspectRatio: isMobile ? 1.1 : 0.9,
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
                  // Tech Stack Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    padding: EdgeInsets.all(isMobile ? 15 : 25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Our Mobile Tech Stack",
                          style: headlineTextStyle.copyWith(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 28,
                          ),
                        ),
                        SizedBox(height: isMobile ? 15 : 25),
                        Text(
                          "We use modern tools to build performant applications:",
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
                            childAspectRatio: isMobile ? 2.2 : 3,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) => _buildTechItem(
                            [
                              "Flutter",
                              "React Native",
                              "Kotlin",
                              "SwiftUI",
                              "Firebase",
                              "GraphQL",
                              "AWS Amplify",
                              "Docker"
                            ][index],
                            [
                              "assets/logos/flutter.png",
                              "assets/logos/react.png",
                              "assets/logos/kotlin.png",
                              "assets/logos/swiftui.png",
                              "assets/logos/firebase.png",
                              "assets/logos/graphql.png",
                              "assets/logos/aws.png",
                              "assets/logos/docker.png"
                            ][index],
                            isMobile,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Call to Action Button
                  Center(
                    child: PrimaryGradientButton(
                      onPressed: () =>
                          _showDetailsPopup(context, "Mobile Application"),
                      text: "Start Your App Journey →",
                      gradient: const LinearGradient(
                        colors: [Colors.purpleAccent, Colors.blueAccent],
                      ),
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

  Widget _buildServiceCard(Map<String, dynamic> service,
      {required bool isMobile}) {
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
                  height: isMobile ? 1.4 : 1.8,
                ),
                children:
                    _processContent(service['content'], isMobile: isMobile),
              ),
              textAlign: TextAlign.justify,
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
            fontSize: isMobile ? 16 : 18,
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
            height: 1.8,
          ),
        ));
      }
    }
    return spans;
  }

  Widget _buildTechItem(String name, String iconPath, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Image.asset(
              iconPath,
              width: isMobile ? 28 : 34,
              height: isMobile ? 28 : 34,
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
                maxLines: 2,
              ),
            ),
          ),
        ],
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
