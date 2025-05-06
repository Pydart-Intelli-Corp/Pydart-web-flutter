import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; // Added for rendering optimizations
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/screen/Insights/blocks/IndustryTrend.dart';
import 'package:flutter_website/screen/Insights/blocks/mission.dart';
import 'package:flutter_website/screen/Insights/blocks/vision.dart';
import 'package:flutter_website/screen/home/blocks/breif.dart';
import 'package:flutter_website/screen/home/blocks/service_background.dart';
import 'package:flutter_website/screen/home/blocks/start.dart';
import 'package:flutter_website/screen/services/blocks/features.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';

// Image list with better quality and compressed images
final List<String> _images = [
  'https://images.unsplash.com/photo-1510519138101-570d1dca3d66?q=80&w=2047&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1542315192-1f61a1792f33?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1661347561213-21aad3b49b61?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1615746363486-92cd8c5e0a90?q=80&w=2073&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1626785774625-ddcddc3445e9?q=80&w=2071&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1603566234966-63aff3736a36?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  'https://images.unsplash.com/photo-1553877522-43269d4ea984?q=80&w=2070&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D'
];

// Improved scroll physics for smoother scrolling
class OptimizedScrollPhysics extends ScrollPhysics {
  const OptimizedScrollPhysics({ScrollPhysics? parent}) 
      : super(parent: parent);

  @override
  OptimizedScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return OptimizedScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double get dragStartDistanceMotionThreshold => 3.5; // More responsive

  @override
  double frictionFactor(double overscrollFraction) => 0.15; // Lower friction

  @override
  SpringDescription get spring => const SpringDescription(
    mass: 80,
    stiffness: 100,
    damping: 1,
  );
  
  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    if (offset == 0.0) return 0.0;
    return offset * 0.9; // Slightly reduce sensitivity for smoother feel
  }
}

// Enhanced scroll behavior with no glow effect
class EnhancedScrollBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
  
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const OptimizedScrollPhysics();
  }
  
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

// Simple enum to track scroll direction
enum ScrollDirection { up, down, idle }

// Improved class to track scroll position and direction with better performance
class ScrollTracker {
  ScrollDirection _direction = ScrollDirection.idle;
  double _lastScrollPosition = 0;
  double _lastUpdateTime = 0;
  
  ScrollDirection get direction => _direction;
  
