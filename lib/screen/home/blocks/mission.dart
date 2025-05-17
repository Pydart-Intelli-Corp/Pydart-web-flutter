import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math' as math;
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:pydart/components/icons.dart';
import 'package:pydart/components/spacing.dart';
import 'package:pydart/components/colors.dart';
import 'package:pydart/core/extensions/color_extensions.dart';

class MissionBlock extends StatefulWidget {
  const MissionBlock({super.key});

  @override
  State<MissionBlock> createState() => _MissionBlockState();
}

class _MissionBlockState extends State<MissionBlock> with TickerProviderStateMixin {
  // Multiple animation controllers for complex effects
  late AnimationController _mainController;
  late AnimationController _cardAnimController;
  late AnimationController _pulseController;
  late AnimationController _backgroundAnimController;
  late AnimationController _imageFadeController;
  late AnimationController _headerImageFadeController;

  // Animation sequences
  late Animation<double> _fadeInAnimation;
  late Animation<double> _slideUpAnimation;
  late Animation<double> _imageFadeAnimation;
  late Animation<double> _headerImageFadeAnimation;
  
  // Track interactions
  int? _hoveredIndex;
  int _selectedIndex = 0; // Vision is initially selected (index 0)
  bool _isHeaderHovered = false;
  
  // Image rotation tracking
  int _currentHeaderImageIndex = 0;
  Map<int, int> _currentValueImageIndices = {};
  Timer? _headerImageRotationTimer;
  Map<int, Timer?> _valueImageRotationTimers = {};
  
  // Enhanced breakpoints for better responsiveness
  static const double kMobileBreakpoint = 480;
  static const double kTabletBreakpoint = 768;
  static const double kDesktopBreakpoint = 1024;
  static const double kLargeDesktopBreakpoint = 1366;
  static const double kUltraWideBreakpoint = 1920;
  
  // Header background images (rotating)
  final List<String> _headerImages = [
    'https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?q=80&w=1170&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1497366754035-f200968a6e72?q=80&w=1169&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1497215842964-222b430dc094?q=80&w=1170&auto=format&fit=crop',
    'https://images.unsplash.com/photo-1565301660306-29e08751cc53?q=80&w=1170&auto=format&fit=crop',
  ];
  
