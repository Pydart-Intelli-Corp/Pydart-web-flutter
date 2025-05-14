import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:visibility_detector/visibility_detector.dart';

class Brief extends StatefulWidget {
  const Brief({super.key});

  @override
  State<Brief> createState() => _BriefState();
}

class _BriefState extends State<Brief> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  final GlobalKey _briefKey = GlobalKey();
  late AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _isVisible) {
      setState(() => _isVisible = false);
    }
    if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_isVisible) {
      setState(() => _isVisible = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: _briefKey,
      onVisibilityChanged: (visibilityInfo) {
        if (visibilityInfo.visibleFraction > 0.3) {
          setState(() => _isVisible = true);
        }
      },
      child: AnimatedOpacity(
        opacity: _isVisible ? 1.0 : 0.0,
        duration: 500.ms,
        child: AnimatedContainer(
          duration: 500.ms,
          transform: Matrix4.translationValues(0, _isVisible ? 0 : 50, 0),
          decoration: BoxDecoration(
            image:  DecorationImage(
              image: NetworkImage(
                "https://images.unsplash.com/photo-1716436329476-fd6cbaa1fc71?q=80&w=2128&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8MA%3D%3D"),
              fit: BoxFit.cover,
              opacity: 0.2,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken)),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF111111), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
                blurRadius: 30,
                spreadRadius: 5,
                offset: const Offset(0, 15),
              ),
            ],
          ),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                _buildAnimatedBackground(),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.black.withOpacity(0.4)
                        ],
                      ),
                    ),
                  ),
                ),
                ResponsiveRowColumn(
                  layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowCrossAxisAlignment: CrossAxisAlignment.start,
                  columnCrossAxisAlignment: CrossAxisAlignment.center,
                  columnMainAxisSize: MainAxisSize.min,
                  rowPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 70),
                  columnPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
                  columnSpacing: 50,
                  rowSpacing: 40,
                  children: [
                    ResponsiveRowColumnItem(child: _buildAnimatedCard(
                      iconAsset: "assets/icons/LOC.png",
                      networkIcon: Icons.language, // Built-in globe icon
                      title: "Where Are You Now?",
                      description: "Welcome to Pydart Intelli Corp's digital headquarters - "
                        "where innovation meets implementation. As a forward-thinking tech startup, "
                        "we create intelligent solutions that enhance human productivity through "
                        "AI-driven automation and IoT integration. Explore our cutting-edge services "
                        "designed to future-proof businesses and transform operational efficiency.\n",
                      delay: 0,
                    )),
                    ResponsiveRowColumnItem(child: _buildAnimatedCard(
                      iconAsset: "assets/icons/FUT.png",
                      networkIcon: Icons.device_hub, // Built-in network icon
                      title: "Future-Ready Products",
                      description: "Our development pipeline features AI-powered tools that redefine "
                        "business automation and human-machine collaboration. Currently evolving: "
                        "adaptive workflow optimizers, smart IoT ecosystems, and intelligent "
                        "analytics platforms. By bridging technology gaps, we create solutions "
                        "that learn, adapt, and grow with your organization's evolving needs.\n",
                      delay: 300,
                    )),
                    ResponsiveRowColumnItem(child: _buildAnimatedCard(
                      iconAsset: "assets/icons/PRO.png",
                      networkIcon: Icons.cloud, // Built-in cloud icon
                      title: "Comprehensive Services",
                      description: "We deliver integrated technology solutions combining AI development, "
                        "IoT systems, and strategic business automation. Our full-cycle services "
                        "range from intelligent web/app development to embedded systems design "
                        "and digital transformation consulting. From concept to market-ready "
                        "deployment, we implement adaptive solutions that drive sustainable growth.",
                      delay: 600,
                    )),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Modified to add network connectivity lines animation
  Widget _buildNetworkLines(IconData networkIcon, int delay) {
    return Positioned.fill(
      child: CustomPaint(
        painter: NetworkLinesPainter(
          animation: _hoverController,
        ),
        child: Center(
          child: Icon(
            networkIcon,
            size: 100,
            color: Color.fromARGB(255, 0, 0, 0).withOpacity(0.15),
          )
          .animate(autoPlay: true)
          .fadeIn(delay: delay.ms, duration: 1200.ms)
          .scale(begin: const Offset(1.0, 1.0),)
          .then()
          .custom(
            duration: 3000.ms,
            curve: Curves.easeInOut,
            builder: (context, value, child) => Opacity(
              opacity: 0.1 + 0.2 * (0.5 + 0.5 * sin(value * 6.28)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHoverIcon(String assetPath, int delay) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Container(
                width: 80 + 20 * _hoverController.value,
                height: 80 + 20 * _hoverController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      const Color.fromARGB(255, 8, 8, 8).withOpacity(0.1 * _hoverController.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          AnimatedContainer(
            duration: 300.ms,
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.3 * _hoverController.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                assetPath,
                width: 36,
                height: 36,
                fit: BoxFit.contain,
                color: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          )
          .animate(autoPlay: false)
          .fadeIn(delay: delay.ms, duration: 800.ms)
          .slideY(begin: 0.2, end: 0)
          .scale(
            delay: 1500.ms,
            duration: 1000.ms,
            curve: Curves.elasticOut,
          ),
        ],
      ),
    );
  }

  // Modified to include the network icon parameter and remove borders
  Widget _buildAnimatedCard({
    required String iconAsset,
    required IconData networkIcon,
    required String title,
    required String description,
    required int delay,
  }) {
    return ResponsiveRowColumnItem(
      rowFlex: 1,
      child: MouseRegion(
        onEnter: (_) => _hoverController.forward(),
        onExit: (_) => _hoverController.reverse(),
        child: AnimatedBuilder(
          animation: _hoverController,
          builder: (context, child) {
            return Transform(
              transform: Matrix4.identity()
                ..translate(0.0, -10 * _hoverController.value, 0.0)
                ..scale(1.0 + 0.05 * _hoverController.value),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color.fromARGB(0, 42, 42, 42).withOpacity(0.1 * _hoverController.value),
                      const Color.fromARGB(0, 0, 0, 0).withOpacity(0 * _hoverController.value),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(0, 35, 49, 48).withOpacity(0.3 * _hoverController.value),
                      blurRadius: 30,
                      spreadRadius: 5,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Card(
                  elevation: 0,
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    // Border has been removed here
                  ),
                  child: Stack(
                    children: [
                      // Network icon overlay on top of text
                      _buildNetworkLines(networkIcon, delay),
                      
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            _buildHoverIcon(iconAsset, delay),
                            const SizedBox(height: 24),
                            Text(
                              title,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    color: Color(0xFF00FFE0),
                                    blurRadius: 15,
                                    offset: Offset.zero),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(delay: (delay + 200).ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                            const SizedBox(height: 16),
                            Text(
                              description,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: Color(0xFFCCCCCC),
                                fontSize: 15,
                                height: 1.7,
                              ),
                            )
                            .animate()
                            .fadeIn(delay: (delay + 400).ms, duration: 800.ms)
                            .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: Animate(
        effects: [
          ScaleEffect(
            duration: 15000.ms,
            curve: Curves.easeInOut,
            begin: const Offset(1.0, 1.0),
            end: const Offset(1.3, 1.3),
          ),
        ],
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1718241905696-cb34c2c07bed?q=80&w=2128&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter to draw network-like connection lines
class NetworkLinesPainter extends CustomPainter {
  final Animation<double> animation;
  
  NetworkLinesPainter({required this.animation}) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final Paint linePaint = Paint()
      ..color = const Color(0xFF00FFE0).withOpacity(0.1 + 0.2 * animation.value)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
      
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 4 : size.height / 4;
    
    // Draw 8 lines radiating from center
    for (int i = 0; i < 8; i++) {
      final angle = i * (3.14159 * 2 / 8);
      final lineLength = radius * (0.8 + 0.4 * animation.value);
      final x = center.dx + cos(angle) * lineLength;
      final y = center.dy + sin(angle) * lineLength;
      
      canvas.drawLine(center, Offset(x, y), linePaint);
      
      // Draw nodes at the ends of lines
      final nodePaint = Paint()
        ..color = const Color(0xFF00FFE0).withOpacity(0.3 + 0.3 * animation.value)
        ..style = PaintingStyle.fill;
        
      canvas.drawCircle(Offset(x, y), 3.0, nodePaint);
    }
    
    // Draw connecting arcs between nodes in a more structured network pattern
    final arcPaint = Paint()
      ..color = const Color(0xFF00FFE0).withOpacity(0.05 + 0.1 * animation.value)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;
      
    // Create a more structured network pattern
    for (int i = 0; i < 8; i++) {
      final angle1 = i * (3.14159 * 2 / 8);
      final angle2 = ((i + 2) % 8) * (3.14159 * 2 / 8);
      
      final x1 = center.dx + cos(angle1) * radius;
      final y1 = center.dy + sin(angle1) * radius;
      
      final x2 = center.dx + cos(angle2) * radius;
      final y2 = center.dy + sin(angle2) * radius;
      
      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), arcPaint);
    }
  }
  
  @override
  bool shouldRepaint(NetworkLinesPainter oldDelegate) => true;
}