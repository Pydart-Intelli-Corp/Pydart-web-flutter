import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
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
            image: DecorationImage(
              image: const NetworkImage(
                "https://images.unsplash.com/photo-1716436329476-fd6cbaa1fc71?q=80&w=2128&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8MA%3D%3D"),
              fit: BoxFit.cover,
              opacity: 0.2,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), BlendMode.darken),
            ),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF111111), Color(0xFF1A1A1A)],
            ),
            borderRadius: BorderRadius.circular(0),
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
            borderRadius: BorderRadius.circular(0),
            child: Stack(
              children: [
                _buildAnimatedBackground(),
                // Overlay a translucent black screen over the background
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
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
                      icon: Icons.location_on_outlined,
                      title: "Where Are You Now?",
                      description: "Welcome to Pydart Intelli Corp's digital headquarters - "
                        "where innovation meets implementation. As a forward-thinking tech startup, "
                        "we create intelligent solutions that enhance human productivity through "
                        "AI-driven automation and IoT integration. Explore our cutting-edge services "
                        "designed to future-proof businesses and transform operational efficiency.\n",
                      delay: 0,
                    )),
                    ResponsiveRowColumnItem(child: _buildAnimatedCard(
                      icon: Icons.auto_awesome_mosaic_outlined,
                      title: "Future-Ready Products",
                      description: "Our development pipeline features AI-powered tools that redefine "
                        "business automation and human-machine collaboration. Currently evolving: "
                        "adaptive workflow optimizers, smart IoT ecosystems, and intelligent "
                        "analytics platforms. By bridging technology gaps, we create solutions "
                        "that learn, adapt, and grow with your organization's evolving needs.\n",
                      delay: 300,
                    )),
                    ResponsiveRowColumnItem(child: _buildAnimatedCard(
                      icon: Icons.engineering_outlined,
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

  Widget _buildAnimatedCard({
    required IconData icon,
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
                ..translate(
                  0.0,
                  -10 * _hoverController.value,
                  0.0,
                )
                ..scale(1.0 + 0.05 * _hoverController.value),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(0),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryDark.withOpacity(0.1 * _hoverController.value),
                      AppColors.secondary.withOpacity(0.05 * _hoverController.value),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryDark.withOpacity(0.3 * _hoverController.value),
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
                    borderRadius: BorderRadius.circular(0),
                    side: BorderSide(
                      color: AppColors.primaryDark.withOpacity(0.2 * _hoverController.value),
                      width: 2,
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(0),
                    onTap: () {},
                    hoverColor: Colors.transparent,
                    splashColor: AppColors.primaryDark.withOpacity(0.1),
                    highlightColor: AppColors.primaryDark.withOpacity(0.05),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          _buildHoverIcon(icon, delay),
                          const SizedBox(height: 24),
                          Text(
                            title,
                            style: headlineSecondaryTextStyle.copyWith(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              shadows: [
                                Shadow(
                                  color: const Color.fromARGB(255, 1, 36, 34).withOpacity(0.3 * _hoverController.value),
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
                            textAlign: TextAlign.justify,
                            style: bodyTextStyle.copyWith(
                              color: AppColors.whitegrey,
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
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHoverIcon(IconData icon, int delay) {
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
                  color: AppColors.primaryDark.withOpacity(0.05 * _hoverController.value),
                ),
              );
            },
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryDark.withOpacity(0.3 * _hoverController.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(icon, size: 36, color: AppColors.primaryDark),
          )
          .animate(autoPlay: false)
          .fadeIn(delay: delay.ms, duration: 800.ms)
          .slideY(begin: 0.2, end: 0)
          .shake(
            delay: 1500.ms,
            hz: 0.5,
            offset: const Offset(8, 0),
            duration: 1000.ms,
          ),
          AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Positioned(
                top: 20 * _hoverController.value,
                left: 20 * _hoverController.value,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryDark.withOpacity(0.1 - 0.1 * _hoverController.value),
                  ),
                ),
              );
            },
          ),
        ],
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
            begin: Offset(1, 1),
            end: Offset(1.3, 1.3),
          ),
        ],
        child: Container(
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  "https://images.unsplash.com/photo-1523961131990-5ea7c61b2107?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}