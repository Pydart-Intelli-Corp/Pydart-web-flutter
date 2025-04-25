import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/screen/Insights/InsightsHead.dart';
import 'package:flutter_website/screen/Insights/blocks/IndustryTrend.dart';
import 'package:flutter_website/screen/Insights/blocks/mission.dart';
import 'package:flutter_website/screen/Insights/blocks/vision.dart';

import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class InsightScreen extends StatefulWidget {
  const InsightScreen({Key? key}) : super(key: key);

  @override
  State<InsightScreen> createState() => _InsightScreenState();
}

class _InsightScreenState extends State<InsightScreen> {
  bool _isLoaded = false;
  bool _showScrollButtons = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    final bool isAtBottom =
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
    final bool isAtTop = _scrollController.position.pixels == 0;
    setState(() {
      _showScrollButtons = !isAtBottom && !isAtTop;
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
    );
  }

  Future<void> _precacheAssets() async {
    await precacheImage(const AssetImage('assets/images/others/whoweare.png'), context);
    await precacheImage(const AssetImage('assets/icons/whoweare.png'), context);
    setState(() => _isLoaded = true);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isLoaded) _precacheAssets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 66),
        child: Header(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              Column(
                children: [
                  SizedBox(
                    height: constraints.maxHeight / 2,
                    child: const FixedImageSlider(),
                  ),
                  Expanded(child: Container(color: Colors.black)),
                ],
              ),
              _buildContentLayer(),
              if (_showScrollButtons) _buildScrollButtons(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentLayer() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: AnimationLimiter(
        child: ListView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(top: 10),
          children: AnimationConfiguration.toStaggeredList(
            duration: const Duration(milliseconds: 600),
            childAnimationBuilder: (widget) => SlideAnimation(
              verticalOffset: 50.0,
              curve: Curves.easeInOutCubic,
              child: FadeInAnimation(
                curve: Curves.easeInOutCirc,
                child: widget,
              ),
            ),
            children: [
              const InsightsHead(),
              const IndustryTrendsBlock(),
            const MissionBlock(),
              const VisionBlock(),
              Footer(
                g1: Color.fromARGB(255, 5, 11, 13),
                g2: Color.fromARGB(255, 4, 6, 9),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollButtons() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        children: [
          ScaleTransition(
            scale: CurvedAnimation(
              parent: AlwaysStoppedAnimation(_showScrollButtons ? 1.0 : 0.0),
              curve: Curves.elasticOut,
            ),
            child: FloatingActionButton(
              onPressed: _scrollToTop,
                  backgroundColor: AppColors.scroll,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),
          ScaleTransition(
            scale: CurvedAnimation(
              parent: AlwaysStoppedAnimation(_showScrollButtons ? 1.0 : 0.0),
              curve: Curves.elasticOut,
            ),
            child: FloatingActionButton(
              onPressed: _scrollToBottom,
                  backgroundColor: AppColors.scroll,
              child: const Icon(Icons.arrow_downward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
class FixedImageSlider extends StatefulWidget {
  const FixedImageSlider({Key? key}) : super(key: key);

  @override
  _FixedImageSliderState createState() => _FixedImageSliderState();
}

class _FixedImageSliderState extends State<FixedImageSlider> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int _cycleCount = 0;
  bool _stopSlideshow = false;
  double _overlayOpacity = 0.5; // Initial overlay opacity
  Timer? _timer;

  // List of image assets to display.
  final List<String> _images = [
    'assets/images/insights/insights1.png',
    'assets/images/insights/insights4.png',

    'assets/images/insights/insights2.png',
  ];

  @override
  void initState() {
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow() {
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < _images.length - 1) {
        _currentPage++;
      } else {
        // When reaching the last image, reset to first and count cycles.
        _currentPage = 0;
        _cycleCount++;

        // After 2 full cycles, stop and change overlay opacity.
        if (_cycleCount >= 2) {
          _stopSlideshow = true;
          _overlayOpacity = 0.8; // Darken overlay when stopping
          setState(() {});
          timer.cancel();
          return;
        }
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            physics: _stopSlideshow ? const NeverScrollableScrollPhysics() : null,
            itemCount: _images.length,
            itemBuilder: (context, index) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 1000),
                child: Image.asset(
                  _images[index],
                  key: ValueKey(_images[index]),
                  fit: BoxFit.cover, // Ensures full width and height
                  width: double.infinity,
                  height: double.infinity,
                ),
              );
            },
          ),
          // Overlay the screen with dynamic opacity
          AnimatedOpacity(
            duration: const Duration(milliseconds: 800),
            opacity: _stopSlideshow ? _overlayOpacity : 0.5, // Changes to 0.8 when stopped
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}