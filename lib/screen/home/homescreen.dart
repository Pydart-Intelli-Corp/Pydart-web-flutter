import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/screen/home/blocks/breif.dart';
import 'package:flutter_website/screen/home/blocks/service_background.dart';
import 'package:flutter_website/screen/home/blocks/start.dart';

import 'package:flutter_website/screen/services/blocks/features.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';



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
class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  bool _isLoaded = false;
  bool _showScrollButtons = false;
  final ScrollController _scrollController = ScrollController();
  late AnimationController _imageVisibilityController;
  late double _imageHideThreshold;
 final GlobalKey _aiBlockKey = GlobalKey();
  int _currentContentIndex = 0;

    final GlobalKey<_AnimatedImageSliderState> _sliderKey = GlobalKey();

final List<String> _contentTitles = [
  "WELCOME TO PYDART INTELLI CORP",
  "CUSTOM SOFTWARE SOLUTIONS",
  "SMART HARDWARE INNOVATIONS",
  "PRECISION MECHANICAL WORKS",
  "IMPACTFUL CREATIVE DESIGNS",
  "STRATEGIC DIGITAL MARKETING",
  "SCHEDULE A FREE CONSULTATION!"
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

 late final List<String> _mobileSubtitles = [
    "Innovate. Integrate. Inspire.\n",
    "Tailored Web, Mobile & Enterprise Applications",      // unchanged
    "IoT, Embedded Systems & Intelligent Devices",         // unchanged
    "CAD, 3D Printing & Product Engineering\n",
    "UI/UX, Branding & Visual Identity\n",
    "Growth-Driven SEO, SMM & Campaigns\n",
    "Expert Guidance to Elevate Your Business\n"
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
    setState(() {
      _showScrollButtons = !isAtBottom && !isAtTop;
    });

    // Handle image visibility based on scroll position
    if (_scrollController.position.pixels >= _imageHideThreshold) {
      _imageVisibilityController.reverse(); // Hide image
    } else {
      _imageVisibilityController.forward(); // Show image
    }
  }
void _scrollToAIBlock() {
  // For mobile devices, use a more robust approach with estimated positions
  bool isMobile = MediaQuery.of(context).size.width < 600;
  
  // Get all children before AI block (HomeHead and Features)
  double estimatedPosition = 0;
  
  if (isMobile) {
    // On mobile, use coarser estimates since layouts might be different
    estimatedPosition = 1200; // Adjust based on your mobile layout
  } else {
    // On desktop, we can be more precise
    final context = _aiBlockKey.currentContext;
    if (context != null) {
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final position = renderBox.localToGlobal(Offset.zero);
      estimatedPosition = position.dy - 66.0; // Subtract app bar height
    } else {
      estimatedPosition = 1000; // Fallback estimate for desktop
    }
  }
  
  // Animate scroll with a bit of offset for better visibility
  _scrollController.animateTo(
    estimatedPosition,
    duration: const Duration(milliseconds: 800),
    curve: Curves.easeInOutQuart,
  );
  
  print('Scrolling to position: $estimatedPosition');
}
  // Other methods remain the same...

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Calculate the threshold (1/4 of screen height) after the layout is complete
    _imageHideThreshold = MediaQuery.of(context).size.height / 4;
   
  }

  @override
  void dispose() {
    _imageVisibilityController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      final bool isMobile = MediaQuery.of(context).size.width < 600;

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
                      height: constraints.maxHeight / 1.5,
                    child: AnimatedImageSlider(
                       key: _sliderKey, // Pass the key
                        onIndexChanged: (index) => setState(() => _currentContentIndex = index),
                      ),
                    ),
                    Expanded(child: Container(color: Colors.black)),
                  ],
                ),
              ),
_buildContentLayer(isMobile),
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

  Widget _buildContentLayer(bool isMobile) {
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
                // 3) pick the right subtitle list:
                subtitle: isMobile
                    ? _mobileSubtitles[_currentContentIndex]
                    : _contentSubtitles[_currentContentIndex],
                currentIndex: _currentContentIndex,
                totalItems: _images.length,
                onSwipeLeft: () => _sliderKey.currentState?.nextImage(),
                onSwipeRight: () => _sliderKey.currentState?.previousImage(),
              ),
              const Brief(),
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
  _startReturnTimer();
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
             
              ],
            ),
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
