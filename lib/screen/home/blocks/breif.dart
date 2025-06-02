import 'dart:math';
import 'dart:ui';

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

class _BriefState extends State<Brief> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isVisible = true;
  final GlobalKey _briefKey = GlobalKey();
  late AnimationController _hoverController;
  late AnimationController _popupController;
  
  // Add separate animation controllers for network lines
  late AnimationController _networkController1;
  late AnimationController _networkController2;
  late AnimationController _networkController3;
  
  // Popup state
  bool _showPopup = false;
  int _selectedCardIndex = 0;
  
  // Random image selection
  final Random _random = Random();
  late int _currentBgIndex;
  late int _currentCardBgIndex;
  
  // List of background images
  final List<String> _backgroundImages = [
    "https://images.unsplash.com/photo-1718241905696-cb34c2c07bed?q=80&w=2128",
    "https://images.unsplash.com/photo-1698394210081-ec826b112215?q=80&w=2070",
    "https://images.unsplash.com/photo-1676671418477-a775a8d26e3d?q=80&w=2071",
    "https://images.unsplash.com/photo-1694933225913-f1fcc244c5da?q=80&w=2070",
    "https://images.unsplash.com/photo-1665686306574-1ace09918530?q=80&w=2070",
  ];
  
  // List of card overlay images
  final List<String> _cardImages = [
    "https://images.unsplash.com/photo-1696688889187-f80ab9723ecc?q=80&w=2070",
    "https://images.unsplash.com/photo-1691209623367-0b39bed786ca?q=80&w=2070",
    "https://images.unsplash.com/photo-1700055777471-ece32f3d0d0f?q=80&w=2071",
    "https://images.unsplash.com/photo-1718436329476-fd6cbaa1fc71?q=80&w=2128",
    "https://images.unsplash.com/photo-1694528060441-8fb3cd0e31a3?q=80&w=2071",
  ];
  
  // Modern color palette
  final Color _primaryColor = const Color(0xFF06CEFF);
  final Color _accentColor = const Color(0xFFFF3D71);
  final Color _tertiaryColor = const Color(0xFF00FFA3);
  final Color _darkColor = const Color(0xFF0A0F18);
  final Color _lightColor = const Color(0xFFF8F9FA);

  // Detailed information for each card
  final List<Map<String, dynamic>> _cardDetails = [
    {
      'title': 'Welcome to PYDART Intelli Corp',
      'subtitle': 'India\'s Emerging Tech Innovator',
      'description': 'PYDART Intelli Corp is a dynamic Indian startup, officially registered in February 2025, bringing fresh innovation to technology with our dual-division approach.',
      'details': [
        'Officially incorporated in February 2025 under Indian Startup Ecosystem',
        'Dual-division startup combining robotics and digital solutions',
        'Based in India with deep understanding of local market needs',
        'Young, passionate team of engineers and innovators from premier institutions',
        'Focused on affordable, scalable solutions for Indian and global markets',
        'Committed to contributing to India\'s Digital India and Make in India initiatives'
      ],
      'features': [
        'Startup Agility & Innovation',
        'Cost-Effective Solutions',
        'Local Market Expertise',
        'Rapid Prototyping',
        'Flexible Partnership Models',
        'Future-Ready Approach'
      ],
      'stats': [
        {'label': 'Company Founded', 'value': 'Feb 2025'},
        {'label': 'Active Projects', 'value': '8+'},
        {'label': 'Team Members', 'value': '12+'},
        {'label': 'Industries Targeting', 'value': '15+'},
      ]
    },
    {
      'title': 'Robotics & Automations Division',
      'subtitle': 'Smart Automation for New India',
      'description': 'Our robotics division focuses on developing affordable, intelligent automation solutions tailored for Indian industries and small-to-medium enterprises.',
      'details': [
        'Prototype development for industrial automation systems',
        'AI-powered inspection solutions for manufacturing quality control',
        'Collaborative robotic solutions designed for Indian MSMEs',
        'IoT-enabled monitoring systems for predictive maintenance',
        'Custom automation solutions for agriculture and textile industries',
        'Research partnerships with Indian technical institutes and universities'
      ],
      'features': [
        'Affordable Automation',
        'Industry 4.0 Solutions',
        'MSME-Focused Design',
        'Local Manufacturing',
        'Rapid Implementation',
        'Maintenance Support'
      ],
      'stats': [
        {'label': 'Prototypes Built', 'value': '5+'},
        {'label': 'Pilot Projects', 'value': '3+'},
        {'label': 'Research Partners', 'value': '4+'},
        {'label': 'Investment in R&D', 'value': '40%'},
      ]
    },
    {
      'title': 'Business Solutions Division',
      'subtitle': 'Digital Solutions for Growing Businesses',
      'description': 'Our digital solutions division creates modern, scalable applications and marketing strategies to help Indian businesses establish their digital presence.',
      'details': [
        'Mobile-first applications for Android and iOS platforms',
        'Progressive web applications with offline capabilities',
        'E-commerce solutions for small and medium businesses',
        'Digital marketing strategies optimized for Indian markets',
        'Brand identity and visual design services',
        'Cloud deployment and maintenance services'
      ],
      'features': [
        'Mobile-First Development',
        'Startup-Friendly Pricing',
        'Regional Language Support',
        'Local Payment Integrations',
        'SEO for Indian Markets',
        'Ongoing Support'
      ],
      'stats': [
        {'label': 'Apps in Development', 'value': '6+'},
        {'label': 'Client Projects', 'value': '12+'},
        {'label': 'Code Quality', 'value': '9.5/10'},
        {'label': 'Avg. Delivery Time', 'value': '4 weeks'},
      ]
    }
  ];

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _popupController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    
    // Initialize network animation controllers with different durations and patterns
    _networkController1 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );
    
    _networkController2 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );
    
    _networkController3 = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3500),
    );
    
    _scrollController.addListener(_scrollListener);
    
    // Randomly select initial background images
    _currentBgIndex = _random.nextInt(_backgroundImages.length);
    _currentCardBgIndex = _random.nextInt(_cardImages.length);
    
    // Start network animations with different delays
    Future.delayed(const Duration(milliseconds: 500), () {
      _networkController1.repeat();
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      _networkController2.repeat();
    });
    
    Future.delayed(const Duration(milliseconds: 1100), () {
      _networkController3.repeat();
    });
    
    // Setup timer to change background images every 15 seconds
    Future.delayed(const Duration(seconds: 15), _changeBackgroundImages);
  }
  
  void _changeBackgroundImages() {
    setState(() {
      _currentBgIndex = _random.nextInt(_backgroundImages.length);
      _currentCardBgIndex = _random.nextInt(_cardImages.length);
    });
    
    // Setup the next change
    Future.delayed(const Duration(seconds: 15), _changeBackgroundImages);
  }

  void _showDetailsPopup(int cardIndex) {
    setState(() {
      _selectedCardIndex = cardIndex;
      _showPopup = true;
    });
    _popupController.forward();
  }

  void _hidePopup() {
    _popupController.reverse().then((_) {
      setState(() {
        _showPopup = false;
      });
    });
  }

  @override
  void dispose() {
    _hoverController.dispose();
    _popupController.dispose();
    _networkController1.dispose();
    _networkController2.dispose();
    _networkController3.dispose();
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
    return Stack(
      children: [
        VisibilityDetector(
          key: _briefKey,
          onVisibilityChanged: (visibilityInfo) {
            if (visibilityInfo.visibleFraction > 0.3) {
              setState(() => _isVisible = true);
            }
          },
          child: AnimatedOpacity(
            opacity: _isVisible ? 1.0 : 0.0,
            duration: 700.ms,
            curve: Curves.easeInOut,
            child: AnimatedContainer(
              duration: 700.ms,
              transform: Matrix4.translationValues(0, _isVisible ? 0 : 50, 0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: _darkColor.withOpacity(0.5),
                    blurRadius: 40,
                    spreadRadius: 10,
                    offset: const Offset(0, 20),
                  ),
                ],
              ),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Stack(
                  children: [
                    // Main animated background with random image
                    _buildAnimatedBackground(),
                    
                    // Overlay with glass effect
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _darkColor.withOpacity(0.85),
                                _darkColor.withOpacity(0.7)
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Animated particle background
                    _buildParticleEffect(),
                    
                    // Animated glowing orbs
                    _buildGlowingOrbs(),
                    
                    // Content
                    ResponsiveRowColumn(
                      layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                          ? ResponsiveRowColumnType.COLUMN
                          : ResponsiveRowColumnType.ROW,
                      rowCrossAxisAlignment: CrossAxisAlignment.center,
                      columnCrossAxisAlignment: CrossAxisAlignment.center,
                      columnMainAxisSize: MainAxisSize.min,
                      rowMainAxisAlignment: MainAxisAlignment.spaceBetween,
                      rowPadding: const EdgeInsets.symmetric(horizontal: 60, vertical: 80),
                      columnPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 60),
                      columnSpacing: 60,
                      rowSpacing: 50,
                      children: [
                        // Main heading with animation
                        ResponsiveRowColumnItem(
                          rowFlex: 1,
                          columnFlex: 0,
                          child: Container(
                            width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP) 
                                ? double.infinity : MediaQuery.of(context).size.width * 0.25,
                            constraints: const BoxConstraints(maxWidth: 400),
                            child: Column(
                              crossAxisAlignment: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                                  ? CrossAxisAlignment.start
                                  : CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PYDART INTELLI CORP",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 4,
                                    color: _primaryColor,
                                  ),
                                )
                                .animate(autoPlay: true)
                                .fadeIn(duration: 800.ms)
                                .slideX(begin: -0.2, end: 0),
                                const SizedBox(height: 12),
                                Text(
                                  "Emerging Tech Innovation",
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.w800,
                                    height: 1.2,
                                    color: _lightColor,
                                    shadows: [
                                      Shadow(
                                        color: _primaryColor.withOpacity(0.6),
                                        blurRadius: 15,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  ),
                                )
                                .animate(autoPlay: true)
                                .fadeIn(delay: 300.ms, duration: 800.ms)
                                .slideY(begin: 0.2, end: 0),
                                const SizedBox(height: 20),
                                Container(
                                  height: 4,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [_primaryColor, _tertiaryColor],
                                    ),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                )
                                .animate(autoPlay: true)
                                .fadeIn(delay: 600.ms, duration: 800.ms)
                                .slideX(begin: -0.5, end: 0, curve: Curves.easeOutExpo),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        
                        // Cards
                        ResponsiveRowColumnItem(
                          rowFlex: 3,
                          child: Container(
                            width: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                                ? double.infinity
                                : MediaQuery.of(context).size.width * 0.7,
                            child: ResponsiveRowColumn(
                              layout: ResponsiveBreakpoints.of(context).smallerThan(TABLET)
                                  ? ResponsiveRowColumnType.COLUMN
                                  : ResponsiveRowColumnType.ROW,
                              rowCrossAxisAlignment: CrossAxisAlignment.start,
                              rowMainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              columnCrossAxisAlignment: CrossAxisAlignment.center,
                              columnMainAxisSize: MainAxisSize.min,
                              columnSpacing: 40,
                              rowSpacing: 30,
                              children: [
                                ResponsiveRowColumnItem(
                                  rowFlex: 1,
                                  child: _buildAnimatedCard(
                                    iconAsset: "assets/icons/LOC.png",
                                    networkIcon: Icons.business,
                                    title: "Welcome to PYDART",
                                    description: "PYDART Intelli Corp is a dynamic Indian startup, officially registered in February 2025. "
                                      "We bring fresh innovation to technology with our dual-division approach, combining cutting-edge robotics "
                                      "with comprehensive digital solutions to serve India's growing technology needs.",
                                      
                                    delay: 0,
                                    accentColor: _primaryColor,
                                    cardIndex: 0,
                                  )
                                ),
                                ResponsiveRowColumnItem(
                                  rowFlex: 1,
                                  child: _buildAnimatedCard(
                                    iconAsset: "assets/icons/FUT.png",
                                    networkIcon: Icons.precision_manufacturing,
                                    title: "Robotics & Automations",
                                    description: "Developing affordable, intelligent automation solutions tailored for Indian industries and MSMEs. "
                                      "Our robotics division focuses on creating smart manufacturing solutions that enhance productivity "
                                      "while being cost-effective for small and medium enterprises across India.",
                                    delay: 300,
                                    accentColor: _tertiaryColor,
                                    cardIndex: 1,
                                  )
                                ),
                                ResponsiveRowColumnItem(
                                  rowFlex: 1,
                                  child: _buildAnimatedCard(
                                    iconAsset: "assets/icons/PRO.png",
                                    networkIcon: Icons.computer,
                                    title: "Business Solutions",
                                    description: "Creating modern, scalable applications and digital marketing strategies for Indian businesses. "
                                      "From mobile-first development to e-commerce solutions, we help startups and SMEs establish "
                                      "their digital presence with affordable, locally-optimized technology solutions.",
                                    delay: 600,
                                    accentColor: _accentColor,
                                    cardIndex: 2,
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Popup overlay
        if (_showPopup) _buildPopupOverlay(),
      ],
    );
  }

  // Enhanced popup overlay
  Widget _buildPopupOverlay() {
    final selectedCard = _cardDetails[_selectedCardIndex];
    final accentColor = _selectedCardIndex == 0 
        ? _primaryColor 
        : _selectedCardIndex == 1 
            ? _tertiaryColor 
            : _accentColor;

    return AnimatedBuilder(
      animation: _popupController,
      builder: (context, child) {
        return Positioned.fill(
          child: GestureDetector(
            onTap: _hidePopup,
            child: Container(
              color: _darkColor.withOpacity(0.8 * _popupController.value),
              child: Center(
                child: Transform.scale(
                  scale: 0.8 + (0.2 * _popupController.value),
                  child: Opacity(
                    opacity: _popupController.value,
                    child: GestureDetector(
                      onTap: () {}, // Prevent closing when tapping on popup content
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        height: MediaQuery.of(context).size.height * 0.85,
                        constraints: const BoxConstraints(
                          maxWidth: 1000,
                          maxHeight: 700,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withOpacity(0.3),
                              blurRadius: 40,
                              spreadRadius: 0,
                              offset: const Offset(0, 20),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Stack(
                            children: [
                              // Background
                              Positioned.fill(
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                      colors: [
                                        _darkColor,
                                        _darkColor.withOpacity(0.95),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              
                              // Background pattern
                              Positioned.fill(
                                child: CustomPaint(
                                  painter: NetworkLinesPainter(
                                    animation: _selectedCardIndex == 0 
                                        ? _networkController1 
                                        : _selectedCardIndex == 1 
                                            ? _networkController2 
                                            : _networkController3,
                                    color: accentColor,
                                    pattern: _selectedCardIndex,
                                  ),
                                ),
                              ),
                              
                              // Content
                              SingleChildScrollView(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Header
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                selectedCard['title'],
                                                style: TextStyle(
                                                  fontSize: 32,
                                                  fontWeight: FontWeight.w800,
                                                  color: _lightColor,
                                                  shadows: [
                                                    Shadow(
                                                      color: accentColor.withOpacity(0.8),
                                                      blurRadius: 15,
                                                      offset: const Offset(0, 0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                selectedCard['subtitle'],
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w500,
                                                  color: accentColor,
                                                  letterSpacing: 1,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Close button
                                        GestureDetector(
                                          onTap: _hidePopup,
                                          child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                              color: accentColor.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                              border: Border.all(
                                                color: accentColor.withOpacity(0.5),
                                                width: 1,
                                              ),
                                            ),
                                            child: Icon(
                                              Icons.close_rounded,
                                              color: _lightColor,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 24),
                                    
                                    // Divider
                                    Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            accentColor,
                                            accentColor.withOpacity(0.1),
                                          ],
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 32),
                                    
                                    // Description
                                    Text(
                                      selectedCard['description'],
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 1.6,
                                        color: _lightColor.withOpacity(0.9),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 32),
                                    
                                    // Stats
                                    Row(
                                      children: [
                                        for (int i = 0; i < selectedCard['stats'].length; i++)
                                          Expanded(
                                            child: Container(
                                              padding: const EdgeInsets.all(20),
                                              margin: EdgeInsets.only(
                                                right: i < selectedCard['stats'].length - 1 ? 16 : 0,
                                              ),
                                              decoration: BoxDecoration(
                                                color: accentColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(16),
                                                border: Border.all(
                                                  color: accentColor.withOpacity(0.3),
                                                  width: 1,
                                                ),
                                              ),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    selectedCard['stats'][i]['value'],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight: FontWeight.w800,
                                                      color: accentColor,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(
                                                    selectedCard['stats'][i]['label'],
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w500,
                                                      color: _lightColor.withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 40),
                                    
                                    // Features and Details
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Key Features
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Key Features',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: _lightColor,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ...selectedCard['features'].map<Widget>((feature) => 
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: 8,
                                                        height: 8,
                                                        decoration: BoxDecoration(
                                                          color: accentColor,
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          feature,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: _lightColor.withOpacity(0.8),
                                                            height: 1.4,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ).toList(),
                                            ],
                                          ),
                                        ),
                                        
                                        const SizedBox(width: 40),
                                        
                                        // Detailed Information
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'What We Offer',
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: _lightColor,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              ...selectedCard['details'].map<Widget>((detail) => 
                                                Padding(
                                                  padding: const EdgeInsets.only(bottom: 12),
                                                  child: Row(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Container(
                                                        margin: const EdgeInsets.only(top: 6),
                                                        width: 6,
                                                        height: 6,
                                                        decoration: BoxDecoration(
                                                          color: accentColor.withOpacity(0.6),
                                                          shape: BoxShape.circle,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 12),
                                                      Expanded(
                                                        child: Text(
                                                          detail,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: _lightColor.withOpacity(0.8),
                                                            height: 1.4,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ).toList(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    
                                    const SizedBox(height: 40),
                                    
                                    // Action buttons
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        _buildActionButton(
                                          'Join Our Journey',
                                          accentColor,
                                          isPrimary: true,
                                        ),
                                        const SizedBox(width: 16),
                                        _buildActionButton(
                                          'Partner With Us',
                                          accentColor,
                                          isPrimary: false,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(String text, Color accentColor, {required bool isPrimary}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: isPrimary ? accentColor : Colors.transparent,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: accentColor,
          width: 2,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isPrimary ? _darkColor : accentColor,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
    );
  }

  // Modern particle effect
  Widget _buildParticleEffect() {
    return Positioned.fill(
      child: CustomPaint(
        painter: ParticlesPainter(
          animation: _hoverController,
          primaryColor: _primaryColor,
          accentColor: _accentColor,
        ),
      ),
    );
  }
  
  // Animated glowing orbs
  Widget _buildGlowingOrbs() {
    return Positioned.fill(
      child: Stack(
        children: List.generate(6, (index) {
          final random = Random();
          final size = 100.0 + random.nextDouble() * 150.0;
          final positionX = random.nextDouble() * MediaQuery.of(context).size.width;
          final positionY = random.nextDouble() * MediaQuery.of(context).size.height;
          final color = [_primaryColor, _accentColor, _tertiaryColor][random.nextInt(3)];
          final delay = random.nextInt(3000);
          
          return Positioned(
            left: positionX,
            top: positionY,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    color.withOpacity(0.5),
                    color.withOpacity(0.0),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            )
            .animate(autoPlay: true, onPlay: (controller) => controller.repeat())
            .fadeIn(delay: delay.ms, duration: 2000.ms)
            .then()
            .fadeOut(delay: 3000.ms, duration: 2000.ms)
            .then(),
          );
        }),
      ),
    );
  }

  // Modified network lines animation with card-specific controllers
  Widget _buildNetworkLines(IconData networkIcon, int delay, Color accentColor, int cardIndex) {
    // Select the appropriate controller based on card index
    AnimationController networkController;
    switch (cardIndex) {
      case 0:
        networkController = _networkController1;
        break;
      case 1:
        networkController = _networkController2;
        break;
      case 2:
        networkController = _networkController3;
        break;
      default:
        networkController = _networkController1;
    }

    return Positioned.fill(
      child: CustomPaint(
        painter: NetworkLinesPainter(
          animation: networkController,
          color: accentColor,
          pattern: cardIndex, // Pass pattern index for different behaviors
        ),
        child: Center(
          child: Icon(
            networkIcon,
            size: 120,
            color: accentColor.withOpacity(0.1),
          )
          .animate(autoPlay: true)
          .fadeIn(delay: delay.ms, duration: 1200.ms)
          .scale(begin: const Offset(1.2, 1.2),)
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

  // Modern hover icon
  Widget _buildHoverIcon(String assetPath, int delay, Color accentColor) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Animated glow
          AnimatedBuilder(
            animation: _hoverController,
            builder: (context, child) {
              return Container(
                width: 80 + 30 * _hoverController.value,
                height: 80 + 30 * _hoverController.value,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentColor.withOpacity(0.2 * _hoverController.value),
                      Colors.transparent,
                    ],
                  ),
                ),
              );
            },
          ),
          
          // Icon background
          AnimatedContainer(
            duration: 300.ms,
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: _darkColor.withOpacity(0.6),
              shape: BoxShape.circle,
              border: Border.all(
                color: accentColor.withOpacity(0.4 + 0.6 * _hoverController.value),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: accentColor.withOpacity(0.4 * _hoverController.value),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  assetPath,
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                  color: _lightColor,
                ),
              ),
            ),
          )
          .animate(autoPlay: true)
          .fadeIn(delay: delay.ms, duration: 800.ms)
          .slideY(begin: 0.2, end: 0)
          .scale(
            delay: 1500.ms,
            duration: 1000.ms,
            curve: Curves.elasticOut,
          ),
          
          // Animated rings
          ...List.generate(2, (index) {
            return AnimatedBuilder(
              animation: _hoverController,
              builder: (context, child) {
                return Container(
                  width: 90 + (index * 20) + (20 * _hoverController.value),
                  height: 90 + (index * 20) + (20 * _hoverController.value),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: accentColor.withOpacity(0.1 - (0.05 * index) + (0.1 * _hoverController.value)),
                      width: 1,
                    ),
                  ),
                );
              },
            )
            .animate(autoPlay: true, onPlay: (controller) => controller.repeat())
            .custom(
              duration: 3000.ms + (index * 1000).ms,
              curve: Curves.easeInOut,
              builder: (context, value, child) => Transform.scale(
                scale: 0.8 + 0.2 * sin(value * 3.14159),
                child: child,
              ),
            );
          }),
        ],
      ),
    );
  }

  // Enhanced Learn More button with new design
  Widget _buildLearnMoreButton(Color accentColor, int cardIndex) {
    return MouseRegion(
      child: GestureDetector(
        onTap: () => _showDetailsPopup(cardIndex),
        child: AnimatedContainer(
          duration: 300.ms,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                accentColor.withOpacity(0.8),
                accentColor,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.4),
                blurRadius: 15,
                spreadRadius: 0,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.explore_outlined,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                "Explore Details",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    )
    .animate(autoPlay: true)
    .fadeIn(delay: 600.ms, duration: 800.ms)
    .slideY(begin: 0.2, end: 0);
  }

  // Modernized card with enhanced animations
  Widget _buildAnimatedCard({
    required String iconAsset,
    required IconData networkIcon,
    required String title,
    required String description,
    required int delay,
    required Color accentColor,
    required int cardIndex, // Add cardIndex parameter
  }) {
    final randomImageIndex = _random.nextInt(_cardImages.length);
    
    return MouseRegion(
      onEnter: (_) => _hoverController.forward(),
      onExit: (_) => _hoverController.reverse(),
      child: AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform(
            transform: Matrix4.identity()
              ..translate(0.0, -15 * _hoverController.value, 0.0)
              ..scale(1.0 + 0.05 * _hoverController.value),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: accentColor.withOpacity(0.4 * _hoverController.value),
                    blurRadius: 30,
                    spreadRadius: 0,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Stack(
                  children: [
                    // Card background with random image
                    Positioned.fill(
                      child: AnimatedOpacity(
                        duration: 500.ms,
                        opacity: 0.15 + (0.1 * _hoverController.value),
                        child: Image.network(
                          _cardImages[randomImageIndex],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    
                    // Glass blur effect
                    Positioned.fill(
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                _darkColor.withOpacity(0.85),
                                _darkColor.withOpacity(0.7),
                              ],
                            ),
                            border: Border.all(
                              color: accentColor.withOpacity(0.1 + 0.3 * _hoverController.value),
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                    ),
                    
                    // Network lines animation with card index
                    _buildNetworkLines(networkIcon, delay, accentColor, cardIndex),
                    
                    // Card content
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        children: [
                          _buildHoverIcon(iconAsset, delay, accentColor),
                          const SizedBox(height: 24),
                          
                          // Title with animated underline
                          Column(
                            children: [
                              Text(
                                title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _lightColor,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: accentColor.withOpacity(0.8),
                                      blurRadius: 15,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (delay + 200).ms, duration: 800.ms)
                              .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                              
                              const SizedBox(height: 8),
                              
                              // Animated underline
                              AnimatedContainer(
                                duration: 300.ms,
                                width: 40 + (60 * _hoverController.value),
                                height: 2,
                                decoration: BoxDecoration(
                                  color: accentColor,
                                  borderRadius: BorderRadius.circular(1),
                                ),
                              )
                              .animate()
                              .fadeIn(delay: (delay + 400).ms, duration: 800.ms),
                            ],
                          ),
                          
                          const SizedBox(height: 24),
                          
                          // Description
                          Text(
                            description,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _lightColor.withOpacity(0.8),
                              fontSize: 15,
                              height: 1.7,
                              letterSpacing: 0.3,
                            ),
                          )
                          .animate()
                          .fadeIn(delay: (delay + 400).ms, duration: 800.ms)
                          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutQuad),
                          
                          const SizedBox(height: 24),
                          
                          // Enhanced Learn more button
                          _buildLearnMoreButton(accentColor, cardIndex),
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
    );
  }

  // Modern animated background with random image selection
  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: AnimatedSwitcher(
        duration: 1500.ms,
        child: Container(
          key: ValueKey<int>(_currentBgIndex),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(_backgroundImages[_currentBgIndex]),
              fit: BoxFit.cover,
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 1000.ms)
        .scale(
          begin: const Offset(1.1, 1.1),
          end: const Offset(1.0, 1.0),
          duration: 1000.ms,
        )
        .then()
        .custom(
          duration: 20000.ms,
          builder: (context, value, child) => Transform.scale(
            scale: 1.0 + (0.1 * value),
            child: child,
          ),
        ),
      ),
    );
  }
}

// Modern particle animation
class ParticlesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color primaryColor;
  final Color accentColor;
  final int particleCount = 80;
  final Random random = Random();
  
  ParticlesPainter({
    required this.animation, 
    required this.primaryColor,
    required this.accentColor,
  }) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size canvasSize) {
    for (int i = 0; i < particleCount; i++) {
      final x = random.nextDouble() * canvasSize.width;
      final y = random.nextDouble() * canvasSize.height;
      final particleSize = 1.0 + random.nextDouble() * 3.0;
      
      // Alternate colors
      final color = i % 2 == 0
          ? primaryColor.withOpacity(0.1 + 0.2 * animation.value)
          : accentColor.withOpacity(0.1 + 0.2 * animation.value);
      
      final Paint particlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      // Pulse effect
      final pulseValue = 0.5 + 0.5 * sin((animation.value * 6.28) + (i * 0.1));
      final finalParticleSize = particleSize * (0.8 + 0.4 * pulseValue);
      
      canvas.drawCircle(Offset(x, y), finalParticleSize, particlePaint);
    }
  }
  
  @override
  bool shouldRepaint(ParticlesPainter oldDelegate) => true;
}

// Enhanced network line painter with Future Ready Product style for all cards
class NetworkLinesPainter extends CustomPainter {
  final Animation<double> animation;
  final Color color;
  final int pattern; // Keep pattern for timing variation but use same visual style
  
  NetworkLinesPainter({
    required this.animation, 
    required this.color, 
    required this.pattern,
  }) : super(repaint: animation);
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width < size.height ? size.width / 4 : size.height / 4;
    
    // Use Future Ready Product style (pattern 1) for all cards with slight timing variations
    double animationIntensity;
    double phaseOffset;
    double speedMultiplier;
    
    // All cards use pulsing animation but with different phase offsets for variety
    animationIntensity = 0.2 + 0.8 * (0.5 + 0.5 * sin(animation.value * 6.28 * 2));
    phaseOffset = pattern * 1.2; // Different phase offset for each card
    speedMultiplier = 1.5;
    
    final Paint linePaint = Paint()
      ..color = color.withOpacity(0.15 + 0.25 * animationIntensity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    // Use consistent 10 lines for all cards (Future Ready Product style)
    final numberOfLines = 10;
    for (int i = 0; i < numberOfLines; i++) {
      final angle = i * (3.14159 * 2 / numberOfLines);
      final pulseValue = 0.5 + 0.5 * sin((animation.value * speedMultiplier * 6.28) + (i * 0.5) + phaseOffset);
      final lineLength = radius * (0.8 + 0.4 * pulseValue * animationIntensity);
      final x = center.dx + cos(angle) * lineLength;
      final y = center.dy + sin(angle) * lineLength;
      
      canvas.drawLine(center, Offset(x, y), linePaint);
      
      // Draw pulsing nodes
      final nodePaint = Paint()
        ..color = color.withOpacity(0.3 + 0.5 * pulseValue * animationIntensity)
        ..style = PaintingStyle.fill;
        
      final nodeSize = 2.0 + 2.0 * pulseValue * animationIntensity;
      canvas.drawCircle(Offset(x, y), nodeSize, nodePaint);
    }
    
    // Draw connecting lines between nodes - use Future Ready Product style
    final arcPaint = Paint()
      ..color = color.withOpacity(0.08 + 0.15 * animationIntensity)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < numberOfLines; i++) {
      final angle1 = i * (3.14159 * 2 / numberOfLines);
      
      // Use 3 connections per node for all cards (Future Ready Product style)
      final connectionsPerNode = 3;
      
      for (int j = 1; j <= connectionsPerNode; j++) {
        final angle2 = ((i + j * 3) % numberOfLines) * (3.14159 * 2 / numberOfLines);
        
        final pulseValue = 0.5 + 0.5 * sin((animation.value * speedMultiplier * 6.28) + (i * 0.3) + phaseOffset);
        final lineLength = radius * (0.8 + 0.4 * pulseValue * animationIntensity);
        
        final x1 = center.dx + cos(angle1) * lineLength;
        final y1 = center.dy + sin(angle1) * lineLength;
        
        final x2 = center.dx + cos(angle2) * lineLength;
        final y2 = center.dy + sin(angle2) * lineLength;
        
        // Use curved paths for all cards (Future Ready Product style)
        final path = Path();
        path.moveTo(x1, y1);
        
        final controlMultiplier = 0.3; // Use Future Ready Product control multiplier
        final controlX = center.dx + (cos(angle1) + cos(angle2)) * lineLength * controlMultiplier;
        final controlY = center.dy + (sin(angle1) + sin(angle2)) * lineLength * controlMultiplier;
        path.quadraticBezierTo(controlX, controlY, x2, y2);
        
        canvas.drawPath(path, arcPaint);
      }
    }
    
    // Draw outer circle - consistent style for all cards
    final outerCirclePaint = Paint()
      ..color = color.withOpacity(0.05 + 0.15 * animationIntensity)
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;
    
    canvas.drawCircle(center, radius * 1.3, outerCirclePaint); // Slightly larger for Future Ready feel
  }
  
  @override
  bool shouldRepaint(NetworkLinesPainter oldDelegate) => true;
}