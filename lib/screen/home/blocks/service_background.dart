import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;

class ServicesBlock extends StatefulWidget {
  const ServicesBlock({super.key});

  @override
  State<ServicesBlock> createState() => _ServicesBlockState();
}

class _ServicesBlockState extends State<ServicesBlock> 
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _particleAnimController;
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);
  final List<Service> _services = [
    Service(
      title: "Web Development",
      color: AppColors.pydart,
      image: "https://images.unsplash.com/photo-1507238691740-187a5b1d37b8",
      features: [
        Feature(Icons.language, "Modern Frontend", "React, Vue, Flutter Web"),
        Feature(Icons.storage, "Scalable Backend", "Node.js, Python, Go"),
        Feature(Icons.cloud, "Cloud Integration", "AWS, GCP, Azure"),
        Feature(Icons.shopping_cart, "E-commerce", "Shopify, WooCommerce"),
        Feature(Icons.account_balance_wallet, "Web3", "Blockchain, Smart Contracts"),
        Feature(Icons.biotech, "Real-time Apps", "WebSockets, Firebase"),
      ],
    ),
    Service(
      title: "Mobile Development",
      color: Colors.teal,
      image: "https://images.unsplash.com/photo-1555099962-4199c345e5dd",
      features: [
        Feature(Icons.phone_iphone, "Cross-platform", "Flutter, React Native"),
        Feature(Icons.android, "Android", "Kotlin, Jetpack Compose"),
        Feature(Icons.apple, "iOS", "Swift, SwiftUI"),
        Feature(Icons.gamepad, "AR/VR", "ARKit, ARCore"),
        Feature(Icons.sensors, "IoT Integration", "BLE, NFC"),
        Feature(Icons.security, "Security", "Encryption, OAuth2"),
      ],
    ),
    Service(
      title: "Digital Solutions",
      color: Colors.purple,
      image: "https://images.unsplash.com/photo-1531403009284-440f080d1e12",
      features: [
        Feature(Icons.palette, "UI/UX Design", "Figma, Adobe XD"),
        Feature(Icons.trending_up, "Digital Marketing", "SEO, SMM"),
        Feature(Icons.movie, "Motion Graphics", "After Effects, Blender"),
        Feature(Icons.videocam, "Video Production", "4K, Animation"),
        Feature(Icons.people, "Brand Strategy", "Identity, Positioning"),
        Feature(Icons.analytics, "Analytics", "GA4, Mixpanel"),
      ],
    ),
    Service(
      title: "IoT Solutions",
      color: Colors.orange,
      image: "https://images.unsplash.com/photo-1550745165-9bc0b252726f",
      features: [
        Feature(Icons.developer_board, "Embedded Systems", "Arduino, Raspberry Pi"),
        Feature(Icons.sensors_off, "Sensor Networks", "LoRaWAN, Zigbee"),
        Feature(Icons.factory, "Industrial IoT", "PLC, SCADA"),
        Feature(Icons.graphic_eq, "Data Analytics", "Time Series, ML"),
        Feature(Icons.security, "Cybersecurity", "Encryption, MQTT"),
        Feature(Icons.settings_remote, "Automation", "Home, Industrial"),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.8);
    _particleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    _pageController.addListener(() => _pageNotifier.value = _pageController.page!);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleAnimController.dispose();
    super.dispose();
  }

  Widget _buildBackgroundParticles() {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _particleAnimController,
            builder: (context, _) {
              return Stack(
                children: List.generate(40, (index) {
                  final random = Random(index);
                  final service = _services[_pageNotifier.value.round() % _services.length];
                  final angle = _particleAnimController.value * 2 * pi * (0.5 + random.nextDouble());
                  final dx = cos(angle) * 30;
                  final dy = sin(angle) * 30;
                  final size = 10 + 10 * sin(_particleAnimController.value * 2 * pi + index);

                  return Positioned(
                    left: random.nextDouble() * constraints.maxWidth + dx,
                    top: random.nextDouble() * constraints.maxHeight + dy,
                    child: Transform.rotate(
                      angle: _particleAnimController.value * 2 * pi,
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 2),
                        width: size,
                        height: size,
                        decoration: BoxDecoration(
                          color: service.color.withOpacity(0.05),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: service.color.withOpacity(0.1),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 600;

    return SizedBox(
      height: size.height * 0.9,
      child: Stack(
        children: [
          _buildBackgroundParticles(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 80,
                  left: isMobile ? 20 : 100,
                  right: isMobile ? 20 : 100,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        "Our Expertise",
                        key: ValueKey(_pageNotifier.value.round()),
                        style: TextStyle(
                          fontSize: isMobile ? 36 : 64,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontFamily: "SpaceGrotesk",
                          height: 0.9,
                          letterSpacing: -2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: Text(
                        _services[_pageNotifier.value.round() % _services.length].subtitle,
                        key: ValueKey(_pageNotifier.value.round()),
                        style: TextStyle(
                          fontSize: isMobile ? 16 : 20,
                          color: Colors.white70,
                          fontFamily: "Inter",
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
                    return _ServiceCard(
                      service: _services[index],
                      pageNotifier: _pageNotifier,
                      index: index,
                      isMobile: isMobile,
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

class _ServiceCard extends StatefulWidget {
  final Service service;
  final ValueNotifier<double> pageNotifier;
  final int index;
  final bool isMobile;

  const _ServiceCard({
    required this.service,
    required this.pageNotifier,
    required this.index,
    required this.isMobile,
  });

  @override
  State<_ServiceCard> createState() => _ServiceCardState();
}

class _ServiceCardState extends State<_ServiceCard> 
    with SingleTickerProviderStateMixin {
  late AnimationController _featureController;
  double tiltX = 0;
  double tiltY = 0;

  @override
  void initState() {
    super.initState();
    _featureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  void _updateAnimation() {
    final isActive = widget.pageNotifier.value.round() == widget.index;
    if (isActive) {
      _featureController.forward();
    } else {
      _featureController.reset();
    }
  }

  @override
  void dispose() {
    _featureController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final page = widget.pageNotifier.value;
    final active = page.round() == widget.index;
    final scale = 1 - (page - widget.index).abs() * 0.2;

    return ValueListenableBuilder<double>(
      valueListenable: widget.pageNotifier,
      builder: (context, page, _) {
        _updateAnimation();
   return MouseRegion(
        onEnter: (e) => _updatePosition(e.localPosition),
        onHover: (e) => _updatePosition(e.localPosition),
        onExit: (event) => setState(() {  // Add event parameter here
          tiltX = 0;
          tiltY = 0;
        }),
        child: AnimatedScale(
            scale: active ? 1 : 0.9,
            duration: const Duration(milliseconds: 400),
            child: Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateX(tiltX * pi / 180)
                ..rotateY(tiltY * pi / 180),
              alignment: Alignment.center,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  boxShadow: [
                    BoxShadow(
                      color: widget.service.color.withOpacity(0.3),
                      blurRadius: 40,
                      spreadRadius: 10,
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Stack(
                    children: [
                      _buildParallaxImage(context),
                      _buildContentOverlay(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _updatePosition(Offset localPosition) {
    final size = context.size!;
    final x = (localPosition.dx / size.width) * 2 - 1;
    final y = (localPosition.dy / size.height) * 2 - 1;
    setState(() {
      tiltX = y * 4;
      tiltY = -x * 4;
    });
  }

  Widget _buildParallaxImage(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: widget.pageNotifier,
      builder: (context, page, _) {
        return Transform.translate(
          offset: Offset((widget.index - page) * 60, 0),
          child: Image.network(
            widget.service.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withOpacity(0.4),
            colorBlendMode: BlendMode.multiply,
          ),
        );
      },
    );
  }

  Widget _buildContentOverlay() {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.service.color.withOpacity(0.1),
              Colors.black.withOpacity(0.8),
            ],
          ),
        ),
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.service.title,
              style: TextStyle(
                fontSize: widget.isMobile ? 32 : 48,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                fontFamily: "SpaceGrotesk",
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 30),
// In _buildContentOverlay's GridView
Expanded(
  child: ShrinkWrappingViewport(  // Add Viewport wrapper
    offset: ViewportOffset.zero(),
    slivers: [
      SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: widget.isMobile ? 2 : 3,
          childAspectRatio: 2.5,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildFeature(
            index, 
            widget.service.features[index]
          ),
          childCount: widget.service.features.length,
        ),
      ),
    ],
  ),
),
            if (!widget.isMobile)
              _buildDiscoverButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(int index, Feature feature) {
    return AnimatedBuilder(
      animation: _featureController,
      builder: (context, _) {
        final animation = CurvedAnimation(
          parent: _featureController,
curve: Interval(
  index * 0.15, // Reduced from 0.1
  min(0.8 + index * 0.15, 1.0), // Ensure end <= 1
),
        );

        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(animation),
            
            child: MouseRegion(
              onEnter: (_) => setState(() => feature.isHovered = true),
              onExit: (_) => setState(() => feature.isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: feature.isHovered
                      ? widget.service.color.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: feature.isHovered
                        ? widget.service.color
                        : Colors.white.withOpacity(0.1),
                  ),
                ),
                child: Row(
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: feature.isHovered
                            ? widget.service.color
                            : Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        feature.icon,
                        color: feature.isHovered ? Colors.white : widget.service.color,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            feature.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            feature.description,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDiscoverButton() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: widget.service.color.withOpacity(0.3),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: TextButton.icon(
        icon: Icon(Icons.arrow_forward, color: widget.service.color),
        label: Text(
          "Explore Solutions",
          style: TextStyle(
            color: widget.service.color,
            fontFamily: "SpaceGrotesk",
            fontSize: 18,
          ),
        ),
        onPressed: () {},
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 25),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
            side: BorderSide(color: widget.service.color),
          ),
        ),
      ),
    );
  }
}

class Service {
  final String title;
  final Color color;
  final String image;
  final List<Feature> features;
  bool isHovered;

  Service({
    required this.title,
    required this.color,
    required this.image,
    required this.features,
    this.isHovered = false,
  });

  String get subtitle {
    switch (title) {
      case "Web Development":
        return "Transformative web solutions for modern businesses";
      case "Mobile Development":
        return "Native and cross-platform mobile experiences";
      case "Digital Solutions":
        return "Complete digital transformation services";
      case "IoT Solutions":
        return "Smart connected systems for tomorrow's world";
      default:
        return "Innovative solutions for digital challenges";
    }
  }
}

class Feature {
  final IconData icon;
  final String title;
  final String description;
  bool isHovered;

  Feature(this.icon, this.title, this.description, {this.isHovered = false});
}