  void updateDirection(ScrollController controller) {
    final currentTime = DateTime.now().millisecondsSinceEpoch.toDouble();
    // Don't update too frequently (throttle updates for performance)
    if (currentTime - _lastUpdateTime < 16) { // ~60fps
      return;
    }
    
    final currentPosition = controller.position.pixels;
    final double difference = currentPosition - _lastScrollPosition;
    final double threshold = 1.0; // Small threshold to prevent jitter
    
    if (difference > threshold) {
      if (_direction != ScrollDirection.down) {
        _direction = ScrollDirection.down;
      }
    } else if (difference < -threshold) {
      if (_direction != ScrollDirection.up) {
        _direction = ScrollDirection.up;
      }
    }
    
    _lastScrollPosition = currentPosition;
    _lastUpdateTime = currentTime;
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
  final GlobalKey _briefKey = GlobalKey();
  int _currentContentIndex = 0;
  final GlobalKey<_AnimatedImageSliderState> _sliderKey = GlobalKey();
  
  // Add scroll tracking with improved performance
  final ScrollTracker _scrollTracker = ScrollTracker();
  ScrollDirection _currentScrollDirection = ScrollDirection.idle;
  
  // Keep content lists
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

  // Performance-optimized cache for widgets
  final Map<int, Widget> _cachedWidgets = {};

  @override
  void initState() {
    super.initState();
    
    // Schedule tasks in the right order for better performance
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _precacheAssets();
    });
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.addListener(_handleScroll);
    });
    
    _imageVisibilityController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: 1.0, // Start visible
    );
  }

  // Optimized scroll handler with debouncing
  int _lastHandleScrollTime = 0;
  void _handleScroll() {
    // Throttle updates to improve performance
    final now = DateTime.now().millisecondsSinceEpoch;
    if (now - _lastHandleScrollTime < 16) { // ~60fps
      return;
    }
    _lastHandleScrollTime = now;
    
    final bool isAtBottom =
        _scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 20;
    final bool isAtTop = _scrollController.position.pixels <= 20;
    
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

  // Improved image precaching for better performance
  Future<void> _precacheAssets() async {
    // Create a list of precache futures
    final List<Future<void>> precacheFutures = [];
    
    // Add all network images to precache
    for (String imageUrl in _images) {
      precacheFutures.add(precacheImage(NetworkImage(imageUrl), context));
    }
    
    // Add local assets to precache
    precacheFutures.add(precacheImage(const AssetImage('assets/images/others/whoweare.png'), context));
    precacheFutures.add(precacheImage(const AssetImage('assets/icons/whoweare.png'), context));
    
    // Wait for all precaching to complete
    await Future.wait(precacheFutures);
    
    if (mounted) {
      setState(() => _isLoaded = true);
    }
  }

  @override
  void dispose() {
    _imageVisibilityController.dispose();
    _scrollController.removeListener(_handleScroll);
    _scrollController.dispose();
    _cachedWidgets.clear();
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

  // Optimized content layer with smooth scrolling
  Widget _buildContentLayer() {
    // Use cached widgets if available for better performance
    final homeHead = HomeHead(
      onIndicatorTapped: (index) => _sliderKey.currentState?.goToImage(index),
      onExploreNowPressed: _scrollToBrief,
      title: _contentTitles[_currentContentIndex],
      subtitle: _contentSubtitles[_currentContentIndex],
      currentIndex: _currentContentIndex,
      totalItems: _images.length,
      onSwipeLeft: () => _sliderKey.currentState?.nextImage(),
      onSwipeRight: () => _sliderKey.currentState?.previousImage(),
    );

    return ScrollConfiguration(
      behavior: EnhancedScrollBehavior(),
      child: CustomScrollView(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(
          parent: ClampingScrollPhysics(),
        ),
        cacheExtent: 500, // Increase cache for smoother scrolling
        slivers: [
          SliverToBoxAdapter(
            child: homeHead,
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(1, () => 
              AnimatedSmoothScrollItem(
                direction: _currentScrollDirection,
                child: RepaintBoundary(
                  child: Brief(key: _briefKey),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(2, () => 
              AnimatedSmoothScrollItem(
                direction: _currentScrollDirection,
                child: RepaintBoundary(
                  child: EnterpriseServicesBlock(key: _aiBlockKey),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(3, () => 
              AnimatedSmoothScrollItem(
                direction: _currentScrollDirection,
                child: RepaintBoundary(
                  child: const IndustryTrendsBlock(),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(4, () => 
              AnimatedSmoothScrollItem(
                direction: _currentScrollDirection,
                child: RepaintBoundary(
                  child: const MissionBlock(),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(5, () => 
              AnimatedSmoothScrollItem(
                direction: _currentScrollDirection,
                child: RepaintBoundary(
                  child: const VisionBlock(),
                ),
              )
            ),
          ),
          SliverToBoxAdapter(
            child: _getCachedWidget(6, () => 
              Footer(
                g1: const Color.fromARGB(255, 5, 11, 13),
                g2: const Color.fromARGB(255, 4, 6, 9),
              )
            ),
          ),
        ],
      ),
    );
  }

  // Optimized widget caching for better performance
  Widget _getCachedWidget(int index, Widget Function() builder) {
    _cachedWidgets[index] ??= builder();
    return _cachedWidgets[index]!;
  }

  // Optimized scroll animations
  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic, // Changed for smoother feel
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic, // Changed for smoother feel
    );
  }

  void _scrollToAIBlock() {
    final isMobile = MediaQuery.of(context).size.width < 600;
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
      curve: Curves.easeOutCubic, // Changed for smoother feel
    );
  }

  void _scrollToBrief() {
    final isMobile = MediaQuery.of(context).size.width < 600;
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
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic, // Changed for smoother feel
    );
  }

  // Optimized floating action buttons with smoother animations
  Widget _buildScrollButtons() {
    return Positioned(
      bottom: 30,
      right: 30,
      child: Column(
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0.0,
              end: _showScrollButtons ? 1.0 : 0.0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
            child: FloatingActionButton(
              onPressed: _scrollToTop,
              backgroundColor: AppColors.scroll,
              child: const Icon(Icons.arrow_upward, color: Colors.white),
            ),
          ),
          const SizedBox(height: 15),
          TweenAnimationBuilder(
            tween: Tween<double>(
              begin: 0.0,
              end: _showScrollButtons ? 1.0 : 0.0,
            ),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: child,
              );
            },
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

// Optimized animated scroll item with better performance
class AnimatedSmoothScrollItem extends StatefulWidget {
  final Widget child;
  final ScrollDirection direction;
  final Duration duration;
  
  const AnimatedSmoothScrollItem({
    Key? key,
    required this.child,
    required this.direction,
    this.duration = const Duration(milliseconds: 400), // Reduced for better performance
  }) : super(key: key);
  
  @override
  State<AnimatedSmoothScrollItem> createState() => _AnimatedSmoothScrollItemState();
}

class _AnimatedSmoothScrollItemState extends State<AnimatedSmoothScrollItem> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isVisible = false;
  
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic)
    );
    
    _updateSlideAnimation();
    
    // Skip animation for initial build to improve performance
    _controller.value = 1.0;
    _isVisible = true;
  }
  
  @override
  void didUpdateWidget(AnimatedSmoothScrollItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Only animate when scrolling down and widget not yet visible
    if (!_isVisible && widget.direction == ScrollDirection.down) {
      _controller.reset();
      _updateSlideAnimation();
      _controller.forward().then((_) {
        _isVisible = true;
      });
    }
  }
  
  void _updateSlideAnimation() {
    // Only apply slide animation when scrolling down
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.15), // Reduced offset for smoother animation
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
    // Skip animations if already visible
    if (_isVisible) {
      return widget.child;
    }
    
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}

// Optimized image slider with better performance
class AnimatedImageSlider extends StatefulWidget {
  final ValueChanged<int>? onIndexChanged;

  const AnimatedImageSlider({
    super.key,
    this.onIndexChanged,
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
  
  // Precached images for better performance
  final Map<String, NetworkImage> _precachedImages = {};

  @override
  void initState() {
    super.initState();
    
    // Preload all images for smoother transitions
    for (final imageUrl in _images) {
      _precachedImages[imageUrl] = NetworkImage(imageUrl);
    }
    
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _transitionType = _random.nextInt(2); // Reduced variety for better performance
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
          if (mounted) {
            setState(() => _showSwipePrompt = false);
          }
        });
      }
    });
  }

  void nextImage() {
    if (!_cycleCompleted) return;
    setState(() {
      _transitionType = _random.nextInt(2); // Reduced variety for better performance
      _currentIndex = (_currentIndex + 1) % _images.length;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void goToImage(int index) {
    if (index < 0 || index >= _images.length) return;
    setState(() {
      _transitionType = _random.nextInt(2); // Reduced variety for better performance
      _currentIndex = index;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void previousImage() {
    if (!_cycleCompleted) return;
    setState(() {
      _transitionType = _random.nextInt(2); // Reduced variety for better performance
      _currentIndex = (_currentIndex - 1 + _images.length) % _images.length;
      widget.onIndexChanged?.call(_currentIndex);
    });
    _handleManualInteraction();
  }

  void _startReturnTimer() {
    _userInteractionTimer?.cancel();
    _userInteractionTimer = Timer(const Duration(seconds: 7), () {
      if (_currentIndex != 0 && mounted) {
        setState(() {
          _transitionType = _random.nextInt(2); // Reduced variety for better performance
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
    _precachedImages.clear();
    super.dispose();
  }

  void _handleManualInteraction() {
    _timer.cancel(); // Cancel existing automatic timer
    _startReturnTimer();
    
    // Restart automatic cycling after manual interaction with reduced frequency
    _timer = Timer.periodic(const Duration(seconds: 7), (timer) {
      if (mounted) {
        setState(() {
          _transitionType = _random.nextInt(2); // Reduced variety for better performance
          _currentIndex = (_currentIndex + 1) % _images.length;
          widget.onIndexChanged?.call(_currentIndex);
        });
      }
    });
    
    if (mounted) {
      setState(() => _showSwipePrompt = false);
    }
  }

  // Use simplified transitions for better performance
  Widget _buildTransition(Widget child, Animation<double> animation) {
    // Limit transition types to just two for better performance
    switch (_transitionType) {
      case 0:
        return FadeTransition(opacity: animation, child: child);
      default:
        return SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
          child: child,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < -500) nextImage(); // Only respond to fast swipes
        if (details.primaryVelocity! > 500) previousImage(); // Only respond to fast swipes
      },
      child: Stack(
        children: [
          // Use keyed widgets with optimized AnimatedSwitcher
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 600), // Reduced duration
            transitionBuilder: _buildTransition,
            layoutBuilder: (currentChild, previousChildren) {
              return Stack(
                children: <Widget>[
                  ...previousChildren,
                  if (currentChild != null) currentChild,
                ],
                alignment: Alignment.center,
              );
            },
            child: RepaintBoundary(
              key: ValueKey<int>(_currentIndex),
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: _precachedImages[_images[_currentIndex]] 
                        ?? NetworkImage(_images[_currentIndex]),
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
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: AnimatedOpacity(
              opacity: _showSwipePrompt ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 300), // Reduced duration
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
                      mainAxisAlignment: MainAxisAlignment.center,
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