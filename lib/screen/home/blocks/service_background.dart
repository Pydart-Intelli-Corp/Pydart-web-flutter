import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_website/components/colors.dart' as AppColors;

class EnterpriseServicesBlock extends StatefulWidget {
  const EnterpriseServicesBlock({super.key});

  @override
  State<EnterpriseServicesBlock> createState() => _EnterpriseServicesBlockState();
}

class _EnterpriseServicesBlockState extends State<EnterpriseServicesBlock>
    with TickerProviderStateMixin {
  // Animation controllers
  late AnimationController _backgroundAnimController;
  late AnimationController _pulseAnimController;
  late AnimationController _shimmerAnimController;
  
  // Service state
  int _selectedServiceIndex = 0;
  bool _isHoveringTitle = false;
  Map<int, bool> _expandedPanels = {};
  
  // Screen size breakpoints
  final double _mobileBreakpoint = 768;
  final double _tabletBreakpoint = 1024;
  final double _smallMobileBreakpoint = 480;

  // Enterprise service offerings
  final List<EnterpriseService> _services = [
    EnterpriseService(
      title: "AI & Robotics Automation",
      color: Color(0xFF1A237E),
      image: "https://images.unsplash.com/photo-1531746790731-6c087fecd65a",
      badgeText: "Cutting-Edge",
      description: "Intelligent systems that transform business operations",
      longDescription: "Our AI and robotics solutions leverage cutting-edge machine learning, computer vision, and automation technologies to enhance productivity, reduce costs, and drive innovation across your organization.",
      features: [
        "Machine Learning & Deep Learning",
        "Computer Vision Systems",
        "Robotic Process Automation (RPA)",
        "Natural Language Processing",
        "Predictive Analytics",
        "Autonomous Systems",
        "AI Model Training & Deployment",
        "Custom Algorithm Development"
      ],
      metrics: {
        "Operational Efficiency": "35-75%",
        "Cost Reduction": "40-60%",
        "Decision Accuracy": "85-95%",
        "ROI": "3.8x investment"
      },
      industries: [
        Industry(name: "Manufacturing", icon: Icons.precision_manufacturing),
        Industry(name: "Healthcare", icon: Icons.local_hospital),
        Industry(name: "Finance", icon: Icons.account_balance),
        Industry(name: "Retail", icon: Icons.shopping_cart),
        Industry(name: "Logistics", icon: Icons.local_shipping),
      ],
      testimonial: Testimonial(
        quote: "The AI-powered predictive maintenance system has reduced our downtime by 72% and extended equipment lifespans significantly. It's been a game-changer for our manufacturing operations.",
        author: "Michael Chen",
        position: "CTO, Global Manufacturing Corp",
      ),
    ),
    EnterpriseService(
      title: "Web & Cloud Solutions",
      color: Color(0xFF00796B),
      image: "https://images.unsplash.com/photo-1451187580459-43490279c0fa",
      badgeText: "Scalable",
      description: "Enterprise-grade web platforms and cloud infrastructure",
      longDescription: "We deliver robust, scalable web applications and cloud solutions that power mission-critical business operations. From microservices architectures to serverless computing, we build systems that scale reliably and perform under pressure.",
      features: [
        "Full-Stack Web Development",
        "Cloud-Native Applications",
        "Microservices Architecture",
        "API Design & Development",
        "Serverless Computing",
        "DevOps & CI/CD Integration",
        "Database Design & Optimization",
        "High-Performance Systems"
      ],
      metrics: {
        "Deployment Speed": "5x faster",
        "Infrastructure Costs": "40-65%",
        "System Reliability": "99.99%",
        "Scalability Factor": "10-1000x"
      },
      industries: [
        Industry(name: "E-commerce", icon: Icons.shopping_bag),
        Industry(name: "SaaS", icon: Icons.cloud_done),
        Industry(name: "Finance", icon: Icons.account_balance),
        Industry(name: "Healthcare", icon: Icons.local_hospital),
        Industry(name: "Education", icon: Icons.school),
      ],
      testimonial: Testimonial(
        quote: "Their cloud-native approach reduced our infrastructure costs by 58% while simultaneously improving reliability and enabling us to scale during peak demand 20x faster than our previous solution.",
        author: "Sarah Johnson",
        position: "CIO, Enterprise Retail Solutions",
      ),
    ),
    EnterpriseService(
      title: "Mobile App Development",
      color: Color(0xFF7B1FA2),
      image: "https://images.unsplash.com/photo-1526498460520-4c246339dccb",
      badgeText: "Award-Winning",
      description: "Transformative Android & iOS applications",
      longDescription: "Our mobile development team creates intuitive, high-performance applications for iOS and Android that deliver exceptional user experiences. We specialize in cross-platform solutions, native apps, and enterprise mobility systems that drive engagement and results.",
      features: [
        "iOS Native Development",
        "Android Native Development",
        "Flutter Cross-Platform Solutions",
        "React Native Applications",
        "Enterprise Mobility Management",
        "Progressive Web Apps (PWAs)",
        "AR/VR Mobile Experiences",
        "Mobile Security Protocols"
      ],
      metrics: {
        "Development Time": "40% reduction",
        "User Engagement": "45-120%",
        "App Performance": "30-60%",
        "Conversion Rates": "25-80%"
      },
      industries: [
        Industry(name: "Retail", icon: Icons.shopping_bag),
        Industry(name: "Healthcare", icon: Icons.local_hospital),
        Industry(name: "Finance", icon: Icons.account_balance),
        Industry(name: "Travel", icon: Icons.flight),
        Industry(name: "Entertainment", icon: Icons.movie),
      ],
      testimonial: Testimonial(
        quote: "The mobile banking solution they developed has transformed our customer experience. User satisfaction increased by 87%, and mobile transaction volume grew by 152% within the first six months.",
        author: "David Williams",
        position: "Head of Digital Banking, Global Finance",
      ),
    ),
    EnterpriseService(
      title: "IoT & Embedded Systems",
      color: Color(0xFFE64A19),
      image: "https://images.unsplash.com/photo-1518770660439-4636190af475",
      badgeText: "Connected Future",
      description: "Firmware and embedded solutions for the connected world",
      longDescription: "We develop sophisticated IoT ecosystems and embedded systems that connect devices, gather insights, and enable smart automation. From industrial sensors to consumer electronics, our solutions power the intelligent systems of tomorrow.",
      features: [
        "Embedded Firmware Development",
        "IoT Platform Implementation",
        "Sensor Integration & Networks",
        "Real-time Operating Systems",
        "Low-power Device Design",
        "Edge Computing Solutions",
        "Industrial Automation Systems",
        "IoT Security & Encryption"
      ],
      metrics: {
        "Device Reliability": "99.98%",
        "Power Efficiency": "30-70%",
        "Data Processing": "Edge reduction 80%",
        "System Lifetime": "2-3x extension"
      },
      industries: [
        Industry(name: "Manufacturing", icon: Icons.precision_manufacturing),
        Industry(name: "Smart Cities", icon: Icons.location_city),
        Industry(name: "Healthcare", icon: Icons.local_hospital),
        Industry(name: "Agriculture", icon: Icons.grass),
        Industry(name: "Energy", icon: Icons.bolt),
      ],
      testimonial: Testimonial(
        quote: "The IoT solution deployed across our manufacturing facilities has provided unprecedented visibility into operations and enabled predictive maintenance that's saved us millions in downtime costs.",
        author: "James Rodriguez",
        position: "VP of Operations, Advanced Manufacturing Inc.",
      ),
    ),
    EnterpriseService(
      title: "Digital Marketing",
      color: Color(0xFF2E7D32),
      image: "https://images.unsplash.com/photo-1568952433726-3896e3881c65",
      badgeText: "Results-Driven",
      description: "Strategic campaigns that drive growth and engagement",
      longDescription: "Our data-driven digital marketing services deliver measurable results through strategic campaigns, content creation, and platform optimization. From social media marketing to lead generation, we help businesses expand their digital footprint and connect with their audience.",
      features: [
        "Social Media Marketing",
        "Search Engine Optimization (SEO)",
        "Pay-Per-Click Advertising",
        "Content Marketing Strategy",
        "Email Marketing Campaigns",
        "Lead Generation Programs",
        "Analytics & Performance Tracking",
        "Conversion Rate Optimization"
      ],
      metrics: {
        "Lead Generation": "35-150%",
        "Conversion Rates": "25-75%",
        "Marketing ROI": "3.2x investment",
        "Brand Engagement": "45-200%"
      },
      industries: [
        Industry(name: "E-commerce", icon: Icons.shopping_bag),
        Industry(name: "B2B Services", icon: Icons.business),
        Industry(name: "Education", icon: Icons.school),
        Industry(name: "Healthcare", icon: Icons.local_hospital),
        Industry(name: "Real Estate", icon: Icons.home),
      ],
      testimonial: Testimonial(
        quote: "Their integrated digital marketing approach transformed our online presence. We've seen a 127% increase in qualified leads and a 43% reduction in customer acquisition costs over the past year.",
        author: "Emily Thompson",
        position: "Marketing Director, SaaS Solutions Inc.",
      ),
    ),
    EnterpriseService(
      title: "Creative Design",
      color: Color(0xFFC2185B),
      image: "https://images.unsplash.com/photo-1572044162444-ad60f128bdea",
      badgeText: "Visually Striking",
      description: "Brand identity, marketing materials, and visual storytelling",
      longDescription: "Our creative design services encompass branding, visual identity, marketing materials, and digital assets that communicate your brand story effectively. We blend artistry with strategy to create designs that resonate with your audience and strengthen your market position.",
      features: [
        "Brand Identity & Logo Design",
        "Visual Identity Systems",
        "Marketing Collateral Design",
        "Packaging & Product Design",
        "Digital Asset Creation",
        "UI/UX Design",
        "Motion Graphics & Animation",
        "Print & Publication Design"
      ],
      metrics: {
        "Brand Recognition": "40-75%",
        "Customer Perception": "65% improvement",
        "Design ROI": "2.8x investment",
        "Engagement Metrics": "35-90%"
      },
      industries: [
        Industry(name: "Retail", icon: Icons.shopping_bag),
        Industry(name: "Hospitality", icon: Icons.hotel),
        Industry(name: "Technology", icon: Icons.computer),
        Industry(name: "Entertainment", icon: Icons.movie),
        Industry(name: "Food & Beverage", icon: Icons.restaurant),
      ],
      testimonial: Testimonial(
        quote: "The rebranding they executed for us has completely transformed our market perception. The cohesive visual identity system works perfectly across all touchpoints and has given us a distinct competitive advantage.",
        author: "Robert Garcia",
        position: "CEO, Modern Consumer Brands",
      ),
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize animation controllers
    _backgroundAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _shimmerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Initialize expanded panels
    for (int i = 0; i < _services.length; i++) {
      _expandedPanels[i] = false;
    }
    
    // Expand first panel by default
    _expandedPanels[0] = true;
  }

  @override
  void dispose() {
    _backgroundAnimController.dispose();
    _pulseAnimController.dispose();
    _shimmerAnimController.dispose();
    super.dispose();
  }

  // Background effect
  Widget _buildBackground() {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _backgroundAnimController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: 0,
                endAngle: 2 * pi,
                transform: GradientRotation(_backgroundAnimController.value * 2 * pi),
                colors: [
                  Colors.black,
                  _services[_selectedServiceIndex].color.withOpacity(0.3),
                  Colors.black,
                  Colors.black.withOpacity(0.8),
                ],
                stops: const [0.0, 0.3, 0.6, 1.0],
              ),
            ),
          );
        }
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < _mobileBreakpoint;
    final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
    final isDesktop = size.width >= _tabletBreakpoint;
    final isSmallMobile = size.width < _smallMobileBreakpoint;

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Background
          _buildBackground(),
          
          // Main content with responsive layout
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Padding(
                  padding: EdgeInsets.only(
                    top: isMobile ? 60 : isTablet ? 80 : 100,
                    left: isMobile ? 24 : isTablet ? 60 : 100,
                    right: isMobile ? 24 : isTablet ? 60 : 100,
                    bottom: isMobile ? 30 : 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      MouseRegion(
                        onEnter: (_) => setState(() => _isHoveringTitle = true),
                        onExit: (_) => setState(() => _isHoveringTitle = false),
                        child: AnimatedBuilder(
                          animation: _shimmerAnimController,
                          builder: (context, child) {
                            return ShaderMask(
                              shaderCallback: (bounds) {
                                return LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.8),
                                    Colors.white,
                                    Colors.white.withOpacity(0.8),
                                  ],
                                  stops: [0.0, (_shimmerAnimController.value + 0.5) % 1.0, 1.0],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Text(
                                "Our Services",
                                style: TextStyle(
                                  fontSize: isMobile ? 
                                    (isSmallMobile ? 28 : 36) : 
                                    (isTablet ? 44 : 52),
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: "SpaceGrotesk",
                                  height: 1.1,
                                  letterSpacing: -1,
                                  shadows: [
                                    BoxShadow(
                                      color: _isHoveringTitle
                                          ? _services[_selectedServiceIndex].color.withOpacity(0.7)
                                          : Colors.black.withOpacity(0.5),
                                      blurRadius: 20,
                                      offset: Offset(0, 5),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                      
                      // Subtitle
                      SizedBox(height: isMobile ? 16 : 24),
                      Text(
                        "Comprehensive technology solutions tailored to meet the evolving needs of modern businesses and drive exceptional results.",
                        style: TextStyle(
                          fontSize: isMobile ? 16 : isTablet ? 20 : 24,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Service navigation - Responsive for mobile/desktop
                isMobile
                    ? _buildMobileServiceSelector()
                    : _buildDesktopServiceTabs(),
                
                // Service content
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : isTablet ? 60 : 100,
                    vertical: isMobile ? 30 : 40,
                  ),
                  child: isMobile
                      ? _buildMobileServiceContent(_services[_selectedServiceIndex])
                      : _buildDesktopServiceContent(_services[_selectedServiceIndex]),
                ),
                
                // CTA section
                _buildCtaSection(isMobile, isTablet),
                
                // Footer spacing
                SizedBox(height: isMobile ? 60 : 80),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // MOBILE: Service selector dropdown
  Widget _buildMobileServiceSelector() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _services[_selectedServiceIndex].color.withOpacity(0.4),
          width: 2,
        ),
      ),
      child: DropdownButton<int>(
        value: _selectedServiceIndex,
        onChanged: (value) {
          if (value != null) {
            setState(() {
              _selectedServiceIndex = value;
            });
            // Provide haptic feedback
            HapticFeedback.selectionClick();
          }
        },
        dropdownColor: Colors.black.withOpacity(0.9),
        icon: Icon(
          Icons.keyboard_arrow_down,
          color: Colors.white,
        ),
        isExpanded: true,
        underline: SizedBox(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        items: List.generate(_services.length, (index) {
          return DropdownMenuItem<int>(
            value: index,
            child: Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _services[index].color,
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 10),
                Text(_services[index].title),
              ],
            ),
          );
        }),
      ),
    );
  }
  
  // DESKTOP: Horizontal service tabs
  Widget _buildDesktopServiceTabs() {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
    
    return Container(
      height: 90,
      padding: EdgeInsets.symmetric(vertical: 15),
      margin: EdgeInsets.symmetric(
        horizontal: isTablet ? 60 : 100,
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(_services.length, (index) {
          final isSelected = _selectedServiceIndex == index;
          
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedServiceIndex = index;
              });
              // Provide haptic feedback
              HapticFeedback.mediumImpact();
            },
            child: Container(
              margin: EdgeInsets.only(right: 15),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16
                ),
                decoration: BoxDecoration(
                  color: isSelected 
                      ? _services[index].color.withOpacity(0.15)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected
                        ? _services[index].color
                        : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: isSelected ? [
                    BoxShadow(
                      color: _services[index].color.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    )
                  ] : null,
                ),
                child: Text(
                  _services[index].title,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 16,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // MOBILE: Vertical service content layout
  Widget _buildMobileServiceContent(EnterpriseService service) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Service card
        _buildMobileServiceCard(service),
        
        SizedBox(height: 30),
        
        // Key features
        Text(
          "Key Capabilities",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Column(
          children: service.features.map((feature) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: service.color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: service.color,
                    size: 22,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
        
        // Industries
        Text(
          "Industries",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: service.industries.map((industry) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: service.color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    industry.icon,
                    color: service.color,
                    size: 20,
                  ),
                  SizedBox(width: 10),
                  Text(
                    industry.name,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
        
        SizedBox(height: 30),
        
        // Testimonial
        if (service.testimonial != null)
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  service.color.withOpacity(0.15),
                  Colors.black.withOpacity(0.3),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: service.color.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.format_quote,
                  color: service.color,
                  size: 28,
                ),
                SizedBox(height: 15),
                Text(
                  service.testimonial!.quote,
                  style: TextStyle(
                    fontSize: 16,
                    fontStyle: FontStyle.italic,
                    color: Colors.white,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "— ${service.testimonial!.author}, ${service.testimonial!.position}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
      ],
    );
  }
  
  // MOBILE: Service card design
  Widget _buildMobileServiceCard(EnterpriseService service) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: service.color.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            // Background image
            Image.network(
              service.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: service.color,
                    ),
                  ),
                );
              },
            ),
            
            // Gradient overlay
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
              ),
            ),
            
            // Content
            Container(
              height: 200,
              width: double.infinity,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: service.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(
                        color: service.color.withOpacity(0.4),
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: service.color,
                        ),
                        SizedBox(width: 6),
                        Text(
                          service.badgeText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 10),
                  
                  // Title
                  Text(
                    service.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                  ),
                  
                  SizedBox(height: 8),
                  
                  // Description
                  Text(
                    service.description,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // DESKTOP: Horizontal service content layout
  Widget _buildDesktopServiceContent(EnterpriseService service) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Main service card
        _buildDesktopServiceCard(service),
        
        SizedBox(height: 60),
        
        // Features and metrics
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Features column
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Key Capabilities",
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isTablet ? 2 : 3,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: isTablet ? 2.2 : 2.8,
                    ),
                    itemCount: service.features.length,
                    itemBuilder: (context, index) {
                      return _buildFeatureItem(service.features[index], service.color);
                    },
                  ),
                ],
              ),
            ),
            
            SizedBox(width: 40),
            
            // Metrics column
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Business Impact",
                    style: TextStyle(
                      fontSize: isTablet ? 24 : 28,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          service.color.withOpacity(0.15),
                          Colors.black.withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: service.color.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: service.color.withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: service.metrics.entries.map((entry) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: service.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    entry.value,
                                    style: TextStyle(
                                      fontSize: 8,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  entry.key,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  
                  // Testimonial
                  if (service.testimonial != null) ...[
                    SizedBox(height: 30),
                    Text(
                      "Client Testimonial",
                      style: TextStyle(
                        fontSize: isTablet ? 24 : 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      padding: EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: service.color.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.format_quote,
                            color: service.color,
                            size: 32,
                          ),
                          SizedBox(height: 15),
                          Text(
                            service.testimonial!.quote,
                            style: TextStyle(
                              fontSize: 16,
                              fontStyle: FontStyle.italic,
                              color: Colors.white,
                              height: 1.6,
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: service.color,
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      service.color,
                                      service.color.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    service.testimonial!.author.substring(0, 1),
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 15),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.testimonial!.author,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    service.testimonial!.position,
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
        
        SizedBox(height: 60),
        
        // Industries section
        Text(
          "Industry Applications",
          style: TextStyle(
            fontSize: isTablet ? 24 : 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 20),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: service.industries.map((industry) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 15,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: service.color.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    industry.icon,
                    color: service.color,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    industry.name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  // DESKTOP: Feature item
  Widget _buildFeatureItem(String feature, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check,
              size: 16,
              color: color,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              feature,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // DESKTOP: Service card
  Widget _buildDesktopServiceCard(EnterpriseService service) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
    
    return Container(
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: service.color.withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background image
            Image.network(
              service.image,
              height: 400,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 400,
                  width: double.infinity,
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: service.color,
                    ),
                  ),
                );
              },
            ),
            
            // Gradient overlay
            Container(
              height: 400,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.7),
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: [0.4, 0.7, 1.0],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: EdgeInsets.all(40),
              child: Row(
                children: [
                  Expanded(
                    flex: isTablet ? 6 : 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Badge
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: service.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: service.color.withOpacity(0.4),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.verified,
                                size: 18,
                                color: service.color,
                              ),
                              SizedBox(width: 8),
                              Text(
                                service.badgeText,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        
                        SizedBox(height: 25),
                        
                        // Title
                        Text(
                          service.title,
                          style: TextStyle(
                            fontSize: isTablet ? 36 : 42,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            height: 1.1,
                          ),
                        ),
                        
                        SizedBox(height: 20),
                        
                        // Description
                        Text(
                          service.longDescription,
                          style: TextStyle(
                            fontSize: isTablet ? 16 : 18,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Action button
                        OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(
                              color: service.color,
                              width: 2,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 30,
                              vertical: 15,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Learn More",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Empty space for right side
                  Expanded(
                    flex: isTablet ? 4 : 5,
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CTA Section for both mobile and desktop
  Widget _buildCtaSection(bool isMobile, bool isTablet) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : isTablet ? 60 : 100,
      ),
      padding: EdgeInsets.all(isMobile ? 30 : 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _services[_selectedServiceIndex].color.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _services[_selectedServiceIndex].color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _services[_selectedServiceIndex].color.withOpacity(0.2),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 15),
          ),
        ],
      ),
      child: isMobile
          ? Column(
              children: [
                Text(
                  "Ready to Start Your Project?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Contact our team to discuss your requirements and discover how our solutions can help your organization achieve its goals.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withOpacity(0.9),
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _services[_selectedServiceIndex].color,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    "Get in Touch",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ready to Start Your Project?",
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Contact our team to discuss your requirements and discover how our solutions can help your organization achieve its goals.",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 18,
                          color: Colors.white.withOpacity(0.9),
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 40),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _services[_selectedServiceIndex].color,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 18,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          "Get in Touch",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
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
}

// Simplified model classes for the responsive design
class EnterpriseService {
  final String title;
  final Color color;
  final String image;
  final String badgeText;
  final String description;
  final String longDescription;
  final List<String> features;
  final Map<String, String> metrics;
  final List<Industry> industries;
  final Testimonial? testimonial;

  EnterpriseService({
    required this.title,
    required this.color,
    required this.image,
    required this.badgeText,
    required this.description,
    required this.longDescription,
    required this.features,
    required this.metrics,
    required this.industries,
    this.testimonial,
  });
}

class Industry {
  final String name;
  final IconData icon;

  Industry({required this.name, required this.icon});
}

class Testimonial {
  final String quote;
  final String author;
  final String position;

  Testimonial({
    required this.quote,
    required this.author,
    required this.position,
  });
}