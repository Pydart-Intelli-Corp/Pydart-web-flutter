import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_website/components/colors.dart';
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
                      child: const AnimatedImageSlider(),
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
             // In _buildContentLayer method:
HomeHead(onExploreNowPressed: _scrollToAIBlock),
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
              backgroundColor: Colors.blueGrey.withOpacity(0.8),
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
              backgroundColor: Colors.blueGrey.withOpacity(0.8),
              child: const Icon(Icons.arrow_downward, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedImageSlider extends StatefulWidget {
  const AnimatedImageSlider({Key? key}) : super(key: key);

  @override
  _AnimatedImageSliderState createState() => _AnimatedImageSliderState();
}

class _AnimatedImageSliderState extends State<AnimatedImageSlider> {
  final List<String> _images = [
    'assets/images/home/1.png',
    'assets/images/home/2.png',
    'assets/images/home/3.png',
  ];
  final Random _random = Random();
  int _currentIndex = 0;
  int _transitionType = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _nextImage();
    });
  }

void _nextImage() {
  setState(() {
    _transitionType = _random.nextInt(5); // Changed from 4 to 5
    _currentIndex = (_currentIndex + 1) % _images.length;
  });
}

void _previousImage() {
  setState(() {
    _transitionType = _random.nextInt(5); // Changed from 4 to 5
    _currentIndex = (_currentIndex - 1 + _images.length) % _images.length;
  });
}
Widget _buildTransition(Widget child, Animation<double> animation) {
  switch (_transitionType) {
    case 0:
      // Fade-in effect
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    case 1:
      // Previous case 0 - slide from right
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
        child: child,
      );
    case 2:
      // Previous case 1 - fade with scale
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.9, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
          child: child,
        ),
      );
    case 3:
      // Previous case 2 - rotation
      return RotationTransition(
        turns: Tween<double>(begin: -0.1, end: 0.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeInOutSine)),
        child: FadeTransition(
          opacity: animation,
          child: child,
        ),
      );
    default:
      // Previous default - slide from bottom
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeInQuad)),
        child: child,
      );
  }
}
  @override
  void dispose() {
    _timer?.cancel();
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
              key: ValueKey(_images[_currentIndex]),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(_images[_currentIndex]),
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
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_images.length, (index) => _buildIndicator(index)),
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
        color: _currentIndex == index ? Colors.blueAccent : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}