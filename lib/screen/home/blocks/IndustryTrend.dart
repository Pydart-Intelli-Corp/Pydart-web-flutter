import 'dart:async';
import 'dart:math' as math;
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class CyberpunkIndustryTrendsBlock extends StatefulWidget {
  const CyberpunkIndustryTrendsBlock({super.key});

  @override
  State<CyberpunkIndustryTrendsBlock> createState() => _CyberpunkIndustryTrendsBlockState();
}

class _CyberpunkIndustryTrendsBlockState extends State<CyberpunkIndustryTrendsBlock> with TickerProviderStateMixin {
  // Enhanced responsive breakpoints
  static const double kMobileBreakpoint = 480.0;
  static const double kTabletBreakpoint = 768.0;
  static const double kDesktopBreakpoint = 1024.0;
  static const double kLargeDesktopBreakpoint = 1440.0;

  // Animation controllers
  late AnimationController _backgroundAnimController;
  late AnimationController _pulseAnimController;
  late AnimationController _glitchController;
  late AnimationController _scanlineController;
  late AnimationController _shimmerAnimController;
  late AnimationController _particleController;

  // Grid navigation
  int _currentPage = 0;
  final PageController _pageController = PageController();

  // Scrolling control
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _descriptionSectionKey = GlobalKey();

  // Interaction states
  int _selectedTrendIndex = 0;
  int? _hoveredTrendIndex;
  bool _isHoveringTitle = false;
  final Random _random = Random();
  final List<Particle> _particles = [];

  // Industry Colors
  final Map<String, Color> industryColors = {
    'AI': Color(0xFF00FFFF),
    'Automation': Color(0xFFFF00FF),
    'Robotics': Color(0xFF33FF33),
    'Web Development': Color(0xFFFF3366),
    'Software': Color(0xFF36B2FD),
    'Firmware': Color(0xFFFFC107),
    'Mobile Application': Color(0xFF7C4DFF),
    'Graphics Design': Color(0xFFFF9E80),
    'Digital Marketing': Color(0xFF00E676),
    'Innovative Ideas': Color(0xFF9C27B0),
    'Business Development': Color(0xFFFFD54F),
    'Space': Color(0xFF64B5F6),
  };

  // Background patterns
  final String cyberpunkGridUrl = 'https://i.imgur.com/fOAuDQA.png';
  final String cyberpunkCircuitUrl = 'https://i.imgur.com/QHK5LJl.png';
  final String cyberpunkHologramUrl = 'https://i.imgur.com/RzKQRjD.png';

  // Future market projections
  final List<Map<String, dynamic>> marketStats = [
    {'label': 'Global Tech Market 2030', 'value': '\$12.5T', 'growth': '+142%'},
    {'label': 'AI Integration Rate', 'value': '94.3%', 'growth': '+64.8%'},
    {'label': 'Quantum Computing Market', 'value': '\$1.3T', 'growth': '+856%'},
    {'label': 'Digital Economy Share', 'value': '68.5%', 'growth': '+189%'},
  ];

