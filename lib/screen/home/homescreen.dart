import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/screen/home/blocks/service_background.dart';
import 'package:flutter_website/screen/home/blocks/start.dart';
import 'package:flutter_website/screen/services/blocks/features.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';

class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoaded = false;
  bool _showScrollButtons = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _imageVisibilityController;
  late double _imageHideThreshold;
  final GlobalKey _aiBlockKey = GlobalKey();
  int _currentContentIndex = 0;

  final List<String> _contentTitles = [
    "WELCOME TO PYDART INTELLI CORP",
    "CUSTOM SOFTWARE SOLUTIONS",
    "SMART HARDWARE INNOVATIONS",
    "PRECISION MECHANICAL DESIGNS",
    "IMPACTFUL CREATIVE DESIGNS",
    "STRATEGIC DIGITAL MARKETING",
    "SCHEDULE YOUR CONSULTATION"
  ];

  final List<String> _contentSubtitles = [
    "Innovate. Integrate. Inspire.",
    "Tailored Web, Mobile & Enterprise Applications",
    "IoT, Embedded Systems & Intelligent Devices",
    "CAD, 3D Printing & Product Engineering",
    "UI/UX, Branding & Visual Identity",
    "Growth-Driven SEO, SMM & Campaigns",
    "Expert Guidance to Elevate Your Business"
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _imageVisibilityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0,
    );
  }

  void _handleScroll() {
    final bool isAtBottom = _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
    final bool isAtTop = _scrollController.position.pixels == 0;
    setState(() {
      _showScrollButtons = !isAtBottom && !isAtTop;
    });

    if (_scrollController.position.pixels >= _imageHideThreshold) {
      _imageVisibilityController.reverse();
    } else {
      _imageVisibilityController.forward();
    }
  }

  void _scrollToAIBlock() {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double estimatedPosition = isMobile ? 1200 : 1000;
    _scrollController.animateTo(
      estimatedPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _imageHideThreshold = MediaQuery.of(context).size.height / 4;
    if (!_isLoaded) _precacheAssets();
  }

  @override
  void dispose() {
    _imageVisibilityController.dispose();
    _scrollController.dispose();
    super.dispose();
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
              FadeTransition(
                opacity: _imageVisibilityController,
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight / 2,
                      child: AnimatedImageSlider(
                        onIndexChanged: (index) => setState(() => _currentContentIndex = index),
                      ),
                    ),
                    Expanded(child: Container(color: Colors.black)),
                  ],
                ),
              ),
              _buildContentLayer(),
              if (_showScrollButtons) _buildScrollButtons(),
            ],
          );
        },
      ),
    );
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
              HomeHead(
                onExploreNowPressed: _scrollToAIBlock,
                title: _contentTitles[_currentContentIndex],
                subtitle: _contentSubtitles[_currentContentIndex],
              ),
              const Features(),
              ServicesBlock(key: _aiBlockKey),
              Footer(
                g1: const Color.fromARGB(255, 5, 11, 13),
                g2: const Color.fromARGB(255, 4, 6, 9),
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

class AnimatedImageSlider extends StatefulWidget {
  final ValueChanged<int>? onIndexChanged;

  const AnimatedImageSlider({Key? key, this.onIndexChanged}) : super(key: key);

  @override
  _AnimatedImageSliderState createState() => _AnimatedImageSliderState();
}

class _AnimatedImageSliderState extends State<AnimatedImageSlider> {
  final List<String> _images = [
    'https://images.unsplash.com/photo-1510519138101-570d1dca3d66?q=80&w=2047&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1634746419780-464e7ffcbb34?q=80&w=1974&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1576400883215-7083980b6193?q=80&w=2013&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1581092921461-eab62e97a780?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1517420704952-d9f39e95b43e?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1522071820081-009f0129c71c?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
    'https://images.unsplash.com/photo-1650530415027-dc9199f473ec?q=80&w=1933&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
  ];

  final Random _random = Random();
  late Timer _cycleTimer;
  int _currentIndex = 0;
  int _transitionType = 0;
  bool _autoCycleDone = false;
  Timer? _inactivityTimer;
  bool _showArrows = false;

  @override
  void initState() {
    super.initState();
    _startAutoCycle();
  }

  void _startAutoCycle() {
    _cycleTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _transitionType = _random.nextInt(5);
        _currentIndex = (_currentIndex + 1) % _images.length;
        widget.onIndexChanged?.call(_currentIndex);
      });
      
      if (_currentIndex == _images.length - 1) {
        timer.cancel();
        _cycleTimer = Timer(const Duration(seconds: 5), () {
          setState(() {
            _transitionType = _random.nextInt(5);
            _currentIndex = 0;
            widget.onIndexChanged?.call(_currentIndex);
            _autoCycleDone = true;
            _showArrows = true;
          });
        });
      }
    });
  }

  void _resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(const Duration(seconds: 7), () {
      if (_currentIndex != 0) {
        setState(() {
          _transitionType = _random.nextInt(5);
          _currentIndex = 0;
          widget.onIndexChanged?.call(_currentIndex);
          _showArrows = false;
        });
        _startAutoCycle();
      }
    });
  }
  void _nextImage() {
    if (_currentIndex < _images.length - 1) {
      setState(() {
        _transitionType = _random.nextInt(5);
        _currentIndex++;
        widget.onIndexChanged?.call(_currentIndex);
      });
      _resetInactivityTimer();  // Moved inside setState callback
    }
  }

  void _previousImage() {
    if (_currentIndex > 0) {
      setState(() {
        _transitionType = _random.nextInt(5);
        _currentIndex--;
        widget.onIndexChanged?.call(_currentIndex);
      });
      _resetInactivityTimer();  // Moved inside setState callback
    }
  }


  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (_transitionType) {
      case 0: return FadeTransition(opacity: animation, child: child);
      case 1: return SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
      case 2: return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
          ),
          child: child,
        ),
      );
      case 3: return RotationTransition(
        turns: Tween<double>(begin: -0.1, end: 0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutSine),
        ),
        child: FadeTransition(opacity: animation, child: child),
      );
      default: return SlideTransition(
        position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
            .animate(CurvedAnimation(parent: animation, curve: Curves.easeInQuad)),
        child: child,
      );
    }
  }

  @override
  void dispose() {
    _cycleTimer.cancel();
    _inactivityTimer?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) _nextImage();
        if (details.primaryVelocity! > 0) _previousImage();
      },
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: _buildTransition,
            child: Container(
              key: ValueKey<int>(_currentIndex),  // Ensure unique key
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(_images[_currentIndex]),
                  fit: BoxFit.cover,
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.7),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
             Positioned.fill(
            child: IgnorePointer(
              ignoring: !_showArrows,
              child: AnimatedOpacity(
                opacity: _showArrows ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 500),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 40),
                      onPressed: () => _previousImage(),
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 40),
                      onPressed: () => _nextImage(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, _buildIndicator),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: _currentIndex == index ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: _currentIndex == index
            ? Colors.blueAccent
            : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}