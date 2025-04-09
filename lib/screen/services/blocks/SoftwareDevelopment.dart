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

class SoftwareDevelopmentBlock extends StatefulWidget {
  const SoftwareDevelopmentBlock({super.key});

  @override
  State<SoftwareDevelopmentBlock> createState() =>
      _SoftwareDevelopmentBlockState();
}

class _SoftwareDevelopmentBlockState extends State<SoftwareDevelopmentBlock> {
  late VideoPlayerController _controller;
  bool _isVideoPlaying = true;

  final List<Map<String, dynamic>> services = [
    {
      'title': 'Custom Software',
      'icon': Icons.tune,
      'content':
          '''Tailored solutions for your business:
- Full lifecycle development
- Microservices architecture
- CI/CD pipeline integration
- Automated testing suites
- Cloud-native development
- Legacy system modernization
- Performance optimization''',
      'color': Colors.cyanAccent,
    },
    {
      'title': 'Cloud Solutions',
      'icon': Icons.cloud_queue,
      'content':
          '''Scalable cloud infrastructure:
- AWS/Azure/GCP expertise
- Serverless architectures
- Container orchestration
- Cloud security & compliance
- Multi-cloud deployments
- Disaster recovery plans
- Cost optimization strategies''',
      'color': Colors.tealAccent,
    },
    {
      'title': 'Enterprise Systems',
      'icon': Icons.business,
      'content':
          '''Digital transformation solutions:
- ERP/CRM integration
- Big Data analytics
- AI/ML implementation
- IoT platforms
- Blockchain solutions
- Workflow automation
- Enterprise-grade security''',
      'color': Colors.greenAccent,
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/software.mp4')
      ..initialize().then((_) {
        _controller.setVolume(0);
        _controller.setLooping(true);
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
      margin: blockMargin.copyWith(top: 80, bottom: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.97),
            AppColors.deepBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepBlue.withOpacity(0.4),
            blurRadius: 40,
            spreadRadius: 10,
          )
        ],
      ),
      child: ClipRRect(
        child: Stack(
          children: [
            _buildBackgroundPattern(),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 40,
                vertical: 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeaderSection(isMobile),
                  const SizedBox(height: 40),
                  _buildVideoSection(isMobile),
                  const SizedBox(height: 60),
                  _buildServicesGrid(isMobile, isTablet),
                  const SizedBox(height: 60),
                  _buildTechStackSection(isMobile),
                  const SizedBox(height: 60),
                  _buildContactSection(isMobile),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundPattern() {
    return Opacity(
      opacity: 0.05,
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/services/software.jpg'),
            repeat: ImageRepeat.repeat,
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSection(bool isMobile) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Software Solutions",
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
          const SizedBox(height: 25),
          Text(
            "Transform your business with cutting-edge software solutions. From concept to deployment - we engineer success at scale.",
            style: headlineTextStyleMobile.copyWith(
              fontFamily: "Montserrat",
              color: Colors.white70,
              fontSize: isMobile ? 16 : 20,
              height: 1.6,
              fontWeight: FontWeight.w300,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection(bool isMobile) {
    return Center(
      child: Container(
        width: isMobile ? double.infinity : 1000,
        height: isMobile ? 220 : 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepBlue.withOpacity(0.6),
              blurRadius: 30,
              spreadRadius: 5,
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            alignment: Alignment.center,
            children: [
              _controller.value.isInitialized
                  ? VideoPlayer(_controller)
                  : _buildLoadingIndicator(),
              _buildVideoOverlay(),
              _buildVideoControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      color: Colors.black,
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildVideoOverlay() {
    return Positioned.fill(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.transparent,
              Colors.black.withOpacity(0.6),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  Widget _buildVideoControls() {
    return Positioned(
      right: 20,
      bottom: 20,
      child: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _isVideoPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 28,
          ),
        ),
        onPressed: _toggleVideoPlayback,
      ),
    );
  }

  void _toggleVideoPlayback() {
    setState(() {
      _isVideoPlaying ? _controller.pause() : _controller.play();
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  Widget _buildServicesGrid(bool isMobile, bool isTablet) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30,
          childAspectRatio: isMobile ? 1 : 0.95,
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
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service,
      {required bool isMobile}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: service['color'].withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: service['color'].withOpacity(0.1),
            blurRadius: 30,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: service['color'].withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  service['icon'],
                  color: service['color'],
                  size: 28,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  service['title'],
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontSize: isMobile ? 22 : 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          RichText(
            text: TextSpan(
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white70,
                fontSize: isMobile ? 15 : 16,
                height: 1.6,
              ),
              children: _processContent(service['content'], isMobile: isMobile),
            ),
          ),
        ],
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
            fontSize: isMobile ? 15 : 16,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white,
            fontSize: isMobile ? 17 : 19,
            fontWeight: FontWeight.w500,
            height: 1.8,
          ),
        ));
      }
    }
    return spans;
  }

  Widget _buildTechStackSection(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            AppColors.deepBlue.withOpacity(0.2),
          ],
        ),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Our Development Ecosystem",
            style: headlineTextStyle.copyWith(
              fontFamily: "Montserrat",
              color: Colors.white,
              fontSize: isMobile ? 24 : 28,
            ),
          ),
          const SizedBox(height: 30),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isMobile ? 2 : 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 20,
              childAspectRatio: isMobile ? 2.2 : 3,
            ),
            itemCount: 8,
            itemBuilder: (context, index) => _buildTechItem(
              [
                "Python",
                "Java",
                ".NET Core",
                "Node.js",
                "AWS",
                "Docker",
                "Kubernetes",
                "Terraform"
              ][index],
              [
                "assets/logos/python.png",
                "assets/logos/java.png",
                "assets/logos/dotnet.png",
                "assets/logos/nodejs.png",
                "assets/logos/aws.png",
                "assets/logos/docker.png",
                "assets/logos/kubernetes.png",
                "assets/logos/terraform.png"
              ][index],
              isMobile,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechItem(String name, String iconPath, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        gradient: LinearGradient(
          colors: [
            Colors.black.withOpacity(0.4),
            Colors.black.withOpacity(0.2),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Image.asset(
              iconPath,
              width: isMobile ? 32 : 40,
              height: isMobile ? 32 : 40,
            ),
            const SizedBox(width: 15),
            Text(
              name,
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: isMobile ? 16 : 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactSection(bool isMobile) {
    return Center(
      child: PrimaryGradientButton(
        onPressed: () =>
            _showDetailsPopup(context, "Computer Software"),
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
