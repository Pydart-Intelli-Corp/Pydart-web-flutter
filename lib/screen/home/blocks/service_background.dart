import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;
import 'package:flutter_website/components/typography.dart';

class ServicesBlock extends StatefulWidget {
  const ServicesBlock({super.key});

  @override
  State<ServicesBlock> createState() => _ServicesBlockState();
}

class _ServicesBlockState extends State<ServicesBlock> 
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _animController;
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);
  final List<Service> _services = [
    Service(
      title: "Digital Innovation",
      color: AppColors.buttonPrimaryPressedOutline,
      image: "https://images.unsplash.com/photo-1550745165-9bc0b252726f",
      content: '''
Transformative technology solutions that redefine industry standards. Our full-stack expertise spans:

• AI-driven web platforms with real-time analytics
• Cloud-native microservices architecture
• Cross-platform mobile experiences with Flutter
• IoT integration for smart ecosystems
• Blockchain-powered enterprise solutions
• AR/VR immersive interfaces''',
    ),
    Service(
      title: "Experience Design",
      color: AppColors.primaryDark,
      image: "https://images.unsplash.com/photo-1535223289827-42f1e9919769",
      content: '''
Human-centered digital experiences that engage and convert:

• UX research & usability testing
• Motion design systems implementation
• Voice interface development
• Accessibility-first design principles
• Multi-modal interaction patterns
• Brand identity ecosystems''',
    ),
    Service(
      title: "Intelligent Systems",
      color: AppColors.border,
      image: "https://images.unsplash.com/photo-1531403009284-440f080d1e12",
      content: '''
Next-generation automation powered by AI/ML:

• Predictive analytics engines
• Computer vision solutions
• Natural language processing
• Robotic process automation
• Smart manufacturing systems
• Digital twin implementations''',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..forward();
    _pageController.addListener(() => _pageNotifier.value = _pageController.page!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return Container(
      height: size.height * 0.8,
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.2,
          colors: [
            AppColors.pydart,
            AppColors.backgroundDark,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background Elements
          Positioned.fill(
            child: ValueListenableBuilder<double>(
              valueListenable: _pageNotifier,
              builder: (context, page, _) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 800),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.5 + page * 0.1),
                      radius: 1.5,
                      colors: [
                        _services[page.round() % _services.length].color.withOpacity(0.1),
                        Colors.transparent,
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Content
          Column(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 80,
                  left: isMobile ? 30 : 100,
                  right: isMobile ? 30 : 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeTransition(
                      opacity: _animController,
                      child: Text(
                        "Next-Gen Solutions",
                        style: TextStyle(
                          fontSize: isMobile ? 36 : 64,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: "SpaceGrotesk",
                          height: 0.9,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    FadeTransition(
                      opacity: _animController,
                      child: Text(
                        "Integrated technology services for the digital frontier",
                        style: TextStyle(
                          fontSize: isMobile ? 18 : 24,
                          color: Colors.white70,
                          fontFamily: "SpaceGrotesk",
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _services.length,
                  itemBuilder: (context, index) {
                    final service = _services[index];
                    final page = _pageNotifier.value;
                    final diff = (page - index).abs();
                    final scale = 1 - diff * 0.2;
                    
                    return ValueListenableBuilder<double>(
                      valueListenable: _pageNotifier,
                      builder: (context, page, _) {
                        final isActive = page.round() == index;
                        return AnimatedScale(
                          duration: const Duration(milliseconds: 400),
                          scale: isActive ? 1 : 0.9,
                          child: Container(
                            margin: EdgeInsets.symmetric(
                              vertical: isActive ? 20 : 40,
                              horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: service.color.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 20,
                                  offset: const Offset(0, 10)),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Stack(
                                children: [
                                  // Background Image
                                  Positioned.fill(
                                    child: Image.network(
                                      service.image,
                                      fit: BoxFit.cover,
                                      color: Colors.black.withOpacity(0.4),
                                      colorBlendMode: BlendMode.multiply,
                                    ),
                                  ),

                                  // Content Overlay
                                  Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          service.color.withOpacity(0.1),
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(40),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          service.title,
                                          style: TextStyle(
                                            fontSize: isMobile ? 32 : 48,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                            fontFamily: "SpaceGrotesk",
                                            letterSpacing: -1.5,
                                          ),
                                        ),
                                        const SizedBox(height: 30),
                                        Expanded(
                                          child: Text(
                                            service.content,
                                            style: TextStyle(
                                              fontSize: isMobile ? 16 : 18,
                                              color: Colors.white70,
                                              fontFamily: "Inter",
                                              height: 1.6,
                                            ),
                                          ),
                                        ),
                                        if (!isMobile)
                                          OutlinedButton.icon(
                                            icon: Icon(Icons.arrow_forward,
                                                color: service.color),
                                            label: Text(
                                              "Explore Capabilities",
                                              style: TextStyle(
                                                color: service.color,
                                                fontFamily: "SpaceGrotesk",
                                              ),
                                            ),
                                            onPressed: () {},
                                            style: OutlinedButton.styleFrom(
                                              side: BorderSide(
                                                  color: service.color),
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 30, vertical: 20),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20)),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Service {
  final String title;
  final Color color;
  final String image;
  final String content;

  Service({
    required this.title,
    required this.color,
    required this.image,
    required this.content,
  });
}