  // Industry trends with new structure and future focus
  final List<IndustryTrend> trends = [
    IndustryTrend(
      title: "Artificial Intelligence",
      icon: Icons.psychology,
      description: "Neural-symbiotic systems enabling human-AI collaboration paradigms",
      longDescription: "By 2030, AI will evolve beyond current computational models to create neural-symbiotic systems that function as true cognitive partners. These systems will feature bidirectional neural interfaces, emotional intelligence frameworks, and collective intelligence architectures that fundamentally transform how humans and machines collaborate, creating unprecedented capabilities in problem-solving, creativity, and decision-making.",
      badgeText: "NEURAL-SYMBIOSIS",
      color: Color(0xFF00FFFF),
      image: "https://images.unsplash.com/photo-1580927752452-89d86da3fa0a?w=1200",
      features: [
        "Bidirectional Neural Interfaces (Est. 2027)",
        "Emotional Intelligence Frameworks",
        "Self-evolving Algorithm Structures",
        "Quantum-accelerated Machine Learning",
        "Collective Intelligence Networks", 
        "Cognitive Enhancement Platforms"
      ],
      metrics: {
        "Cognitive Bandwidth": "2.3 TB/s by 2028",
        "Human-AI Integration": "96% by 2030",
        "Decision Accuracy": "99.98% by 2029",
      },
      useCases: [
        UseCase(
          industry: "Healthcare",
          icon: Icons.local_hospital,
          description: "Neural diagnostics reducing disease mortality by 87% by 2032"
        ),
        UseCase(
          industry: "Scientific Research",
          icon: Icons.science,
          description: "Discovery acceleration increasing breakthrough rate by 2400%"
        ),
        UseCase(
          industry: "Governance",
          icon: Icons.balance,
          description: "Policy optimization improving societal outcomes by 64%"
        ),
      ],
    ),
    IndustryTrend(
      title: "Advanced Automation",
      icon: Icons.autorenew,
      description: "Autonomous systems with emergent intelligence and self-evolution",
      longDescription: "The next decade will witness automation evolving from rule-based systems to autonomous entities with emergent intelligence capabilities. These systems will demonstrate contextual adaptation, self-directed evolution, and cross-domain learning abilities. By 2035, autonomous systems will operate in environments and scenarios never explicitly programmed, creating solutions that human designers could not anticipate or imagine.",
      badgeText: "AUTONOMOUS-EVOLUTION",
      color: Color(0xFFFF00FF),
      image: "https://images.unsplash.com/photo-1563770660941-10971f2c4254?w=1200",
      features: [
        "Emergent Intelligence Frameworks (Est. 2028)",
        "Zero-instruction Adaptation",
        "Cross-domain Problem Solving",
        "Self-directed Evolutionary Systems",
        "Intent-based Operation",
        "Autonomous Ethical Frameworks"
      ],
      metrics: {
        "Zero-instruction Adaptation": "92% by 2030",
        "Novel Solution Generation": "8.4x human by 2032",
        "Energy Efficiency": "+1200% by 2029",
      },
      useCases: [
        UseCase(
          industry: "Manufacturing",
          icon: Icons.precision_manufacturing,
          description: "Self-evolving production achieving 100% yield by 2031"
        ),
        UseCase(
          industry: "Environmental Management",
          icon: Icons.eco,
          description: "Autonomous ecosystem restoration accelerating by 840%"
        ),
        UseCase(
          industry: "Infrastructure",
          icon: Icons.apartment,
          description: "Self-healing urban systems eliminating 98% of failures"
        ),
      ],
    ),
    IndustryTrend(
      title: "Biomechatronic Systems",
      icon: Icons.smart_toy,
      description: "Integration of biological, mechanical and electronic systems",
      longDescription: "By 2035, the boundaries between biological and mechanical systems will fundamentally blur with the emergence of biomechatronic organisms. These entities will combine engineered biological components, quantum mechanical systems, and advanced neural interfaces to create entirely new classes of systems. These hybrid entities will possess unprecedented adaptability, self-healing capabilities, and organic intelligence that redefines what we consider possible in both robotics and biological enhancement.",
      badgeText: "ORGANIC-SYNTHETIC",
      color: Color(0xFF33FF33),
      image: "https://images.unsplash.com/photo-1625038033239-2297700c9256?w=1200",
      features: [
        "Synthetic Biological Integration (Est. 2029)",
        "Neural-mechanical Interface Systems",
        "Self-healing Material Structures",
        "Biomimetic Locomotion Advanced",
        "Organic Computing Substrates",
        "Micro-scale Swarm Organization"
      ],
      metrics: {
        "Biological-Synthetic Integration": "87% by 2030",
        "Self-healing Capability": "99.4% by 2032",
        "Environmental Adaptation": "12.7x current by 2031",
      },
      useCases: [
        UseCase(
          industry: "Medical",
          icon: Icons.medical_services,
          description: "In-body repair systems enhancing lifespan by 35+ years"
        ),
        UseCase(
          industry: "Extreme Environments",
          icon: Icons.public,
          description: "Exploration of previously inaccessible Earth/space environments"
        ),
        UseCase(
          industry: "Agriculture",
          icon: Icons.grass,
          description: "Yield enhancement in degraded environments by 1200%"
        ),
      ],
    ),
    IndustryTrend(
      title: "Immersive Reality",
      icon: Icons.view_in_ar,
      description: "Post-XR paradigms blending physical and digital existence",
      longDescription: "By 2032, we will transcend current AR/VR/MR paradigms to achieve full immersive reality integration where digital and physical worlds become functionally indistinguishable. These systems will feature full sensory engagement, direct neural rendering, persistent shared realities, and physical-digital continuity that enables entirely new forms of experience, collaboration, and creative expression that extend human perception and cognition beyond current biological limitations.",
      badgeText: "REALITY-SYNTHESIS",
      color: Color(0xFFFF3366),
      image: "https://images.unsplash.com/photo-1547658719-da2b51169166?w=1200",
      features: [
        "Full Sensory Engagement (Est. 2028)",
        "Direct Neural Rendering",
        "Persistent Shared Realities",
        "Physical-Digital Continuity",
        "Time-perception Manipulation",
        "Experience Transfer Protocols"
      ],
      metrics: {
        "Reality Integration": "92% indistinguishable by 2032",
        "Neural Bandwidth": "18.7 TB/s by 2030",
        "Cognitive Enhancement": "+420% by 2031",
      },
      useCases: [
        UseCase(
          industry: "Education",
          icon: Icons.school,
          description: "Neural-direct learning reducing acquisition time by 97%"
        ),
        UseCase(
          industry: "Creative Arts",
          icon: Icons.brush,
          description: "Multi-sensory creation leading to entirely new art forms"
        ),
        UseCase(
          industry: "Human Experience",
          icon: Icons.psychology_alt,
          description: "Perception expansion beyond biological limitations"
        ),
      ],
    ),
    IndustryTrend(
      title: "Quantum Computing",
      icon: Icons.memory,
      description: "Practical quantum systems revolutionizing computational paradigms",
      longDescription: "The 2030s will see quantum computing evolve from specialized applications to become a mainstream computational paradigm. Fault-tolerant systems with millions of stable qubits will enable practical applications in areas previously beyond computational reach. These systems will leverage room-temperature quantum effects, photonic quantum processors, and topological quantum memory to create a computational environment that fundamentally transforms our approach to complex problems across all scientific and industrial domains.",
      badgeText: "QUANTUM-SUPREMACY",
      color: Color(0xFF36B2FD),
      image: "https://images.unsplash.com/photo-1635070041078-e363dbe005cb?w=1200",
      features: [
        "Mega-qubit Stable Systems (Est. 2030)",
        "Room-temperature Quantum Processing",
        "Photonic Quantum Computing",
        "Distributed Quantum Networks",
        "Quantum-classical Hybrid Systems",
        "Topological Quantum Memory"
      ],
      metrics: {
        "Stable Qubits": "5M+ by 2031",
        "Quantum Advantage": "10^12x classical by 2032",
        "Problem Complexity": "NP-complete in minutes by 2030",
      },
      useCases: [
        UseCase(
          industry: "Materials Science",
          icon: Icons.science,
          description: "Perfectly efficient energy materials by 2030"
        ),
        UseCase(
          industry: "Pharmaceuticals",
          icon: Icons.medication,
          description: "In-silico drug design accuracy reaching 99.99%"
        ),
        UseCase(
          industry: "Climate Modeling",
          icon: Icons.cloud,
          description: "Perfect climate prediction enabling optimal intervention"
        ),
      ],
    ),
    IndustryTrend(
      title: "Neuromorphic Hardware",
      icon: Icons.developer_board,
      description: "Brain-inspired computing architectures with self-organization",
      longDescription: "By 2035, computing will be dominated by neuromorphic systems that replicate and extend biological neural architectures. These systems will feature self-organizing circuitry, adaptive hardware configurations, molecular-scale processing elements, and structural learning capabilities. Operating with extreme energy efficiency while demonstrating emergent cognitive functions, these systems will enable entirely new computational approaches that blur the distinction between memory and processing while achieving intelligence that operates on fundamentally different principles than current AI.",
      badgeText: "ORGANIC-COMPUTING",
      color: Color(0xFFFFC107),
      image: "https://images.unsplash.com/photo-1518770660439-4636190af475?w=1200",
      features: [
        "Self-organizing Circuitry (Est. 2028)",
        "Molecular-scale Processing",
        "Structural Learning Systems",
        "Energy-harvesting Compute",
        "Adaptive Hardware Configuration",
        "Probabilistic Logic Architecture"
      ],
      metrics: {
        "Energy Efficiency": "0.001% of current by 2032",
        "Neural Density": "10^15 synapses/cm³ by 2030",
        "Self-organization": "100% autonomous by 2033",
      },
      useCases: [
        UseCase(
          industry: "Edge Intelligence",
          icon: Icons.podcasts,
          description: "Autonomous systems with human-level cognition at milliwatts"
        ),
        UseCase(
          industry: "Biological Interface",
          icon: Icons.biotech,
          description: "Direct neural integration with biological systems"
        ),
        UseCase(
          industry: "Environmental Computing",
          icon: Icons.public,
          description: "Planet-scale distributed intelligence network"
        ),
      ],
    ),
    IndustryTrend(
      title: "Extended Intelligence",
      icon: Icons.smartphone,
      description: "Distributed cognitive systems extending human capabilities",
      longDescription: "The 2030s will see the emergence of Extended Intelligence (EI) ecosystems that function as distributed cognitive layers augmenting human capabilities. These systems will feature cognitive interfaces that predict and enhance human thought, distributed intelligence agents operating across devices, ambient computing environments that respond to context and need, and neural enhancement technologies that directly amplify human cognitive processing, memory, and creativity.",
      badgeText: "COGNITIVE-EXTENSION",
      color: Color(0xFF7C4DFF),
      image: "https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=1200",
      features: [
        "Cognitive Interface Prediction (Est. 2026)",
        "Distributed Intelligence Agents",
        "Ambient Computing Environments",
        "Neural Enhancement Technology",
        "Multi-mind Collaboration Networks",
        "Intention-based Interaction"
      ],
      metrics: {
        "Cognitive Enhancement": "+840% by 2032",
        "Thought-action Gap": "<2ms by 2030",
        "Memory Extension": "100,000x biological by 2031",
      },
      useCases: [
        UseCase(
          industry: "Creative Fields",
          icon: Icons.create,
          description: "Idea amplification creating 87x output acceleration"
        ),
        UseCase(
          industry: "Professional Knowledge",
          icon: Icons.psychology,
          description: "Expert knowledge integration increasing capability by 1200%"
        ),
        UseCase(
          industry: "Global Collaboration",
          icon: Icons.groups,
          description: "Multi-mind hive capabilities with seamless integration"
        ),
      ],
    ),
    IndustryTrend(
      title: "Synthetic Media",
      icon: Icons.brush,
      description: "Generative systems creating indistinguishable synthetic reality",
      longDescription: "By 2030, synthetic media will achieve perfect indistinguishability from reality while enabling entirely new forms of creative expression. These systems will integrate concept-to-reality generation, contextual understanding and adaptation, emotional and narrative intelligence, and multi-sensory content generation. Moving far beyond current generative AI, these platforms will enable non-specialists to create sophisticated multi-sensory experiences that transform entertainment, education, communication, and creative expression.",
      badgeText: "REALITY-SYNTHESIS",
      color: Color(0xFFFF9E80),
      image: "https://images.unsplash.com/photo-1545670723-196ed0954986?w=1200",
      features: [
        "Perfect Indistinguishability (Est. 2028)",
        "Concept-to-Reality Generation",
        "Emotional Intelligence Integration",
        "Narrative Understanding",
        "Multi-sensory Content Creation",
        "Contextual Adaptation Systems"
      ],
      metrics: {
        "Reality Match": "100% indistinguishable by 2028",
        "Creation Speed": "1000x current by 2030",
        "Creative Possibility Space": "infinite by 2029",
      },
      useCases: [
        UseCase(
          industry: "Entertainment",
          icon: Icons.movie,
          description: "Personalized adaptive narratives with perfect emotional resonance"
        ),
        UseCase(
          industry: "Education",
          icon: Icons.school,
          description: "Experiential learning in infinitely adaptive scenarios"
        ),
        UseCase(
          industry: "Design",
          icon: Icons.design_services,
          description: "Thought-to-reality creation without technical limitations"
        ),
      ],
    ),
    IndustryTrend(
      title: "Neuromarketing",
      icon: Icons.trending_up,
      description: "Emotion-responsive systems with perfect personalization",
      longDescription: "Marketing in the 2030s will transform into neurologically-informed systems that understand and respond to individual emotional and cognitive states. These platforms will leverage real-time neurological data analysis, emotional state prediction and influence, narrative personalization at the individual level, and subconscious preference mapping to create experiences that resonate perfectly with each person's unique psychological makeup, leading to unprecedented engagement and ethical questions about the boundaries of influence.",
      badgeText: "EMOTION-INTELLIGENCE",
      color: Color(0xFF00E676),
      image: "https://images.unsplash.com/photo-1533750516457-a7f992034fec?w=1200",
      features: [
        "Neurological Response Prediction (Est. 2027)",
        "Emotional State Influence",
        "Individual Narrative Personalization",
        "Subconscious Preference Mapping",
        "Biometric Response Optimization",
        "Ethical Boundary Systems"
      ],
      metrics: {
        "Emotional Resonance": "99.8% by 2030",
        "Influence Effectiveness": "+1240% by 2029",
        "Personalization Granularity": "Individual neural patterns by 2028",
      },
      useCases: [
        UseCase(
          industry: "Brand Engagement",
          icon: Icons.branding_watermark,
          description: "Perfect brand-individual alignment achieving 100% resonance"
        ),
        UseCase(
          industry: "Product Design",
          icon: Icons.design_services,
          description: "Neurological satisfaction optimization at individual level"
        ),
        UseCase(
          industry: "Public Communication",
          icon: Icons.campaign,
          description: "Message adaptation to diverse psychological profiles"
        ),
      ],
    ),
    IndustryTrend(
      title: "Transdisciplinary Innovation",
      icon: Icons.lightbulb,
      description: "AI-enabled knowledge synthesis across all human domains",
      longDescription: "The 2030s will see innovation accelerate through systems that enable transdisciplinary knowledge integration and synthesis beyond human cognitive limitations. These platforms will feature comprehensive knowledge representation across all fields, autonomous cross-domain connection systems, conceptual translation between disciplines, and pattern recognition across previously isolated domains of knowledge. This will lead to innovative breakthroughs at unprecedented rates by identifying non-obvious connections between fields that humans alone cannot perceive.",
      badgeText: "KNOWLEDGE-SYNTHESIS",
      color: Color(0xFF9C27B0),
      image: "https://images.unsplash.com/photo-1580894742597-87bc8789db3d?w=1200",
      features: [
        "Cross-domain Knowledge Integration (Est. 2029)",
        "Conceptual Translation Systems",
        "Pattern Recognition Across Fields",
        "Innovation Pathway Generation",
        "Autonomous Discovery Platforms",
        "Hidden Connection Mapping"
      ],
      metrics: {
        "Knowledge Integration": "All human domains by 2032",
        "Breakthrough Rate": "+8400% by 2033",
        "Concept Translation": "100% fidelity by 2031",
      },
      useCases: [
        UseCase(
          industry: "Scientific Research",
          icon: Icons.science,
          description: "Knowledge synthesis across all scientific disciplines"
        ),
        UseCase(
          industry: "Technology Development",
          icon: Icons.devices,
          description: "Cross-implementation of solutions from disparate fields"
        ),
        UseCase(
          industry: "Social Innovation",
          icon: Icons.groups,
          description: "Complex problem solving through multi-domain analysis"
        ),
      ],
    ),
    IndustryTrend(
      title: "Algorithmic Organizations",
      icon: Icons.business_center,
      description: "AI-native entities that transcend traditional business structures",
      longDescription: "By 2035, we'll witness the emergence of algorithmic organizations—entities that operate through autonomous decision systems rather than traditional management hierarchies. These organizations will feature self-optimizing operational structures, dynamic resource allocation, algorithmic governance systems, and emergent strategy generation. They will demonstrate unprecedented adaptability and efficiency while raising fundamental questions about the future of work, leadership, and organizational design in an AI-native economic environment.",
      badgeText: "AUTONOMOUS-ENTITIES",
      color: Color(0xFFFFD54F),
      image: "https://images.unsplash.com/photo-1444653614773-995cb1ef9efa?w=1200",
      features: [
        "Self-optimizing Structure (Est. 2030)",
        "Algorithmic Governance Systems",
        "Emergent Strategy Generation",
        "Dynamic Resource Allocation",
        "Multi-entity Coordination Networks",
        "Algorithmic Ethical Frameworks"
      ],
      metrics: {
        "Operational Efficiency": "+970% by 2032",
        "Adaptation Speed": "<5 minutes to major shifts by 2031",
        "Resource Utilization": "99.8% optimal by 2034",
      },
      useCases: [
        UseCase(
          industry: "Global Operations",
          icon: Icons.public,
          description: "Self-organizing supply networks with 100% efficiency"
        ),
        UseCase(
          industry: "Innovation Ecosystems",
          icon: Icons.psychology,
          description: "Self-directing R&D systems 87x more productive than human-led"
        ),
        UseCase(
          industry: "Market Adaptation",
          icon: Icons.trending_up,
          description: "Real-time business evolution outcompeting traditional models"
        ),
      ],
    ),
    IndustryTrend(
      title: "Space-based Economy",
      icon: Icons.rocket_launch,
      description: "Industrialization of near-Earth and lunar environments",
      longDescription: "The 2030s will witness the emergence of a true space-based economy with large-scale industrialization of near-Earth orbit and lunar environments. This expansion will include orbital manufacturing and energy generation, lunar resource utilization, space-based data processing, and the emergence of an entirely new economic sector with unique properties and opportunities. These developments will fundamentally reshape Earth's economic landscape while opening unprecedented opportunities for solving resource limitations and enabling technologies impossible in terrestrial environments.",
      badgeText: "ORBITAL-INDUSTRY",
      color: Color(0xFF64B5F6),
      image: "https://images.unsplash.com/photo-1446776811953-b23d57bd21aa?w=1200",
      features: [
        "Lunar Manufacturing Bases (Est. 2031)",
        "Space-based Solar Power",
        "Orbital Data Centers",
        "Microgravity Material Production",
        "Asteroid Resource Utilization",
        "Space Tourism Infrastructure"
      ],
      metrics: {
        "Orbital Manufacturing": "1.2T by 2035",
        "Space-based Energy": "27% of Earth consumption by 2040",
        "Lunar Resource Utilization": "6.4M tons annually by 2038",
      },
      useCases: [
        UseCase(
          industry: "Advanced Materials",
          icon: Icons.layers,
          description: "Zero-gravity manufacturing enabling impossible terrestrial materials"
        ),
        UseCase(
          industry: "Energy",
          icon: Icons.bolt,
          description: "Space-based solar providing unlimited clean energy"
        ),
        UseCase(
          industry: "Computing",
          icon: Icons.memory,
          description: "Radiation-enhanced quantum processing with 100x performance"
        ),
      ],
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
    
    _glitchController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    
    _scanlineController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    )..repeat();
    
    _shimmerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
    
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )..repeat();
    
