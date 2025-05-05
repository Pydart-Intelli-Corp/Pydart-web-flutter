import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/screen/Insights/blocks/IndustryTrend.dart';
import 'package:flutter_website/screen/Insights/blocks/mission.dart';
import 'package:flutter_website/screen/Insights/blocks/vision.dart';
import 'package:flutter_website/screen/home/blocks/breif.dart';  // Import for Brief
import 'package:flutter_website/screen/home/blocks/service_background.dart';
import 'package:flutter_website/screen/home/blocks/start.dart';

import 'package:flutter_website/screen/services/blocks/features.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';

// Image list
final List<String> _images = [
  'https://images.unsplash.com/photo-1510519138101-570d1dca3d66?q=80&w=2047&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1542315192-1f61a1792f33?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1661347561213-21aad3b49b61?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1615746363486-92cd8c5e0a90?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1626785774625-ddcddc3445e9?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1603566234966-63aff3736a36?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1553877522-43269d4ea984?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
];

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

// Simple enum to track scroll direction
enum ScrollDirection { up, down, idle }

// Class to track scroll position and direction
class ScrollTracker {
  ScrollDirection _direction = ScrollDirection.idle;
  double _lastScrollPosition = 0;
  
  ScrollDirection get direction => _direction;
  
  void updateDirection(ScrollController controller) {
    final currentPosition = controller.position.pixels;
    
    if (currentPosition > _lastScrollPosition) {
      if (_direction != ScrollDirection.down) {
        _direction = ScrollDirection.down;
      }
    } else if (currentPosition < _lastScrollPosition) {
      if (_direction != ScrollDirection.up) {
        _direction = ScrollDirection.up;
      }
    }
    
    _lastScrollPosition = currentPosition;
  }
}