  // Realistic values and realistic imagery - using network images with multiple images per value
  final List<Map<String, dynamic>> missionValues = [
    {
      'id': 'vision',
      'icon': 'https://cdn-icons-png.flaticon.com/512/1040/1040230.png',
      'title': 'Vision',
      'subtitle': 'Shaping the future',
      'description': 'We envision a world where technology seamlessly enhances human potential, creating sustainable prosperity and transforming industries through ethical innovation.',
      'images': [
        'https://images.unsplash.com/photo-1432888622747-4eb9a8f5a70d?q=80&w=1170&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1520607162513-77705c0f0d4a?q=80&w=1169&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1518770660439-4636190af475?q=80&w=1170&auto=format&fit=crop',
      ],
      'keyMetric': '2030 Strategic Vision',
      'keyMetricValue': '85% progress',
      'color': Color(0xFF3162C4),
      'actions': ['Long-term planning', 'Industry foresight', 'Future-proofing solutions'],
      'quote': {
        'text': 'Our vision allows us to anticipate market shifts years before they happen.',
        'author': 'Dr. Michael Chen, Chief Strategy Officer',
        'image': 'https://images.unsplash.com/photo-1560250097-0b93528c311a?q=80&w=687&auto=format&fit=crop',
      },
    },
    {
      'id': 'excellence',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3176/3176388.png',
      'title': 'Excellence',
      'subtitle': 'Setting the standard',
      'description': 'We relentlessly pursue perfection in everything we do, from breakthrough engineering to meticulous client service, establishing benchmarks that elevate entire industries.',
      'images': [
        'https://images.unsplash.com/photo-1542744173-8e7e53415bb0?q=80&w=1170&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1484156818044-c040038b0719?q=80&w=1170&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1460794418188-1bb7dba2720d?q=80&w=1170&auto=format&fit=crop',
      ],
      'keyMetric': 'Quality Assurance',
      'keyMetricValue': '99.98%',
      'color': Color(0xFF1D7874),
      'actions': ['Rigorous testing', 'Process optimization', 'Continuous improvement'],
      'quote': {
        'text': "Excellence isn't an act but a habit built through thousands of conscious decisions.",
        'author': 'Sarah Williams, VP of Engineering',
        'image': 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?q=80&w=688&auto=format&fit=crop',
      },
    },
    {
      'id': 'integrity',
      'icon': 'https://cdn-icons-png.flaticon.com/512/3176/3176293.png',
      'title': 'Integrity',
      'subtitle': 'Trust through transparency',
      'description': 'We operate with unwavering ethical standards, ensuring every business decision reflects our commitment to honesty, accountability, and long-term trusted partnerships.',
      'images': [
        'https://images.unsplash.com/photo-1553484771-371a605b060b?q=80&w=1170&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1521791136064-7986c2920216?q=80&w=1169&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1535476245374-b24b5efd2aa5?q=80&w=1170&auto=format&fit=crop',
      ],
      'keyMetric': 'Client Retention',
      'keyMetricValue': '96.7%',
      'color': Color(0xFF714955),
      'actions': ['Ethical governance', 'Radical transparency', 'Sustainable practices'],
      'quote': {
        'text': 'When faced with difficult decisions, integrity is our cornerstone and our compass.',
        'author': 'Jennifer Martinez, Chief Ethics Officer',
        'image': 'https://images.unsplash.com/photo-1580894732444-8ecded7900cd?q=80&w=1170&auto=format&fit=crop',
      },
    },
    {
      'id': 'innovation',
      'icon': 'https://cdn-icons-png.flaticon.com/512/2427/2427451.png',
      'title': 'Innovation',
      'subtitle': 'Pioneering possibilities',
      'description': 'We challenge conventional thinking and embrace calculated risks to develop breakthrough solutions that create unprecedented value and open new frontiers for our clients.',
      'images': [
        'https://images.unsplash.com/photo-1523961131990-5ea7c61b2107?q=80&w=1074&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1511376979163-f804dff7ad7b?q=80&w=1287&auto=format&fit=crop',
        'https://images.unsplash.com/photo-1485827404703-89b55fcc595e?q=80&w=1170&auto=format&fit=crop',
      ],
      'keyMetric': 'R&D Investment',
      'keyMetricValue': '43.2M',
      'color': Color(0xFF6E7E85),
      'actions': ['Research leadership', 'Disruptive thinking', 'Emerging technologies'],
      'quote': {
        'text': 'Innovation happens at the intersection of deep expertise and boundless curiosity.',
        'author': 'David Kumar, Chief Innovation Officer',
        'image': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=687&auto=format&fit=crop',
      },
    },
  ];

  // Grid pattern URL
  final String _gridPatternUrl = 'https://www.transparenttextures.com/patterns/subtle-white-feathers.png';
  
  // Noise pattern URL
  final String _noisePatternUrl = 'https://www.transparenttextures.com/patterns/noise-pattern-with-subtle-cross-lines.png';
  
  // Company logo URL
  final String _companyLogoUrl = 'https://cdn-icons-png.flaticon.com/512/8085/8085898.png';

  @override
  void initState() {
    super.initState();
    
    // Initialize animation controllers
    _mainController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    _cardAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    
    _imageFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _headerImageFadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    
    // Create animations
    _fadeInAnimation = CurvedAnimation(
      parent: _mainController,
      curve: Curves.easeOut,
    );
    
    _slideUpAnimation = Tween<double>(
      begin: 50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _mainController,
      curve: Interval(0.3, 1.0, curve: Curves.easeOutQuart),
    ));
    
    _imageFadeAnimation = CurvedAnimation(
      parent: _imageFadeController,
      curve: Curves.easeInOut,
    );
    
    _headerImageFadeAnimation = CurvedAnimation(
      parent: _headerImageFadeController,
      curve: Curves.easeInOut,
    );
    
    // Initialize image indices for each value
    for (int i = 0; i < missionValues.length; i++) {
      _currentValueImageIndices[i] = 0;
    }
    
    // Start animations
    _mainController.forward();
    _cardAnimController.forward();
    _imageFadeController.value = 1.0; // Start fully visible
    _headerImageFadeController.value = 1.0; // Start fully visible
    
    // Start image rotation timers
    _startHeaderImageRotation();
    _startValueImagesRotation();
    