    // Initialize particles
    _initParticles();
    
    // Randomized glitch effect
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_random.nextDouble() > 0.6) {
        _glitchController.reset();
        _glitchController.forward();
      }
    });
    
    // Particle animation
    _particleController.addListener(() {
      _updateParticles();
    });

    // Provide haptic feedback for immersion at startup
    HapticFeedback.mediumImpact();
  }

  void _initParticles() {
    // Create initial particles
    for (int i = 0; i < 120; i++) {
      _particles.add(Particle(
        position: Offset(
          _random.nextDouble() * 1000,
          _random.nextDouble() * 1000,
        ),
        speed: 0.5 + _random.nextDouble() * 2,
        radius: 1 + _random.nextDouble() * 2,
        color: [
          Color(0xFF00FFFF),
          Color(0xFFFF00FF),
          Color(0xFF33FF33),
          Color(0xFFFF3366),
        ][_random.nextInt(4)].withOpacity(0.1 + _random.nextDouble() * 0.4),
      ));
    }
  }
  
  void _updateParticles() {
    if (!mounted) return;
    
    setState(() {
      for (var particle in _particles) {
        // Move particles upward with slight x variation
        particle.position = Offset(
          particle.position.dx + (math.sin(particle.position.dy * 0.01) * 0.5),
          particle.position.dy - particle.speed,
        );
        
        // Reset particles that move off screen
        if (particle.position.dy < 0) {
          particle.position = Offset(
            _random.nextDouble() * 1000,
            1000 + _random.nextDouble() * 100,
          );
        }
      }
    });
  }
  
  // Add scroll method to scroll to description section
  void _scrollToDescriptionSection() {
    // Add a small delay to ensure the UI has updated with the new selected trend
    Future.delayed(Duration(milliseconds: 100), () {
      if (_descriptionSectionKey.currentContext != null) {
        Scrollable.ensureVisible(
          _descriptionSectionKey.currentContext!,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeInOut,
          alignment: 0.0, // Align to the top of the viewport
        );
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimController.dispose();
    _pulseAnimController.dispose();
    _glitchController.dispose();
    _scanlineController.dispose();
    _shimmerAnimController.dispose();
    _particleController.dispose();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Helper method to get active trend index (considers both hover and selection)
  int _getActiveTrendIndex() {
    return _hoveredTrendIndex ?? _selectedTrendIndex;
  }

  // Background effect
  Widget _buildBackground() {
    final activeTrendIndex = _getActiveTrendIndex();
    
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _backgroundAnimController,
        builder: (context, _) {
          return Container(
            decoration: BoxDecoration(
              gradient: SweepGradient(
                center: Alignment.center,
                startAngle: 0,
                endAngle: 2 * math.pi,
                transform: GradientRotation(_backgroundAnimController.value * 2 * math.pi),
                colors: [
                  Colors.black,
                  trends[activeTrendIndex].color.withOpacity(0.3),
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
    // Enhanced responsive layout detection
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    
    // Responsive breakpoints
    final isMobile = screenWidth < kTabletBreakpoint;
    final isSmallMobile = screenWidth < kMobileBreakpoint;
    final isTablet = screenWidth >= kTabletBreakpoint && screenWidth < kDesktopBreakpoint;
    final isDesktop = screenWidth >= kDesktopBreakpoint;
    final isLargeDesktop = screenWidth >= kLargeDesktopBreakpoint;
    
    // Dynamically calculate font sizes
    final titleFontSize = isSmallMobile 
      ? 32.0 
      : isMobile 
        ? 38.0 
        : isTablet 
          ? 44.0 
          : isLargeDesktop 
            ? 52.0 
            : 48.0;
            
    final subtitleFontSize = isSmallMobile 
      ? 13.0 
      : isMobile 
        ? 15.0 
        : isTablet 
          ? 16.0 
          : 18.0;
          
    // Get active trend
    final activeTrendIndex = _getActiveTrendIndex();
    final activeTrend = trends[activeTrendIndex];

    return Container(
      width: double.infinity,
      child: Stack(
        children: [
          // Enhanced background
          _buildBackground(),
          
          // Circuit pattern background with caching
          Positioned.fill(
            child: Opacity(
              opacity: 0.15,
              child: CachedNetworkImage(
                imageUrl: cyberpunkCircuitUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: Colors.black),
                errorWidget: (context, url, error) => Container(color: Colors.black),
              ),
            ),
          ),
          
          // Particle background
          Positioned.fill(
            child: CustomPaint(
              painter: ParticlePainter(_particles),
            ),
          ),
          
          // Scanline effect
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _scanlineController,
              builder: (context, child) {
                return ShaderMask(
                  shaderCallback: (rect) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.white.withOpacity(0.2),
                        Colors.transparent,
                      ],
                      stops: [
                        0.0,
                        _scanlineController.value,
                        _scanlineController.value + 0.02,
                      ],
                    ).createShader(rect);
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                );
              },
            ),
          ),
          
          // Glitch effect
          AnimatedBuilder(
            animation: _glitchController,
            builder: (context, child) {
              if (_glitchController.value > 0) {
                final intensity = math.sin(_glitchController.value * math.pi);
                return Positioned.fill(
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Colors.transparent,
                          activeTrend.color.withOpacity(0.8 * intensity),
                          activeTrend.color.withOpacity(0.8 * intensity),
                          Colors.transparent,
                        ],
                        stops: [
                          0.0,
                          0.3 + (_random.nextDouble() * 0.2),
                          0.6 + (_random.nextDouble() * 0.2),
                          1.0,
                        ],
                      ).createShader(rect);
                    },
                    child: Container(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
          
          // Main content with scrolling
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section with shimmer effect
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
                      // Digital badge
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
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  border: Border.all(
                                    color: activeTrend.color.withOpacity(0.4),
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  "FUTURE//MATRIX v2.0.3.5",
                                  style: TextStyle(
                                    fontFamily: "JetBrainsMono",
                                    color: activeTrend.color,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            );
                          }
                        ),
                      ),
                      
                      SizedBox(height: isMobile ? 20 : 30),
                      
                      // Main title with shimmer effect
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
                                "INDUSTRY INSIGHTS 2035",
                                style: TextStyle(
                                  fontSize: titleFontSize,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontFamily: "SpaceGrotesk",
                                  height: 1.1,
                                  letterSpacing: -1,
                                  shadows: [
                                    BoxShadow(
                                      color: _isHoveringTitle
                                          ? activeTrend.color.withOpacity(0.7)
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
                      
                      // Subtitle with typing effect
                      SizedBox(height: isMobile ? 16 : 24),
                      Container(
                        height: isMobile ? 80 : 50,
                        child: DefaultTextStyle(
                          style: TextStyle(
                            fontSize: subtitleFontSize,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                          ),
                          child: AnimatedTextKit(
                            animatedTexts: [
                              TypewriterAnimatedText(
                                'Forecasting the next wave of technological revolution that will transform industries and redefine human potential over the coming decade.',
                                speed: const Duration(milliseconds: 40),
                              ),
                              TypewriterAnimatedText(
                                'Advanced predictive analytics and trend mapping reveal emerging technologies poised to create paradigm shifts across the entire technological landscape.',
                                speed: const Duration(milliseconds: 40),
                              ),
                            ],
                            repeatForever: true,
                            pause: const Duration(milliseconds: 3000),
                          ),
                        ),
                      ),
                      
                      // Market Stats Scroller - Adaptive layout
                      SizedBox(height: isMobile ? 20 : 30),
                      Container(
                        height: isSmallMobile ? 90 : isMobile ? 70 : 90,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallMobile ? 8 : 16, 
                          vertical: isSmallMobile ? 8 : 12
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(
                            color: activeTrend.color.withOpacity(0.4),
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: activeTrend.color.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: PageView.builder(
                          controller: PageController(
                            viewportFraction: isSmallMobile 
                              ? 1.0 
                              : isMobile 
                                ? 0.5 
                                : isTablet 
                                  ? 0.33 
                                  : 0.25,
                            initialPage: 0,
                          ),
                          scrollDirection: Axis.horizontal,
                          itemCount: marketStats.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    marketStats[index]['label'],
                                    style: TextStyle(
                                      fontFamily: "JetBrainsMono",
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        marketStats[index]['value'],
                                        style: TextStyle(
                                          fontFamily: "JetBrainsMono",
                                          color: activeTrend.color,
                                          fontSize: isMobile ? 18 : 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                        ),
                                        child: Text(
                                          marketStats[index]['growth'],
                                          style: TextStyle(
                                            fontFamily: "JetBrainsMono",
                                            color: Colors.green,
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                
                // NEW: Grid Trend Layout
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : isTablet ? 60 : 100,
                  ),
                  child: isMobile
                      ? _buildMobileTrendGrid()
                      : _buildDesktopTrendGrid(isTablet),
                ),
                
                SizedBox(height: isMobile ? 30 : 60),
                
                // Trend detail section
                Container(
                  key: _descriptionSectionKey, // Add key for scrolling
                  margin: EdgeInsets.symmetric(
                    horizontal: isMobile ? 24 : isTablet ? 60 : 100,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: activeTrend.color.withOpacity(0.4),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: activeTrend.color.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isMobile ? 20 : 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Trend header
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: activeTrend.color.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                activeTrend.icon,
                                color: activeTrend.color,
                                size: 24,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    activeTrend.title,
                                    style: TextStyle(
                                      fontSize: isMobile ? 24 : 28,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: activeTrend.color.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: activeTrend.color.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      activeTrend.badgeText,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: activeTrend.color,
                                      ),
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
                          activeTrend.longDescription,
                          style: TextStyle(
                            fontSize: isMobile ? 15 : 17,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.6,
                          ),
                        ),
                        
                        SizedBox(height: 30),
                        
                        // Features and metrics section
                        isMobile
                            ? _buildMobileTrendDetail(activeTrend)
                            : _buildDesktopTrendDetail(activeTrend, isTablet),
                            
                        SizedBox(height: 30),
                        
                        // Industry applications
                        Text(
                          "Industry Applications",
                          style: TextStyle(
                            fontSize: isMobile ? 20 : 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 15),
                        
                        // Use case cards grid
                        GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            childAspectRatio: isMobile ? 3 : 2.5,
                          ),
                          itemCount: activeTrend.useCases.length,
                          itemBuilder: (context, index) {
                            final useCase = activeTrend.useCases[index];
                            return Container(
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: activeTrend.color.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: activeTrend.color.withOpacity(0.1),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      useCase.icon,
                                      color: activeTrend.color,
                                      size: 24,
                                    ),
                                  ),
                                  SizedBox(width: 15),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          useCase.industry,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          useCase.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                
                // CTA section
                SizedBox(height: isMobile ? 40 : 60),
                _buildCtaSection(isMobile, isTablet, activeTrend),
                
                // Footer spacing
                SizedBox(height: isMobile ? 60 : 80),
              ],
            ),
          ),
          
          // Top and bottom edge glowing borders
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    activeTrend.color.withOpacity(0),
                    activeTrend.color,
                    Color(0xFFFF00FF),
                    activeTrend.color.withOpacity(0),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: activeTrend.color.withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFFF00FF).withOpacity(0),
                    Color(0xFFFF00FF),
                    activeTrend.color,
                    Color(0xFFFF00FF).withOpacity(0),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFF00FF).withOpacity(0.6),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // NEW: Mobile trend grid layout
  Widget _buildMobileTrendGrid() {
    final activeTrend = trends[_selectedTrendIndex];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FUTURE TECHNOLOGY VECTORS",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: "JetBrainsMono",
          ),
        ),
        SizedBox(height: 15),
        Container(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
                _selectedTrendIndex = index;
              });
              // Scroll to description when page changes
              _scrollToDescriptionSection();
              // Provide haptic feedback
              HapticFeedback.selectionClick();
            },
            itemCount: (trends.length / 2).ceil(),
            itemBuilder: (context, pageIndex) {
              return Column(
                children: [
                  Row(
                    children: [
                      _buildMobileTrendTile(pageIndex * 2),
                      SizedBox(width: 15),
                      if (pageIndex * 2 + 1 < trends.length)
                        _buildMobileTrendTile(pageIndex * 2 + 1)
                      else
                        Expanded(child: SizedBox()),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: 15),
        // Page indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate((trends.length / 2).ceil(), (index) {
            return Container(
              width: 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentPage == index
                    ? activeTrend.color
                    : Colors.white.withOpacity(0.3),
              ),
            );
          }),
        ),
      ],
    );
  }
  
  // Mobile trend tile
  Widget _buildMobileTrendTile(int index) {
    if (index >= trends.length) return Expanded(child: SizedBox());
    
    final trend = trends[index];
    final isSelected = _selectedTrendIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTrendIndex = index;
          });
          // Provide haptic feedback
          HapticFeedback.mediumImpact();
          // Scroll to description section
          _scrollToDescriptionSection();
        },
        child: Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? trend.color
                  : trend.color.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: trend.color.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Opacity(
                    opacity: 0.2,
                    child: CachedNetworkImage(
                      imageUrl: trend.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.black),
                      errorWidget: (context, url, error) => Container(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: trend.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        trend.icon,
                        color: trend.color,
                        size: 24,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: trend.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        trend.badgeText,
                        style: TextStyle(
                          fontSize: 10,
                          color: trend.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      trend.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      trend.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: trend.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: trend.color,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: trend.color,
                        size: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // NEW: Desktop trend grid layout
  Widget _buildDesktopTrendGrid(bool isTablet) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "FUTURE TECHNOLOGY VECTORS",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: "JetBrainsMono",
          ),
        ),
        SizedBox(height: 25),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: isTablet ? 3 : 4,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            childAspectRatio: 1,
          ),
          itemCount: trends.length,
          itemBuilder: (context, index) {
            return _buildDesktopTrendTile(index);
          },
        ),
      ],
    );
  }
  
  // Desktop trend tile
  Widget _buildDesktopTrendTile(int index) {
    final trend = trends[index];
    final isSelected = _selectedTrendIndex == index;
    
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _hoveredTrendIndex = index;
        });
      },
      onExit: (_) {
        setState(() {
          _hoveredTrendIndex = null;
        });
      },
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTrendIndex = index;
            _hoveredTrendIndex = null;
          });
          // Provide haptic feedback
          HapticFeedback.mediumImpact();
          // Scroll to description section
          _scrollToDescriptionSection();
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected || _hoveredTrendIndex == index
                  ? trend.color
                  : trend.color.withOpacity(0.3),
              width: isSelected || _hoveredTrendIndex == index ? 2 : 1,
            ),
            boxShadow: isSelected || _hoveredTrendIndex == index
                ? [
                    BoxShadow(
                      color: trend.color.withOpacity(0.3),
                      blurRadius: 15,
                      spreadRadius: 0,
                    )
                  ]
                : null,
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(19),
                  child: Opacity(
                    opacity: 0.2,
                    child: CachedNetworkImage(
                      imageUrl: trend.image,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.black),
                      errorWidget: (context, url, error) => Container(color: Colors.black),
                    ),
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(19),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.8),
                      ],
                      stops: [0.5, 1.0],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: trend.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        trend.icon,
                        color: trend.color,
                        size: 28,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: trend.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        trend.badgeText,
                        style: TextStyle(
                          fontSize: 11,
                          color: trend.color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      trend.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      trend.description,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.8),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isSelected)
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: trend.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: trend.color,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.check,
                        color: trend.color,
                        size: 16,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Mobile trend detail
  Widget _buildMobileTrendDetail(IndustryTrend trend) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Key features
        Text(
          "Key Features",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        Column(
          children: trend.features.map((feature) {
            return Container(
              margin: EdgeInsets.only(bottom: 10),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: trend.color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.check_circle,
                    color: trend.color,
                    size: 20,
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: 15,
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
        
        // Performance metrics
        Text(
          "Performance Metrics",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 15),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 15,
            mainAxisSpacing: 15,
            childAspectRatio: 1,
          ),
          itemCount: trend.metrics.length,
          itemBuilder: (context, index) {
            final entry = trend.metrics.entries.elementAt(index);
            final iconData = _getMetricIcon(entry.key);
            
            return Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: trend.color.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    iconData,
                    color: trend.color,
                    size: 22,
                  ),
                  SizedBox(height: 10),
                  Text(
                    entry.value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 5),
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white70,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // Desktop trend detail
  Widget _buildDesktopTrendDetail(IndustryTrend trend, bool isTablet) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Features column
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Key Features",
                style: TextStyle(
                  fontSize: 24,
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
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 3,
                ),
                itemCount: trend.features.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: trend.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: trend.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check,
                            size: 12,
                            color: trend.color,
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            trend.features[index],
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        ),
        
        SizedBox(width: 30),
        
        // Metrics column
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Performance Metrics",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              ...trend.metrics.entries.map((entry) {
                final iconData = _getMetricIcon(entry.key);
                
                return Container(
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: trend.color.withOpacity(0.3),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: trend.color.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: trend.color.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          iconData,
                          color: trend.color,
                          size: 24,
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              entry.value,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  // Helper method to get icon for metric
  IconData _getMetricIcon(String metricName) {
    switch (metricName) {
      case "Processing Power":
        return Icons.memory;
      case "Learning Rate":
        return Icons.speed;
      case "Accuracy":
        return Icons.gpp_good;
      case "Task Reduction":
        return Icons.checklist;
      case "Error Decrease":
        return Icons.error_outline;
      case "Cycle Time":
        return Icons.timer;
      case "Precision":
        return Icons.precision_manufacturing;
      case "Operation Speed":
        return Icons.speed;
      case "Adaptability":
        return Icons.sync;
      case "Load Speed":
        return Icons.bolt;
      case "User Engagement":
        return Icons.thumb_up;
      case "Conversion Rate":
        return Icons.change_circle;
      case "System Uptime":
        return Icons.cloud_done;
      case "Response Time":
        return Icons.timer;
      case "Code Quality":
        return Icons.code;
      case "Power Efficiency":
        return Icons.power;
      case "Processing Speed":
        return Icons.speed;
      case "Memory Footprint":
        return Icons.memory;
      case "User Retention":
        return Icons.favorite;
      case "App Performance":
        return Icons.auto_graph;
      case "Battery Impact":
        return Icons.battery_full;
      case "Design Iterations":
        return Icons.refresh;
      case "Visual Impact":
        return Icons.visibility;
      case "Brand Recognition":
        return Icons.verified;
      case "Lead Conversion":
        return Icons.people;
      case "Customer Acquisition":
        return Icons.person_add;
      case "Brand Engagement":
        return Icons.thumb_up;
      case "Innovation Rate":
        return Icons.lightbulb;
      case "Time-to-Market":
        return Icons.timer;
      case "Success Ratio":
        return Icons.trending_up;
      case "Revenue Growth":
        return Icons.attach_money;
      case "Market Expansion":
        return Icons.public;
      case "Partnership Value":
        return Icons.handshake;
      case "Mission Success":
        return Icons.rocket_launch;
      case "Data Throughput":
        return Icons.cloud_upload;
      case "Power Efficiency":
        return Icons.bolt;
      default:
        return Icons.analytics;
    }
  }

  // CTA Section 
  Widget _buildCtaSection(bool isMobile, bool isTablet, IndustryTrend activeTrend) {
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
            activeTrend.color.withOpacity(0.3),
            Colors.black.withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: activeTrend.color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: activeTrend.color.withOpacity(0.2),
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
                  "Ready To Position For The Future?",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 15),
                Text(
                  "Our strategic foresight team can help you navigate these emerging technology vectors and develop robust strategies to capitalize on the opportunities of the next decade.",
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
                    backgroundColor: activeTrend.color,
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
                    "Schedule Strategic Consultation",
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
                        "Ready To Position For The Future?",
                        style: TextStyle(
                          fontSize: isTablet ? 28 : 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        "Our strategic foresight team can help you navigate these emerging technology vectors and develop robust strategies to capitalize on the opportunities of the next decade.",
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
                          backgroundColor: activeTrend.color,
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
                          "Schedule Consultation",
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

// Helper classes
class Particle {
  Offset position;
  double speed;
  double radius;
  Color color;

  Particle({
    required this.position,
    required this.speed,
    required this.radius,
    required this.color,
  });
}

class IndustryTrend {
  final String title;
  final IconData icon;
  final String description;
  final String longDescription;
  final String badgeText;
  final Color color;
  final String image;
  final List<String> features;
  final Map<String, String> metrics;
  final List<UseCase> useCases;

  IndustryTrend({
    required this.title,
    required this.icon,
    required this.description,
    required this.longDescription,
    required this.badgeText,
    required this.color,
    required this.image,
    required this.features,
    required this.metrics,
    required this.useCases,
  });
}

class UseCase {
  final String industry;
  final IconData icon;
  final String description;

  UseCase({
    required this.industry,
    required this.icon,
    required this.description,
  });
}

// Particle painter
class ParticlePainter extends CustomPainter {
  final List<Particle> particles;

  ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var particle in particles) {
      final paint = Paint()
        ..color = particle.color
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(
          particle.position.dx % size.width,
          particle.position.dy % size.height,
        ),
        particle.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}