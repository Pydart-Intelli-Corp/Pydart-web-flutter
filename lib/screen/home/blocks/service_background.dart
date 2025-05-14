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
  int? _hoveredServiceIndex;
  // Service state
  int _selectedServiceIndex = 0;
  bool _isHoveringTitle = false;
  Map<int, bool> _expandedPanels = {};
  
  // Property to track selected capability for each service
  Map<int, int?> _selectedCapabilityIndices = {};
  
  // New property to track hovered capability for each service
  Map<int, int?> _hoveredCapabilityIndices = {};
  
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
        "Custom Algorithm Development",
         "Neural Network Architecture Design",
         "Reinforcement Learning Systems",
         "AI Ethics & Bias Mitigation",
         "Intelligent Process Optimization",
         "Computer Vision Quality Control",
         "Speech Recognition & Synthesis",
         "Anomaly Detection Systems",
         "Human-Robot Collab Frameworks",
         "Time Series Forecasting",
         "Cognitive Computing Solutions"
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
      // Add capability-specific descriptions
      capabilityDescriptions: {
        "Machine Learning & Deep Learning": "Our advanced ML solutions use neural networks and deep learning to extract insights from complex data and enable intelligent decision-making across your business processes.",
        "Computer Vision Systems": "Cutting-edge vision systems that can identify objects, detect anomalies, and automate visual inspection tasks with superhuman accuracy and consistency.",
        "Robotic Process Automation (RPA)": "Streamline repetitive tasks and workflows by implementing intelligent software robots that mimic human actions, reducing errors and freeing up staff for higher-value work.",
        "Natural Language Processing": "Transform how your organization handles text and speech data with NLP solutions that understand, analyze, and generate human language for improved customer interactions.",
        "Predictive Analytics": "Leverage historical data and machine learning algorithms to forecast trends, identify opportunities, and anticipate problems before they occur.",
      },
      // Add capability-specific testimonials
      capabilityTestimonials: {
        "Machine Learning & Deep Learning": Testimonial(
          quote: "Their custom machine learning models have transformed our ability to predict customer churn with 94% accuracy, allowing us to proactively address retention and save millions annually.",
          author: "Sarah Johnson",
          position: "Head of Data Science, Enterprise Solutions Inc.",
        ),
        "Computer Vision Systems": Testimonial(
          quote: "The computer vision quality control system they implemented reduced defects by 87% while processing inspection tasks 15x faster than our previous manual methods.",
          author: "David Rodriguez",
          position: "VP of Manufacturing, Precision Products",
        ),
        "Robotic Process Automation (RPA)": Testimonial(
          quote: "By implementing RPA across our finance department, we've reduced processing time by 68% and virtually eliminated data entry errors, transforming our operational efficiency.",
          author: "Jennifer Lee",
          position: "CFO, Global Financial Services",
        ),
      },
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
        "High-Performance Systems",
         "Multi-Cloud Strategy & Implementation",
         "Container Orchestration (Kubernetes)",
         "Event-Driven Architectures",
         "Cloud Security & Compliance",
         "Service Mesh Implementation",
         "Distributed System Design",
         "Infrastructure as Code (IaC)",
         "Progressive Web Applications",
         "Real-Time Data Processing",
         "GraphQL API Development"
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
      capabilityDescriptions: {
        "Cloud-Native Applications": "We design and build applications specifically for cloud environments, leveraging cloud services for maximum scalability, resilience, and operational efficiency.",
        "Microservices Architecture": "Our microservices approach breaks down complex applications into manageable, independently deployable services that enable faster development cycles and enhanced resilience.",
        "API Design & Development": "We create robust, secure, and developer-friendly APIs that connect your systems and enable seamless integration with partners and third-party services."
      },
      capabilityTestimonials: {
        "Cloud-Native Applications": Testimonial(
          quote: "The cloud-native application they built for us handles 300% more traffic than our previous system while reducing our infrastructure costs by over 40%. The architecture scales beautifully during peak seasons.",
          author: "James Thompson",
          position: "CTO, Global E-Commerce Platform",
        ),
        "Microservices Architecture": Testimonial(
          quote: "Moving to their microservices architecture transformed our development velocity. We now deploy new features 8x faster with dramatically fewer production incidents.",
          author: "Elena Garcia",
          position: "VP of Engineering, SaaS Solutions Inc.",
        ),
      },
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
        "Mobile Security Protocols",
         "Offline-First App Architecture",
         "Mobile UX/UI Design Systems",
         "Biometric Authentication",
         "Push Notification Strategies",
         "Mobile Analytics Implementation",
         "App Store Optimization (ASO)",
         "Mobile Performance Optimization",
         "In-App Purchase Systems",
         "Mobile Backend as a Service (MBaaS)",
         "Accessibility & Inclusive Design"
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
      capabilityDescriptions: {
        "Flutter Cross-Platform Solutions": "Our Flutter expertise allows us to build beautiful, natively compiled applications for mobile, web, and desktop from a single codebase, reducing development time and maintenance costs.",
        "AR/VR Mobile Experiences": "We create immersive augmented and virtual reality experiences that transform how users interact with your products and services, driving engagement and creating memorable brand experiences.",
      },
      capabilityTestimonials: {
        "Flutter Cross-Platform Solutions": Testimonial(
          quote: "Their Flutter implementation allowed us to launch on iOS and Android simultaneously, cutting our time-to-market in half while maintaining a premium user experience that our customers love.",
          author: "Michelle Lee",
          position: "Product Director, Retail Innovation",
        ),
      },
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
        "IoT Security & Encryption",
          "Wireless Protocol Implementation",
         "Digital Twin Development",
         "FPGA & Hardware Acceleration",
         "Environmental Monitoring Systems",
         "IoT Data Analytics Pipelines",
         "Mesh Network Architectures",
         "Remote Device Management",
         "OTA Update Systems",
         "IoT Cloud Integration",
         "Industrial IoT (IIoT) Solutions"
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
      capabilityDescriptions: {
        "Edge Computing Solutions": "Our edge computing solutions process data locally at the edge of the network, reducing latency, bandwidth usage, and cloud computing costs while improving system reliability and privacy.",
        "IoT Security & Encryption": "We implement robust security protocols and encryption techniques to protect IoT ecosystems from vulnerabilities, ensuring data integrity and device protection.",
      },
      capabilityTestimonials: {
        "Edge Computing Solutions": Testimonial(
          quote: "Their edge computing implementation reduced our data transmission costs by 75% while enabling real-time analytics that previously wasn't possible with our cloud-only architecture.",
          author: "Robert Chen",
          position: "Director of Operations Technology, Smart Manufacturing",
        ),
      },
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
        "Conversion Rate Optimization",
          "Marketing Automation Systems",
         "Customer Journey Mapping",
         "A/B Testing & Optimization",
         "Influencer Marketing Campaigns",
         "Video Marketing Strategy",
         "Social Listening & Brand Monitoring",
         "Programmatic Advertising",
         "Data-Driven Personalization",
         "Affiliate Marketing Programs",
         "Omnichannel Marketing Integration"
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
      capabilityDescriptions: {
        "Search Engine Optimization (SEO)": "Our comprehensive SEO strategies improve your organic visibility, drive targeted traffic, and increase your rankings for the search terms that matter most to your business.",
        "Content Marketing Strategy": "We develop data-driven content strategies that position you as an industry authority, drive organic traffic, and nurture prospects through every stage of the buyer's journey.",
      },
      capabilityTestimonials: {
        "Search Engine Optimization (SEO)": Testimonial(
          quote: "Their SEO work increased our organic traffic by 215% in just six months, with a 78% improvement in lead quality from organic search. Our most valuable keywords now rank in the top 3 positions.",
          author: "Thomas Anderson",
          position: "Digital Marketing Manager, Enterprise Solutions",
        ),
      },
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
        "Print & Publication Design",
         "Brand Strategy Development",
         "Design Systems Creation",
         "Iconography & Illustration",
         "Responsive Web Design",
         "Information Architecture",
         "Environmental & Exhibition Design",
         "Interactive Design Experiences",
         "Augmented Reality Design",
         "Typography & Font Selection",
         "Photography Direction & Styling"
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
      capabilityDescriptions: {
        "UI/UX Design": "We create intuitive, user-centered digital experiences that balance aesthetic appeal with functional efficiency, driving engagement and conversion metrics for your digital products.",
        "Motion Graphics & Animation": "Our dynamic motion graphics and animations bring your brand to life, creating compelling visual stories that capture attention and improve message retention.",
      },
      capabilityTestimonials: {
        "UI/UX Design": Testimonial(
          quote: "Their UI/UX redesign increased our app's user engagement by 167% and reduced cart abandonment by 42%. The intuitive interface has received overwhelmingly positive feedback from our customers.",
          author: "Sophia Martinez",
          position: "Head of Product, Digital Retail Platform",
        ),
      },
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

    // Initialize hover state
    _hoveredServiceIndex = null;

    // Initialize expanded panels
    for (int i = 0; i < _services.length; i++) {
      _expandedPanels[i] = false;
      _selectedCapabilityIndices[i] = 0; // Select first capability by default
      _hoveredCapabilityIndices[i] = null; // null means no capability hovered
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
 // Background effect
  Widget _buildBackground() {
    final activeServiceIndex = _getActiveServiceIndex();
    
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
                  _services[activeServiceIndex].color.withOpacity(0.3),
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

  // Helper method to select appropriate icon for each metric type
  IconData _getMetricIcon(String metricName) {
    if (metricName.contains("Efficiency") || metricName.contains("Performance")) {
      return Icons.speed;
    } else if (metricName.contains("Cost") || metricName.contains("Infrastructure")) {
      return Icons.savings;
    } else if (metricName.contains("ROI") || metricName.contains("investment")) {
      return Icons.show_chart;
    } else if (metricName.contains("Accuracy") || metricName.contains("Reliability")) {
      return Icons.verified;
    } else if (metricName.contains("Time") || metricName.contains("Speed")) {
      return Icons.timer;
    } else if (metricName.contains("Engagement") || metricName.contains("Generation")) {
      return Icons.people;
    } else if (metricName.contains("Recognition") || metricName.contains("Perception")) {
      return Icons.visibility;
    } else if (metricName.contains("Conversion") || metricName.contains("Rates")) {
      return Icons.shopping_cart;
    } else if (metricName.contains("Scalability") || metricName.contains("Factor")) {
      return Icons.scale;
    } else if (metricName.contains("System") || metricName.contains("Lifetime")) {
      return Icons.update;
    } else if (metricName.contains("Processing") || metricName.contains("Data")) {
      return Icons.memory;
    } else if (metricName.contains("Power") || metricName.contains("Energy")) {
      return Icons.bolt;
    } else {
      return Icons.trending_up;  // Default icon
    }
  }

  // Helper method to get the active capability index
  int _getActiveCapabilityIndex(int serviceIndex) {
    // Prioritize hover state over selection
    return _hoveredCapabilityIndices[serviceIndex] ?? _selectedCapabilityIndices[serviceIndex] ?? 0;
  }

 // Helper method to get the active service index
  int _getActiveServiceIndex() {
    // Use hovered service index if available, otherwise use selected service index
    return _hoveredServiceIndex ?? _selectedServiceIndex;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < _mobileBreakpoint;
    final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
    final isDesktop = size.width >= _tabletBreakpoint;
    final isSmallMobile = size.width < _smallMobileBreakpoint;
    
    // Get active service index (accounts for both hover and selection)
    final activeServiceIndex = _getActiveServiceIndex();

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
                                          ? _services[activeServiceIndex].color.withOpacity(0.7)
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
                      ? _buildMobileServiceContent(_services[activeServiceIndex])
                      : _buildDesktopServiceContent(_services[activeServiceIndex]),
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
              // Reset selected capability when changing service
              _selectedCapabilityIndices[_selectedServiceIndex] = -1;
              // Reset hovered capability when changing service
              _hoveredCapabilityIndices[_selectedServiceIndex] = null;
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
          final isHovered = _hoveredServiceIndex == index;
          final isActive = isSelected || isHovered;
          
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredServiceIndex = index;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredServiceIndex = null;
              });
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedServiceIndex = index;
                  // Reset hovered state when clicked
                  _hoveredServiceIndex = null;
                  // Set first capability as selected when changing service
                  _selectedCapabilityIndices[_selectedServiceIndex] = 0;
                  // Reset hovered capability when changing service
                  _hoveredCapabilityIndices[_selectedServiceIndex] = null;
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
                    color: isActive 
                        ? _services[index].color.withOpacity(0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isActive
                          ? _services[index].color
                          : Colors.white.withOpacity(0.2),
                      width: 2,
                    ),
                    boxShadow: isActive ? [
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
                      fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                      color: isActive ? Colors.white : Colors.white.withOpacity(0.7),
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
// MOBILE: Vertical service content layout with clickable capabilities
Widget _buildMobileServiceContent(EnterpriseService service) {
  final serviceIndex = _selectedServiceIndex;
  final capabilityIndex = _getActiveCapabilityIndex(serviceIndex);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Service card
      _buildMobileServiceCard(service),
      
      SizedBox(height: 30),
      
      // Key capabilities
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
        children: List.generate(service.features.length, (index) {
          final isSelected = _selectedCapabilityIndices[serviceIndex] == index;
          final isHovered = _hoveredCapabilityIndices[serviceIndex] == index;
          final isActive = isSelected || isHovered;
          
          return MouseRegion(
            onEnter: (_) {
              setState(() {
                _hoveredCapabilityIndices[serviceIndex] = index;
              });
            },
            onExit: (_) {
              setState(() {
                _hoveredCapabilityIndices[serviceIndex] = null;
              });
            },
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedCapabilityIndices[serviceIndex] = 
                      isSelected ? -1 : index; // Toggle selection
                });
                // Provide haptic feedback
                HapticFeedback.selectionClick();
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 10),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isActive 
                      ? service.color.withOpacity(0.15) 
                      : Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isActive 
                        ? service.color 
                        : service.color.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: isActive ? [
                    BoxShadow(
                      color: service.color.withOpacity(0.2),
                      blurRadius: 15,
                      offset: Offset(0, 5),
                    )
                  ] : null,
                ),
                child: Row(
                  children: [
                    Icon(
                      isActive ? Icons.check_circle : Icons.check_circle_outline,
                      color: service.color,
                      size: 22,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        service.features[index],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
      
      SizedBox(height: 30),
      
      // Capability details (when capability is selected or hovered)
      if (capabilityIndex != -1) ...[
        Text(
          "Capability Details",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                service.features[capabilityIndex],
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 15),
              Text(
                service.capabilityDescriptions[service.features[capabilityIndex]] ?? 
                  "Our experts deliver industry-leading solutions in ${service.features[capabilityIndex]} to transform your operations and drive competitive advantage.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
        
        SizedBox(height: 30),
      ],
      
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
      
      // Customer Testimonial section - Always visible, but content changes based on selected capability
      Text(
        "Customer Testimonial",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      SizedBox(height: 15),
      Builder(
        builder: (context) {
          // If a capability is selected or hovered, show its testimonial if available
          Testimonial? testimonial;
          final capability = service.features[capabilityIndex];
          testimonial = service.capabilityTestimonials[capability];
          
          // Fall back to the default service testimonial if no capability-specific one exists
          testimonial ??= service.testimonial;
          
          if (testimonial == null) return SizedBox.shrink(); // Safety check
          
          return Container(
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
                  testimonial.quote,
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
                  "— ${testimonial.author}, ${testimonial.position}",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
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
Widget _buildDesktopServiceContent(EnterpriseService service) {
  final size = MediaQuery.of(context).size;
  final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
  final serviceIndex = _selectedServiceIndex;
  final capabilityIndex = _getActiveCapabilityIndex(serviceIndex);
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Main service card
      _buildDesktopServiceCard(service),
      
      SizedBox(height: 60),
      
      // Features and capability details
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
                    final isSelected = _selectedCapabilityIndices[serviceIndex] == index;
                    final isHovered = _hoveredCapabilityIndices[serviceIndex] == index;
                    final isActive = isSelected || isHovered;
                    
                    return MouseRegion(
                      onEnter: (_) {
                        setState(() {
                          _hoveredCapabilityIndices[serviceIndex] = index;
                        });
                      },
                      onExit: (_) {
                        setState(() {
                          _hoveredCapabilityIndices[serviceIndex] = null;
                        });
                      },
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCapabilityIndices[serviceIndex] = 
                                isSelected ? -1 : index; // Toggle selection
                          });
                          // Provide haptic feedback
                          HapticFeedback.selectionClick();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          decoration: BoxDecoration(
                            color: isActive 
                                ? service.color.withOpacity(0.15) 
                                : Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isActive 
                                  ? service.color 
                                  : service.color.withOpacity(0.3),
                              width: 1.5,
                            ),
                            boxShadow: isActive ? [
                              BoxShadow(
                                color: service.color.withOpacity(0.2),
                                blurRadius: 15,
                                offset: Offset(0, 5),
                              )
                            ] : null,
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: service.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  isActive ? Icons.check_circle : Icons.check,
                                  size: 16,
                                  color: service.color,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  service.features[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          
          SizedBox(width: 40),
          
          // Capability details column
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Capability Details",
                  style: TextStyle(
                    fontSize: isTablet ? 24 : 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                _buildCapabilityDetails(service),
                
                // Add testimonial directly under capability details with the same width
                SizedBox(height: 30),
                
                // Only show testimonial when a capability is selected or hovered
                ...[
                  Text(
                    "Customer Testimonial",
                    style: TextStyle(
                      fontSize: isTablet ? 22 : 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  _buildTestimonialContainer(service, capabilityIndex),
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

Widget _buildTestimonialContainer(EnterpriseService service, int capabilityIndex) {
  // Get testimonial specific to the selected capability if available, otherwise use default
  final capability = service.features[capabilityIndex];
  final Testimonial? testimonial = service.capabilityTestimonials[capability] ?? service.testimonial;
  
  if (testimonial == null) return SizedBox.shrink(); // Skip if no testimonial
  
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(25),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          service.color.withOpacity(0.2),
          Colors.black.withOpacity(0.4),
        ],
      ),
      borderRadius: BorderRadius.circular(24),
      border: Border.all(
        color: service.color.withOpacity(0.3),
        width: 1.5,
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quote icon container
        Container(
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.only(right: 15, top: 5),
          decoration: BoxDecoration(
            color: service.color.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.format_quote,
            color: service.color,
            size: 20,
          ),
        ),
        
        // Quote content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                testimonial.quote,
                style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  color: Colors.white,
                  height: 1.6,
                ),
              ),
              SizedBox(height: 15),
              
              // Author info
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: service.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: service.color.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        testimonial.author.substring(0, 1), // First letter of author's name
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        testimonial.author,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        testimonial.position,
                        style: TextStyle(
                          fontSize: 13,
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
    ),
  );
}

Widget _buildCapabilityDetails(EnterpriseService service) {
  final size = MediaQuery.of(context).size;
  final isTablet = size.width >= _mobileBreakpoint && size.width < _tabletBreakpoint;
  final serviceIndex = _selectedServiceIndex;
  final capabilityIndex = _getActiveCapabilityIndex(serviceIndex);
  
  // Always show capability details - there's always an active capability now
  final capability = service.features[capabilityIndex];
  final description = service.capabilityDescriptions[capability] ?? 
      "Our experts deliver industry-leading solutions in $capability to transform your operations and drive competitive advantage.";
  
  return Container(
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
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          capability,
          style: TextStyle(
            fontSize: isTablet ? 22 : 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Text(
          description,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white.withOpacity(0.9),
            height: 1.6,
          ),
        ),
        
        // Metrics section for the capability (optional)
        SizedBox(height: 25),
        Text(
          "Key Metrics",
          style: TextStyle(
            fontSize: isTablet ? 18 : 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Wrap(
          spacing: 15,
          runSpacing: 15,
          children: service.metrics.entries.take(2).map((entry) {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: service.color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _getMetricIcon(entry.key),
                    color: service.color,
                    size: 18,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withOpacity(0.8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
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
  // CTA Section for both mobile and desktop
  Widget _buildCtaSection(bool isMobile, bool isTablet) {
    final activeServiceIndex = _getActiveServiceIndex();
    
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
            _services[activeServiceIndex].color.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: _services[activeServiceIndex].color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: _services[activeServiceIndex].color.withOpacity(0.2),
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
                    backgroundColor: _services[activeServiceIndex].color,
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
                          backgroundColor: _services[activeServiceIndex].color,
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

class EnterpriseService {
  final String title;
  final Color color;
  final String image;
  final String badgeText;
  final String description;
  final String longDescription;
  List<String> features; // Changed from final to allow updating
  final Map<String, String> metrics;
  final List<Industry> industries;
  final Testimonial? testimonial;
  // New properties for capability-specific content
  final Map<String, String> capabilityDescriptions;
  final Map<String, Testimonial> capabilityTestimonials;

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
    this.capabilityDescriptions = const {},
    this.capabilityTestimonials = const {},
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