// Let's modify the HomeScreen to include our scroll animations
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoaded = false;
  bool _showScrollButtons = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _imageVisibilityController;
  late double _imageHideThreshold;
  final GlobalKey _aiBlockKey = GlobalKey();
  final GlobalKey _briefKey = GlobalKey();
  int _currentContentIndex = 0;
  void _handleSwipeLeft() => _sliderKey.currentState?.nextImage();
  void _handleSwipeRight() => _sliderKey.currentState?.previousImage();
  final GlobalKey<_AnimatedImageSliderState> _sliderKey = GlobalKey();
  
  // Add scroll tracking
  final ScrollTracker _scrollTracker = ScrollTracker();
  ScrollDirection _currentScrollDirection = ScrollDirection.idle;
  
  // Keep your existing content lists
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
      value: 1.0, // Start visible
    );
  }

  void _handleScroll() {
    final bool isAtBottom =
        _scrollController.position.pixels == _scrollController.position.maxScrollExtent;
    final bool isAtTop = _scrollController.position.pixels == 0;
    
    // Update scroll direction tracking
    _scrollTracker.updateDirection(_scrollController);
    
    setState(() {
      _showScrollButtons = !isAtBottom && !isAtTop;
      _currentScrollDirection = _scrollTracker.direction;
    });

    // Handle image visibility based on scroll position
    if (_scrollController.position.pixels >= _imageHideThreshold) {
      _imageVisibilityController.reverse(); // Hide image
    } else {
      _imageVisibilityController.forward(); // Show image
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate the threshold (1/4 of screen height) after the layout is complete
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
              // Background with animated visibility
              FadeTransition(
                opacity: _imageVisibilityController,
                child: Column(
                  children: [
                    SizedBox(
                      height: constraints.maxHeight / 2,
                      child: AnimatedImageSlider(
                        key: _sliderKey,
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

  // Updated content layer with scroll animations
  Widget _buildContentLayer() {
    return ScrollConfiguration(
      behavior: NoGlowScrollBehavior(),
      child: ListView(
        controller: _scrollController,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(top: 10),
        children: [
          // HomeHead doesn't need scroll animation
          HomeHead(
            onIndicatorTapped: (index) => _sliderKey.currentState?.goToImage(index),
            onExploreNowPressed: _scrollToBrief,
            title: _contentTitles[_currentContentIndex],
            subtitle: _contentSubtitles[_currentContentIndex],
            currentIndex: _currentContentIndex,
            totalItems: _images.length,
            onSwipeLeft: () => _sliderKey.currentState?.nextImage(),
            onSwipeRight: () => _sliderKey.currentState?.previousImage(),
          ),
          
          // Apply scroll animations to other widgets
          ScrollAnimatedItem(
            direction: _currentScrollDirection,
            child: Brief(key: _briefKey),
          ),
          
          ScrollAnimatedItem(
            direction: _currentScrollDirection,
            child: ServicesBlock(key: _aiBlockKey),
          ),
          
          ScrollAnimatedItem(
            direction: _currentScrollDirection,
            child: const IndustryTrendsBlock(),
          ),
          
          ScrollAnimatedItem(
            direction: _currentScrollDirection,
            child: const MissionBlock(),
          ),
          
          ScrollAnimatedItem(
            direction: _currentScrollDirection,
            child: const VisionBlock(),
          ),
          
          // Footer doesn't need animation
          Footer(
            g1: const Color.fromARGB(255, 5, 11, 13),
            g2: const Color.fromARGB(255, 4, 6, 9),
          ),
        ],
      ),
    );
  }

  // Keep your existing methods
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

  void _scrollToAIBlock() {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double estimatedPosition = 0;
    
    if (isMobile) {
      estimatedPosition = 1200;
    } else {
      final context = _aiBlockKey.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        estimatedPosition = position.dy - 66.0;
      } else {
        estimatedPosition = 1000;
      }
    }
    
    _scrollController.animateTo(
      estimatedPosition,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOutQuart,
    );
  }

  void _scrollToBrief() {
    bool isMobile = MediaQuery.of(context).size.width < 600;
    double estimatedPosition = 0;
    
    if (isMobile) {
      estimatedPosition = 600;
    } else {
      final context = _briefKey.currentContext;
      if (context != null) {
        final RenderBox renderBox = context.findRenderObject() as RenderBox;
        final position = renderBox.localToGlobal(Offset.zero);
        estimatedPosition = position.dy - 66.0;
      } else {
        estimatedPosition = 500;
      }
    }
    
    _scrollController.animateTo(
      estimatedPosition,
      duration: const Duration(milliseconds: 1500),
      curve: Curves.easeInOutQuart,
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

// Custom animated item that responds to scroll direction
class ScrollAnimatedItem extends StatefulWidget {
  final Widget child;
  final ScrollDirection direction;
  final Duration duration;
  
  const ScrollAnimatedItem({
    Key? key,
    required this.child,
    required this.direction,
    this.duration = const Duration(milliseconds: 500),
  }) : super(key: key);
  
  @override
  State<ScrollAnimatedItem> createState() => _ScrollAnimatedItemState();
}

class _ScrollAnimatedItemState extends State<ScrollAnimatedItem> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutQuad)
    );
    
    _updateSlideAnimation();
    
    // Only start animation if initially scrolling down
    if (widget.direction == ScrollDirection.down) {
      _controller.forward();
    } else {
      // Skip animation for other directions
      _controller.value = 1.0;
    }
  }
  
  @override
  void didUpdateWidget(ScrollAnimatedItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only trigger animation reset if changing to scrolling down
    if (oldWidget.direction != widget.direction && widget.direction == ScrollDirection.down) {
      _controller.reset();
      _updateSlideAnimation();
      _controller.forward();
    }
  }
  
  void _updateSlideAnimation() {
    Offset beginOffset;
    
    switch (widget.direction) {
      case ScrollDirection.down:
        beginOffset = const Offset(0.0, 0.2); // Slide from bottom
        break;
      case ScrollDirection.up:
      case ScrollDirection.idle:
      default:
        beginOffset = Offset.zero; // No animation for scrolling up
        break;
    }
    
    _slideAnimation = Tween<Offset>(
      begin: beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
    );
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}
class AnimatedImageSlider extends StatefulWidget {
  // Add these
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final ValueChanged<int>? onIndexChanged;

  const AnimatedImageSlider({
    super.key,
    this.onIndexChanged,
    this.onSwipeLeft,
    this.onSwipeRight,
  });

  @override
  _AnimatedImageSliderState createState() => _AnimatedImageSliderState();
}

class _AnimatedImageSliderState extends State<AnimatedImageSlider> {
  Timer? _userInteractionTimer;
  bool _cycleCompleted = false;
  bool _showSwipePrompt = false;
  final Random _random = Random();
  late Timer _timer;
  int _currentIndex = 0;
  int _transitionType = 0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _transitionType = _random.nextInt(5);
        _currentIndex = (_currentIndex + 1) % _images.length;
        widget.onIndexChanged?.call(_currentIndex);
      });
      
      if (_currentIndex == 0) {
        timer.cancel();
        setState(() {
          _cycleCompleted = true;
          _showSwipePrompt = true;
        });
        // Show prompt for 3 seconds
        Future.delayed(const Duration(seconds: 3), () {
          setState(() => _showSwipePrompt = false);
        });
      }
    });
  }

  void nextImage() {
    if (!_cycleCompleted) return;
    setState(() {
      _transitionType = _random.nextInt(5);
      _currentIndex = (_currentIndex + 1) % _images.length;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void goToImage(int index) {
    if (index < 0 || index >= _images.length) return;
    setState(() {
      _transitionType = _random.nextInt(5);
      _currentIndex = index;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void previousImage() {
    if (!_cycleCompleted) return;
    setState(() {
      _transitionType = _random.nextInt(5);
      _currentIndex = (_currentIndex - 1) % _images.length;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void _startReturnTimer() {
    _userInteractionTimer?.cancel();
    _userInteractionTimer = Timer(const Duration(seconds: 7), () {
      if (_currentIndex != 0 && mounted) {
        setState(() {
          _transitionType = _random.nextInt(5);
          _currentIndex = 0;
          widget.onIndexChanged?.call(_currentIndex);
        });
      }
    });
  }

  @override
  void dispose() {
    _userInteractionTimer?.cancel();
    _timer.cancel();
    super.dispose();
  }

  void _handleManualInteraction() {
    _timer?.cancel(); // Cancel existing automatic timer
    _startReturnTimer();
    // Restart automatic cycling after manual interaction
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _transitionType = _random.nextInt(5);
        _currentIndex = (_currentIndex + 1) % _images.length;
        widget.onIndexChanged?.call(_currentIndex);
      });
    });
    setState(() => _showSwipePrompt = false);
  }

  Widget _buildTransition(Widget child, Animation<double> animation) {
    switch (_transitionType) {
      case 0:
        return FadeTransition(opacity: animation, child: child);
      case 1:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
      case 2:
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.9, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack),
            ),
            child: child,
          ),
        );
      case 3:
        return RotationTransition(
          turns: Tween<double>(begin: -0.1, end: 0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeInOutSine),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      default:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeInQuad)),
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
  
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) nextImage();
        if (details.primaryVelocity! > 0) previousImage();
      },
      child: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 800),
            transitionBuilder: _buildTransition,
            child: Container(
              key: ValueKey<int>(_currentIndex),
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
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showSwipePrompt ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isMobile)
                    const Text(
                      "Swipe to view more",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        shadows: [Shadow(color: Colors.black54, blurRadius: 10)],
                      ),
                    ),
                  if (!isMobile)
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 40),
                          onPressed: previousImage,
                        ),
                        const SizedBox(width: 20),
                        IconButton(
                          icon: const Icon(Icons.arrow_forward, color: Colors.white, size: 40),
                          onPressed: nextImage,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class ScrollDirectionListener extends ChangeNotifier {
  ScrollDirection _direction = ScrollDirection.idle;
  double _lastScrollPosition = 0;
  
  ScrollDirection get direction => _direction;
  
  void updateScrollDirection(ScrollController controller) {
    final currentPosition = controller.position.pixels;
    
    if (currentPosition > _lastScrollPosition) {
      if (_direction != ScrollDirection.down) {
        _direction = ScrollDirection.down;
        notifyListeners();
      }
    } else if (currentPosition < _lastScrollPosition) {
      if (_direction != ScrollDirection.up) {
        _direction = ScrollDirection.up;
        notifyListeners();
      }
    }
    
    _lastScrollPosition = currentPosition;
  }
}