    // Provide haptic feedback for immersion
    HapticFeedback.mediumImpact();
  }
  
  // Start header image rotation timer
  void _startHeaderImageRotation() {
    _headerImageRotationTimer = Timer.periodic(Duration(seconds: 8), (timer) {
      setState(() {
        // Start fade out
        _headerImageFadeController.reverse().then((_) {
          // Change image when fully transparent
          setState(() {
            _currentHeaderImageIndex = (_currentHeaderImageIndex + 1) % _headerImages.length;
          });
          
          // Start fade in with new image
          _headerImageFadeController.forward();
        });
      });
    });
  }
  
  // Start value images rotation timers
  void _startValueImagesRotation() {
    for (int i = 0; i < missionValues.length; i++) {
      // Use different intervals for each section to create varied timing
      final rotationInterval = Duration(seconds: 7 + i);
      
      _valueImageRotationTimers[i] = Timer.periodic(rotationInterval, (timer) {
        if (i == _selectedIndex) {
          setState(() {
            // Start fade out
            _imageFadeController.reverse().then((_) {
              // Change image when fully transparent
              setState(() {
                final imageList = missionValues[i]['images'] as List<String>;
                _currentValueImageIndices[i] = (_currentValueImageIndices[i]! + 1) % imageList.length;
              });
              
              // Start fade in with new image
              _imageFadeController.forward();
            });
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _cardAnimController.dispose();
    _pulseController.dispose();
    _backgroundAnimController.dispose();
    _imageFadeController.dispose();
    _headerImageFadeController.dispose();
    
    // Cancel timers
    _headerImageRotationTimer?.cancel();
    _valueImageRotationTimers.forEach((key, timer) => timer?.cancel());
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Enhanced responsive breakpoints
    final screenWidth = MediaQuery.of(context).size.width;
    
    final isMobile = screenWidth < kTabletBreakpoint;
    final isSmallMobile = screenWidth < kMobileBreakpoint;
    final isTablet = screenWidth >= kTabletBreakpoint && screenWidth < kDesktopBreakpoint;
    final isDesktop = screenWidth >= kDesktopBreakpoint && screenWidth < kLargeDesktopBreakpoint;
    final isLargeDesktop = screenWidth >= kLargeDesktopBreakpoint && screenWidth < kUltraWideBreakpoint;
    
    // Responsively adjust padding based on screen size
    final horizontalPadding = isSmallMobile 
        ? 16.0 
        : isMobile 
            ? 24.0 
            : isTablet 
                ? 40.0 
                : isDesktop 
                    ? 60.0 
                    : isLargeDesktop 
                        ? 80.0 
                        : 100.0;
    
    return AnimatedBuilder(
      animation: _slideUpAnimation,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeInAnimation,
          child: Transform.translate(
            offset: Offset(0, _slideUpAnimation.value),
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(
                horizontal: isSmallMobile ? 8 : isMobile ? 16 : 24,
                vertical: isSmallMobile ? 40 : isMobile ? 60 : 80,
              ),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  isSmallMobile ? 0 : 8,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 15),
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 60,
                    spreadRadius: 10,
                    offset: const Offset(0, 30),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Premium header section with 3D effect
                    _buildHeader(isMobile, isSmallMobile, isDesktop, isLargeDesktop),
                    
                    // Mission statement with professional styling
                    _buildMissionStatement(isMobile, isSmallMobile, isTablet, isDesktop),
                    
                    // Value cards section
                    _buildValuesSection(isMobile, isSmallMobile, isTablet, isDesktop, horizontalPadding),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Premium 3D-effect header with enhanced responsiveness
  Widget _buildHeader(bool isMobile, bool isSmallMobile, bool isDesktop, bool isLargeDesktop) {
    // Responsive height calculations
    final headerHeight = isSmallMobile 
        ? 250.0 
        : isMobile 
            ? 300.0 
            : isDesktop 
                ? 400.0 
                : 450.0;
    
    // Responsive padding calculations
    final horizontalPadding = isSmallMobile 
        ? 16.0 
        : isMobile 
            ? 24.0 
            : isDesktop 
                ? 60.0 
                : 80.0;
    
    final verticalPadding = isSmallMobile 
        ? 30.0 
        : isMobile 
            ? 40.0 
            : isDesktop 
                ? 50.0 
                : 60.0;
            
    // Responsive font size calculations
    final titleSize = isSmallMobile 
        ? 24.0 
        : isMobile 
            ? 28.0 
            : isDesktop 
                ? 40.0 
                : 48.0;
    
    return Container(
      width: double.infinity,
      height: headerHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Background image with fade effect
          FadeTransition(
            opacity: _headerImageFadeAnimation,
            child: Image.network(
              _headerImages[_currentHeaderImageIndex],
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(color: Colors.black);
              },
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
            ),
          ),
          
          // Professional dark gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.6),
                  Colors.black.withOpacity(0.8),
                ],
              ),
            ),
          ),
          
          // Subtle pattern overlay
          Opacity(
            opacity: 0.05,
            child: Image.network(
              _noisePatternUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
              errorBuilder: (context, error, stackTrace) => Container(color: Colors.transparent),
            ),
          ),
          
          // Header content with 3D depth effect and responsive layout
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Company icon with 3D effect - size adjusts based on screen size
                _build3DLogo(isSmallMobile, isMobile),
                
                SizedBox(height: isSmallMobile ? 16 : isMobile ? 20 : 30),
                
                // Professional title
                Text(
                  "OUR MISSION",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Color(0xFFBBCCEE),
                    fontSize: isSmallMobile ? 12 : 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 3,
                  ),
                ),
                
                SizedBox(height: isSmallMobile ? 8 : isMobile ? 12 : 16),
                
                // Large premium headline
                Text(
                  isMobile ? "Transforming Industries\nThrough Innovation" : "Transforming Industries Through Innovation",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Colors.white,
                    fontSize: titleSize,
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    letterSpacing: -0.5,
                  ),
                ),
                
                SizedBox(height: isSmallMobile ? 16 : isMobile ? 20 : 30),
                
                // Professional button with animation
                MouseRegion(
                  onEnter: (_) => setState(() => _isHeaderHovered = true),
                  onExit: (_) => setState(() => _isHeaderHovered = false),
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 16 : 24, 
                      vertical: isSmallMobile ? 10 : 12,
                    ),
                    decoration: BoxDecoration(
                      color: _isHeaderHovered 
                          ? AppColors.primary 
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _isHeaderHovered 
                            ? AppColors.primary 
                            : Colors.white,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      "EXPLORE OUR VALUES",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        fontSize: isSmallMobile ? 12 : 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: isSmallMobile ? 0.8 : 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  // 3D animated company logo with depth - using network image
  Widget _build3DLogo(bool isSmallMobile, bool isMobile) {
    // Responsive logo size
    final logoSize = isSmallMobile ? 60.0 : isMobile ? 70.0 : 80.0;
    final iconSize = logoSize * 0.5;
    
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(0.05 * math.sin(_pulseController.value * math.pi))
            ..rotateY(0.05 * math.cos(_pulseController.value * math.pi)),
          alignment: Alignment.center,
          child: Container(
            width: logoSize,
            height: logoSize,
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(isSmallMobile ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 20 + (10 * _pulseController.value),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 4,
                  spreadRadius: 0,
                  offset: Offset(2, 2),
                ),
              ],
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Center(
              child: Image.network(
                _companyLogoUrl,
                width: iconSize,
                height: iconSize,
                color: Colors.white,
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.business, 
                  color: Colors.white,
                  size: iconSize * 0.75,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Professional mission statement section with enhanced responsiveness
  Widget _buildMissionStatement(bool isMobile, bool isSmallMobile, bool isTablet, bool isDesktop) {
    // Responsive padding
    final horizontalPadding = isSmallMobile 
        ? 16.0 
        : isMobile 
            ? 24.0 
            : isTablet 
                ? 40.0 
                : 80.0;
                
    // Responsive font sizes
    final missionFontSize = isSmallMobile 
        ? 16.0 
        : isMobile 
            ? 18.0 
            : isTablet 
                ? 20.0 
                : 24.0;
    
    // Responsive layout for stats
    final statsLayout = isSmallMobile || isMobile
        ? _buildMobileStats() 
        : _buildDesktopStats(isMobile);
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isSmallMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Our Mission",
            style: TextStyle(
              fontFamily: "Montserrat",
              color: AppColors.primary,
              fontSize: isSmallMobile ? 12 : 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isSmallMobile ? 16 : 20),
          Container(
            width: isSmallMobile 
                ? double.infinity 
                : isMobile 
                    ? double.infinity 
                    : isTablet 
                        ? 650 
                        : 800,
            child: Text(
              "To drive transformative growth for our clients by delivering innovative technology solutions that bridge present limitations and future possibilities, creating enduring value while upholding the highest standards of excellence and integrity.",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Color(0xFF333333),
                fontSize: missionFontSize,
                fontWeight: FontWeight.w500,
                height: 1.5,
                letterSpacing: -0.2,
              ),
            ),
          ),
          SizedBox(height: isSmallMobile ? 24 : 30),
          // Responsive stats layout
          statsLayout,
        ],
      ),
    );
  }

  // Mobile layout for statistics
  Widget _buildMobileStats() {
    return Column(
      children: [
        _buildStatistic("Global Presence", "26 Countries"),
        SizedBox(height: 20),
        _buildStatistic("Client Success", "94.7%"),
        SizedBox(height: 20),
        _buildStatistic("Team Members", "2,400+"),
      ],
    );
  }

  // Desktop layout for statistics
  Widget _buildDesktopStats(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: _buildStatistic("Global Presence", "26 Countries")),
        SizedBox(width: isMobile ? 20 : 60),
        Flexible(child: _buildStatistic("Client Success", "94.7%")),
        SizedBox(width: isMobile ? 20 : 60),
        Flexible(child: _buildStatistic("Team Members", "2,400+")),
      ],
    );
  }

  // Professional statistic display
  Widget _buildStatistic(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Color(0xFF1A1A1A),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Color(0xFF666666),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // Core values section with enhanced responsiveness
  Widget _buildValuesSection(bool isMobile, bool isSmallMobile, bool isTablet, bool isDesktop, double horizontalPadding) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: isSmallMobile ? 40 : 60,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            "Core Values",
            style: TextStyle(
              fontFamily: "Montserrat",
              color: AppColors.primary,
              fontSize: isSmallMobile ? 12 : 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isSmallMobile ? 12 : 16),
          Text(
            "The Principles That Guide Us",
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Color(0xFF1A1A1A),
              fontSize: isSmallMobile ? 24 : isMobile ? 28 : 36,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: isSmallMobile ? 30 : 40),
          
          // Tab navigation for values - horizontally scrollable on mobile
          SizedBox(
            height: isSmallMobile ? 40 : 48,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: missionValues.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final isSelected = _selectedIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                      _cardAnimController.reset();
                      _cardAnimController.forward();
                      _imageFadeController.value = 1.0; // Reset fade for new value
                      HapticFeedback.selectionClick();
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(right: isSmallMobile ? 6 : 8),
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmallMobile ? 16 : 24,
                      vertical: isSmallMobile ? 0 : 4,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? missionValues[index]['color'] 
                          : Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        missionValues[index]['title'],
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: isSelected 
                              ? Colors.white 
                              : Color(0xFF666666),
                          fontSize: isSmallMobile ? 12 : 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          
          SizedBox(height: isSmallMobile ? 30 : 40),
          
          // Selected value card
          _buildDetailedValueCard(isSmallMobile, isMobile, isTablet, isDesktop),
        ],
      ),
    );
  }

  // Detailed value card with professional design and responsive layout
  Widget _buildDetailedValueCard(bool isSmallMobile, bool isMobile, bool isTablet, bool isDesktop) {
    final selectedValue = missionValues[_selectedIndex];
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      child: isTablet 
          ? _buildTabletValueCard(selectedValue, isSmallMobile) 
          : isMobile
              ? _buildMobileValueCard(selectedValue, isSmallMobile)
              : _buildDesktopValueCard(selectedValue, isDesktop),
    );
  }

  // Mobile layout for value card
  Widget _buildMobileValueCard(Map<String, dynamic> value, bool isSmallMobile) {
    // Responsive font sizes
    final titleSize = isSmallMobile ? 20.0 : 24.0;
    final descriptionSize = isSmallMobile ? 14.0 : 16.0;
    final quoteSize = isSmallMobile ? 12.0 : 14.0;
    
    // Get current image from the rotation list
    final imageList = value['images'] as List<String>;
    final currentImageIndex = _currentValueImageIndices[_selectedIndex] ?? 0;
    final currentImage = imageList[currentImageIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Image section with fade effect
        Container(
          height: isSmallMobile ? 150 : 200,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
            child: FadeTransition(
              opacity: _imageFadeAnimation,
              child: Image.network(
                currentImage,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                        valueColor: AlwaysStoppedAnimation<Color>(value['color']),
                      ),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: Icon(Icons.error_outline, color: Colors.grey),
                ),
              ),
            ),
          ),
        ),
        
        // Content section
        Padding(
          padding: EdgeInsets.all(isSmallMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Added to prevent overflow
            children: [
              // Icon
              Image.network(
                value['icon'],
                width: isSmallMobile ? 24 : 32,
                height: isSmallMobile ? 24 : 32,
                color: value['color'],
                errorBuilder: (context, error, stackTrace) => Icon(
                  Icons.star,
                  size: isSmallMobile ? 24 : 32,
                  color: value['color'],
                ),
              ),
              SizedBox(height: isSmallMobile ? 12 : 16),
              
              // Title and subtitle
              Text(
                value['subtitle'],
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: value['color'],
                  fontSize: isSmallMobile ? 12 : 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: isSmallMobile ? 6 : 8),
              Text(
                value['title'],
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xFF1A1A1A),
                  fontSize: titleSize,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                ),
              ),
              SizedBox(height: isSmallMobile ? 12 : 16),
              
              // Description
              Text(
                value['description'],
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xFF666666),
                  fontSize: descriptionSize,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: isSmallMobile ? 16 : 24),
              
              // Key metric
              Container(
                padding: EdgeInsets.all(isSmallMobile ? 12 : 16),
                decoration: BoxDecoration(
                  color: Color(0xFFF5F5F7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        value['keyMetric'],
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Color(0xFF666666),
                          fontSize: isSmallMobile ? 12 : 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      value['keyMetricValue'],
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: value['color'],
                        fontSize: isSmallMobile ? 12 : 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: isSmallMobile ? 16 : 24),
              
              // Key actions
              Text(
                "KEY INITIATIVES",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xFF1A1A1A),
                  fontSize: isSmallMobile ? 12 : 14,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: isSmallMobile ? 12 : 16),
              ...value['actions'].map<Widget>((action) {
                return Padding(
                  padding: EdgeInsets.only(bottom: isSmallMobile ? 8 : 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: value['color'],
                        size: isSmallMobile ? 14 : 16,
                      ),
                      SizedBox(width: isSmallMobile ? 8 : 12),
                      Expanded(
                        child: Text(
                          action,
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF666666),
                            fontSize: isSmallMobile ? 12 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              SizedBox(height: isSmallMobile ? 16 : 24),
              
              // Quote with network image for portrait
              Container(
                padding: EdgeInsets.all(isSmallMobile ? 12 : 16),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: value['color'],
                      width: 4,
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '"${value['quote']['text']}"',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF1A1A1A),
                        fontSize: quoteSize,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(isSmallMobile ? 12 : 16),
                          child: Image.network(
                            value['quote']['image'],
                            width: isSmallMobile ? 24 : 32,
                            height: isSmallMobile ? 24 : 32,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Container(
                              width: isSmallMobile ? 24 : 32,
                              height: isSmallMobile ? 24 : 32,
                              color: Colors.grey[300],
                              child: Icon(Icons.person, size: isSmallMobile ? 16 : 20, color: Colors.grey),
                            ),
                          ),
                        ),
                        SizedBox(width: isSmallMobile ? 8 : 12),
                        Expanded(
                          child: Text(
                            value['quote']['author'],
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Color(0xFF666666),
                              fontSize: isSmallMobile ? 10 : 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Tablet layout for value card - simplified layout
  Widget _buildTabletValueCard(Map<String, dynamic> value, bool isSmallMobile) {
    // Get current image from the rotation list
    final imageList = value['images'] as List<String>;
    final currentImageIndex = _currentValueImageIndices[_selectedIndex] ?? 0;
    final currentImage = imageList[currentImageIndex];
    
    return Column(
      children: [
        // Top image section with fade effect
        Container(
          height: 220,
          width: double.infinity,
          child: Stack(
            children: [
              // Main image with fade effect
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                child: FadeTransition(
                  opacity: _imageFadeAnimation,
                  child: Image.network(
                    currentImage,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              
              // Badge
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: value['color'],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value['id'].toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              
              // Image rotation indicator
              Positioned(
                bottom: 20,
                right: 20,
                child: Row(
                  children: List.generate(imageList.length, (i) => 
                    Container(
                      width: 8,
                      height: 8,
                      margin: EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == currentImageIndex 
                            ? value['color'] 
                            : Colors.white.withOpacity(0.5),
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // Content section
        Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Image.network(
                    value['icon'],
                    width: 32,
                    height: 32,
                    color: value['color'],
                    errorBuilder: (context, error, stackTrace) => Icon(
                      Icons.star,
                      color: value['color'],
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value['subtitle'],
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: value['color'],
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          value['title'],
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF1A1A1A),
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              
              // Description
              Text(
                value['description'],
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xFF666666),
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),
              
              // Key actions and metric
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Key metric
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFFF5F5F7),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        Text(
                          value['keyMetric'],
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Color(0xFF666666),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(width: 16),
                        Text(
                          value['keyMetricValue'],
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: value['color'],
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  
                  // Key actions
                  Text(
                    "KEY INITIATIVES",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Color(0xFF1A1A1A),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: value['actions'].map<Widget>((action) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle,
                              color: value['color'],
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                action,
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Color(0xFF666666),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 30),
              
              // Quote
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: value['color'],
                      width: 4,
                    ),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        value['quote']['image'],
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 40,
                          height: 40,
                          color: Colors.grey[300],
                          child: Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '"${value['quote']['text']}"',
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              fontStyle: FontStyle.italic,
                              color: Color(0xFF1A1A1A),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            value['quote']['author'],
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Color(0xFF666666),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Desktop layout for value card - simplified layout
  Widget _buildDesktopValueCard(Map<String, dynamic> value, bool isLargeDesktop) {
    // Get current image from the rotation list
    final imageList = value['images'] as List<String>;
    final currentImageIndex = _currentValueImageIndices[_selectedIndex] ?? 0;
    final currentImage = imageList[currentImageIndex];
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Left content section
        Expanded(
          flex: 5,
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon
                Image.network(
                  value['icon'],
                  width: 32,
                  height: 32,
                  color: value['color'],
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.star,
                    color: value['color'],
                    size: 32,
                  ),
                ),
                SizedBox(height: 20),
                
                // Title and subtitle
                Text(
                  value['subtitle'],
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: value['color'],
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  value['title'],
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Color(0xFF1A1A1A),
                    fontSize: isLargeDesktop ? 36 : 32,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: 20),
                
                // Description
                Text(
                  value['description'],
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Color(0xFF666666),
                    fontSize: isLargeDesktop ? 18 : 16,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                ),
                SizedBox(height: 24),
                
                // Key metric
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5F7),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        value['keyMetric'],
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Color(0xFF666666),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 16),
                      Text(
                        value['keyMetricValue'],
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: value['color'],
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                
                // Key actions
                Text(
                  "KEY INITIATIVES",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    color: Color(0xFF1A1A1A),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
                SizedBox(height: 16),
                Column(
                  children: value['actions'].map<Widget>((action) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 12),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: value['color'],
                            size: 16,
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              action,
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Color(0xFF666666),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 30),
                
                // Quote with network image
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    border: Border(
                      left: BorderSide(
                        color: value['color'],
                        width: 4,
                      ),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Image.network(
                          value['quote']['image'],
                          width: 48,
                          height: 48,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 48,
                            height: 48,
                            color: Colors.grey[300],
                            child: Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${value['quote']['text']}"',
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                fontStyle: FontStyle.italic,
                                color: Color(0xFF1A1A1A),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              value['quote']['author'],
                              style: TextStyle(
                                fontFamily: "Montserrat",
                                color: Color(0xFF666666),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        
        // Right image section with fade effect
        Expanded(
          flex: 4,
          child: Stack(
            children: [
              // Main image with fade effect
              ClipRRect(
                borderRadius: BorderRadius.horizontal(right: Radius.circular(8)),
                child: FadeTransition(
                  opacity: _imageFadeAnimation,
                  child: Image.network(
                    currentImage,
                    height: 500, // Fixed height to avoid layout issues
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 500,
                      color: Colors.grey[300],
                      child: Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              
              // Gradient overlay
              Container(
                height: 500,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.white,
                      Colors.white.withOpacity(0),
                    ],
                    stops: [0, 0.3],
                  ),
                ),
              ),
              
              // Badge
              Positioned(
                top: 20,
                right: 20,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: value['color'],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    value['id'].toUpperCase(),
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
              
              // Image rotation indicator
              Positioned(
                bottom: 20,
                right: 20,
                child: Row(
                  children: List.generate(imageList.length, (i) => 
                    Container(
                      width: 10,
                      height: 10,
                      margin: EdgeInsets.only(left: 8),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: i == currentImageIndex 
                            ? value['color'] 
                            : Colors.white.withOpacity(0.5),
                      ),
                    )
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}