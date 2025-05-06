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
  // Multiple animation controllers for complex effects
  late PageController _pageController;
  late AnimationController _particleAnimController;
  late AnimationController _pulseAnimController;
  late AnimationController _floatAnimController;
  late AnimationController _rotateAnimController;
  late AnimationController _shimmerAnimController;
  final ValueNotifier<double> _pageNotifier = ValueNotifier(0.0);
  
  // Scroll physics for smoother scrolling
  final _customScrollPhysics = const BouncingScrollPhysics(
    parent: AlwaysScrollableScrollPhysics(),
    decelerationRate: ScrollDecelerationRate.fast,
  );
  
  bool _controllerInitialized = false;
  bool _isHoveringTitle = false;
  int _hoveringServiceIndex = -1;

  // Interactive state tracking
  Map<int, bool> _expandedSections = {};
  int? _selectedCaseStudy;
  
  // Enhanced color palette with gradients
  final List<LinearGradient> _serviceGradients = [
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1A237E), // Deep indigo
        Color(0xFF0D47A1), // Royal blue
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF004D40), // Deep teal
        Color(0xFF00796B), // Teal
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF4A148C), // Deep purple
        Color(0xFF7B1FA2), // Purple
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFBF360C), // Deep orange
        Color(0xFFE64A19), // Orange
      ],
    ),
    LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFF1B5E20), // Deep green
        Color(0xFF388E3C), // Green
      ],
    ),
  ];

  // Expanded enterprise service offerings with more detailed information
  final List<EnterpriseService> _services = [
    EnterpriseService(
      title: "Advanced Intelligence Solutions",
      color: Color(0xFF1A237E),
      image: "https://images.unsplash.com/photo-1593508512255-86ab42a8e620",
      videoUrl: "https://example.com/videos/ai-showcase.mp4",
      badgeText: "Innovation Leader",
      features: [
        EnterpriseFeature(
          icon: Icons.smart_toy,
          title: "Enterprise AI Integration",
          description: "Custom neural networks and deep learning models",
          details: "Our AI solutions leverage state-of-the-art algorithms to analyze complex data patterns, enabling predictive insights and automated decision-making capabilities across your organization.",
          techStack: ["TensorFlow", "PyTorch", "CUDA", "TPU"],
          caseStudies: [
            CaseStudy(
              title: "Global Financial Institution",
              description: "Implemented fraud detection system with 99.7% accuracy, reducing false positives by 85%",
              metrics: ["85% reduction in false positives", "99.7% detection accuracy", "\$4.2M annual savings"],
              logoUrl: "https://example.com/logos/finance.png",
            ),
            CaseStudy(
              title: "Healthcare Provider Network",
              description: "Developed predictive patient outcome models improving treatment planning efficiency by 42%",
              metrics: ["42% improvement in planning", "28% reduction in readmissions", "16.5 hours saved per physician monthly"],
              logoUrl: "https://example.com/logos/healthcare.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.precision_manufacturing,
          title: "Industrial Automation",
          description: "Smart manufacturing and supply chain optimization",
          details: "Transform your manufacturing with Industry 4.0 technologies. Our digital twin implementations create virtual replicas of physical systems for real-time monitoring, prediction, and optimization.",
          techStack: ["ROS", "MQTT", "OPC UA", "Digital Twin"],
          caseStudies: [
            CaseStudy(
              title: "Aerospace Manufacturing",
              description: "Digital twin implementation reduced production defects by 37% and maintenance costs by 42%",
              metrics: ["37% defect reduction", "42% lower maintenance costs", "18% productivity increase"],
              logoUrl: "https://example.com/logos/aerospace.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.psychology_alt,
          title: "Cognitive Computing",
          description: "Natural language understanding and computer vision",
          details: "Deploy sophisticated NLP systems for sentiment analysis, content categorization, and contextual understanding. Our computer vision solutions enable object recognition, scene interpretation, and anomaly detection.",
          techStack: ["BERT", "GPT", "OpenCV", "ResNet"],
          caseStudies: [
            CaseStudy(
              title: "Retail Analytics Platform",
              description: "Customer sentiment analysis increased satisfaction scores by 28% and reduced churn by 17%",
              metrics: ["28% higher satisfaction", "17% churn reduction", "22% increase in NPS"],
              logoUrl: "https://example.com/logos/retail.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.smart_button,
          title: "Process Automation",
          description: "Workflow optimization and enterprise integration",
          details: "Streamline operations with intelligent process automation. Our RPA solutions eliminate repetitive tasks, reduce errors, and free your team to focus on strategic initiatives.",
          techStack: ["UiPath", "BluePrism", "Automation Anywhere", "Power Automate"],
          caseStudies: [
            CaseStudy(
              title: "Insurance Claims Processing",
              description: "Automated claims processing reduced handling time by 68% and operational costs by 31%",
              metrics: ["68% faster processing", "31% cost reduction", "99.2% accuracy rate"],
              logoUrl: "https://example.com/logos/insurance.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.insights,
          title: "Advanced Analytics",
          description: "Predictive modeling and business intelligence",
          details: "Convert raw data into actionable insights with advanced analytics solutions. Our predictive models help identify trends, forecast outcomes, and optimize business processes.",
          techStack: ["Apache Spark", "Databricks", "H2O.ai", "Tableau"],
          caseStudies: [
            CaseStudy(
              title: "Energy Utility",
              description: "Predictive maintenance system reduced downtime by 43% and extended equipment lifespan by 26%",
              metrics: ["43% less downtime", "26% longer equipment life", "\$3.8M annual maintenance savings"],
              logoUrl: "https://example.com/logos/energy.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.hub,
          title: "Innovation Laboratory",
          description: "Research, development, and rapid prototyping",
          details: "Our R&D lab accelerates innovation by testing emerging technologies and developing proof-of-concepts. We help you stay ahead of market disruptions and capitalize on new opportunities.",
          techStack: ["Quantum Computing", "Edge AI", "Blockchain", "AR/VR"],
          caseStudies: [
            CaseStudy(
              title: "Pharmaceutical Research",
              description: "Quantum computing simulation reduced drug discovery timeline by 64%",
              metrics: ["64% faster discovery", "3.8x more candidate molecules", "42% cost reduction"],
              logoUrl: "https://example.com/logos/pharma.png",
            ),
          ],
        ),
      ],
      industryApplications: [
        IndustryApplication(
          industry: "Healthcare",
          description: "Diagnostic assistance, treatment optimization, operational efficiency",
          icon: Icons.local_hospital,
        ),
        IndustryApplication(
          industry: "Finance",
          description: "Risk assessment, fraud detection, algorithmic trading",
          icon: Icons.account_balance,
        ),
        IndustryApplication(
          industry: "Manufacturing",
          description: "Quality control, predictive maintenance, supply chain optimization",
          icon: Icons.precision_manufacturing,
        ),
        IndustryApplication(
          industry: "Retail",
          description: "Personalization, inventory optimization, demand forecasting",
          icon: Icons.shopping_cart,
        ),
      ],
      testimonials: [
        Testimonial(
          quote: "The AI solutions implemented by the team have transformed our decision-making capabilities. We're now able to predict market trends with remarkable accuracy.",
          author: "Sarah Johnson",
          position: "CTO, Global Financial Services",
          avatar: "https://example.com/avatars/sarah.jpg",
        ),
        Testimonial(
          quote: "Their cognitive computing platform has revolutionized how we interact with customers. The natural language processing capability has increased our service efficiency by 47%.",
          author: "David Chen",
          position: "VP of Innovation, Retail Solutions Inc.",
          avatar: "https://example.com/avatars/david.jpg",
        ),
      ],
      relatedWhitepapers: [
        Whitepaper(
          title: "The Future of Enterprise AI: Trends and Implementation Strategies",
          description: "A comprehensive guide to adopting AI technologies in enterprise environments",
          downloadUrl: "https://example.com/whitepapers/enterprise-ai-future.pdf",
          thumbnailUrl: "https://example.com/thumbnails/ai-whitepaper.jpg",
        ),
        Whitepaper(
          title: "Measuring ROI of AI Implementations: A Framework for Enterprise Leaders",
          description: "Quantifying the business impact of AI investments across industry verticals",
          downloadUrl: "https://example.com/whitepapers/ai-roi-framework.pdf",
          thumbnailUrl: "https://example.com/thumbnails/roi-whitepaper.jpg",
        ),
      ],
    ),
    EnterpriseService(
      title: "Digital Ecosystem Architecture",
      color: Color(0xFF004D40),
      image: "https://images.unsplash.com/photo-1558494949-ef010cbdcc31",
      videoUrl: "https://example.com/videos/digital-ecosystem.mp4",
      badgeText: "Enterprise-Grade",
      features: [
        EnterpriseFeature(
          icon: Icons.language,
          title: "Enterprise Platforms",
          description: "Scalable, resilient web application frameworks",
          details: "Build enterprise-grade web platforms with microservices architecture, designed for massive scalability, high availability, and fault tolerance.",
          techStack: ["React", "Angular", "Vue.js", "Next.js", "GraphQL"],
          caseStudies: [
            CaseStudy(
              title: "Global E-commerce Platform",
              description: "Microservices architecture enabled 300% increase in transaction volume with 99.99% uptime",
              metrics: ["300% transaction growth", "99.99% uptime", "85% faster feature deployment"],
              logoUrl: "https://example.com/logos/ecommerce.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.storage,
          title: "Cloud Architecture",
          description: "Distributed systems and serverless computing",
          details: "Design cloud-native architectures that automatically scale with demand, optimize for cost efficiency, and maintain high performance under variable loads.",
          techStack: ["Kubernetes", "Docker", "Terraform", "Istio"],
          caseStudies: [
            CaseStudy(
              title: "Financial Services Provider",
              description: "Cloud migration reduced infrastructure costs by 47% while improving performance by 128%",
              metrics: ["47% cost reduction", "128% performance improvement", "99.995% availability"],
              logoUrl: "https://example.com/logos/finance.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.cloud_done,
          title: "Multi-Cloud Strategy",
          description: "Hybrid deployments across major cloud providers",
          details: "Implement sophisticated multi-cloud strategies that prevent vendor lock-in, optimize workload placement, and ensure business continuity through geographic distribution.",
          techStack: ["AWS", "Azure", "GCP", "OpenShift"],
          caseStudies: [
            CaseStudy(
              title: "Healthcare Information Systems",
              description: "Multi-cloud architecture achieved 99.999% uptime and 42% reduction in service latency",
              metrics: ["99.999% uptime", "42% lower latency", "63% disaster recovery improvement"],
              logoUrl: "https://example.com/logos/healthcare.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.shopping_cart,
          title: "Commerce Solutions",
          description: "B2B/B2C platforms and payment orchestration",
          details: "Deploy enterprise commerce solutions with comprehensive inventory management, dynamic pricing strategies, and seamless integration with global payment systems.",
          techStack: ["Shopify Plus", "Magento", "SAP Commerce", "Stripe"],
          caseStudies: [
            CaseStudy(
              title: "International Retailer",
              description: "Omnichannel platform increased online revenue by 87% and customer retention by 42%",
              metrics: ["87% revenue growth", "42% higher retention", "65% mobile conversion improvement"],
              logoUrl: "https://example.com/logos/retail.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.security,
          title: "Enterprise Security",
          description: "Comprehensive protection and compliance",
          details: "Implement defense-in-depth security strategies with advanced threat detection, zero-trust architecture, and continuous compliance monitoring for regulated industries.",
          techStack: ["OWASP", "OAuth2", "SIEM", "WAF", "DDoS Protection"],
          caseStudies: [
            CaseStudy(
              title: "Banking Security Transformation",
              description: "Zero-trust implementation reduced security incidents by 92% and achieved regulatory compliance in 5 domains",
              metrics: ["92% incident reduction", "100% compliance achievement", "67% faster threat response"],
              logoUrl: "https://example.com/logos/banking.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.speed,
          title: "Performance Engineering",
          description: "Optimization, monitoring, and scaling",
          details: "Elevate system performance through advanced load testing, performance profiling, and automated scaling mechanisms that ensure optimal user experience under all conditions.",
          techStack: ["New Relic", "Datadog", "JMeter", "Gatling"],
          caseStudies: [
            CaseStudy(
              title: "Media Streaming Service",
              description: "Performance optimization reduced infrastructure costs by 38% while supporting 250% user growth",
              metrics: ["38% cost savings", "250% user growth supported", "72% latency reduction"],
              logoUrl: "https://example.com/logos/media.png",
            ),
          ],
        ),
      ],
      industryApplications: [
        IndustryApplication(
          industry: "Finance",
          description: "Secure transactions, regulatory compliance, high availability",
          icon: Icons.account_balance,
        ),
        IndustryApplication(
          industry: "E-commerce",
          description: "Scalable platforms, payment processing, global reach",
          icon: Icons.shopping_bag,
        ),
        IndustryApplication(
          industry: "Healthcare",
          description: "HIPAA compliance, interoperability, data security",
          icon: Icons.local_hospital,
        ),
        IndustryApplication(
          industry: "Education",
          description: "Learning platforms, content delivery, student engagement",
          icon: Icons.school,
        ),
      ],
      testimonials: [
        Testimonial(
          quote: "The microservices architecture they developed has allowed us to scale our operations globally while maintaining exceptional performance metrics.",
          author: "Michael Reynolds",
          position: "CIO, Global Retail Corporation",
          avatar: "https://example.com/avatars/michael.jpg",
        ),
        Testimonial(
          quote: "Their multi-cloud strategy has been transformative for our business continuity planning. We've achieved unprecedented reliability while optimizing our cloud spend.",
          author: "Jennifer Wu",
          position: "VP of Cloud Operations, Financial Services Inc.",
          avatar: "https://example.com/avatars/jennifer.jpg",
        ),
      ],
      relatedWhitepapers: [
        Whitepaper(
          title: "Microservices at Scale: Patterns for Enterprise Adoption",
          description: "Best practices for implementing and managing microservices architecture",
          downloadUrl: "https://example.com/whitepapers/microservices-scale.pdf",
          thumbnailUrl: "https://example.com/thumbnails/microservices-whitepaper.jpg",
        ),
        Whitepaper(
          title: "Multi-Cloud Strategy: Beyond Redundancy to Strategic Advantage",
          description: "How organizations can leverage multiple cloud providers for competitive advantage",
          downloadUrl: "https://example.com/whitepapers/multi-cloud-strategy.pdf",
          thumbnailUrl: "https://example.com/thumbnails/cloud-whitepaper.jpg",
        ),
      ],
    ),
    EnterpriseService(
      title: "Immersive Experience Design",
      color: Color(0xFF4A148C),
      image: "https://images.unsplash.com/photo-1593642632823-8f785ba67e45",
      videoUrl: "https://example.com/videos/immersive-design.mp4",
      badgeText: "Award-Winning",
      features: [
        EnterpriseFeature(
          icon: Icons.devices,
          title: "Omnichannel Experiences",
          description: "Seamless interactions across all customer touchpoints",
          details: "Create unified customer journeys that maintain context and personalization across web, mobile, in-store, and emerging channels, delivering consistent brand experiences.",
          techStack: ["React Native", "Flutter", "Progressive Web Apps", "Voice UI"],
          caseStudies: [
            CaseStudy(
              title: "Luxury Retail Brand",
              description: "Omnichannel experience increased customer lifetime value by 64% and engagement by 87%",
              metrics: ["64% higher CLV", "87% engagement increase", "42% more store visits"],
              logoUrl: "https://example.com/logos/luxury.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.phonelink,
          title: "Advanced Mobile Solutions",
          description: "Native and cross-platform application development",
          details: "Develop high-performance mobile applications with sophisticated features including offline capabilities, biometric authentication, and hardware integration.",
          techStack: ["Swift", "Kotlin", "Flutter", "React Native"],
          caseStudies: [
            CaseStudy(
              title: "Global Banking App",
              description: "Redesigned mobile experience increased active users by 124% and transaction volume by 89%",
              metrics: ["124% more active users", "89% transaction growth", "4.8 star app rating"],
              logoUrl: "https://example.com/logos/banking.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.view_in_ar,
          title: "Extended Reality",
          description: "AR, VR, and mixed reality solutions",
          details: "Transform customer experiences and employee training with immersive XR technologies that create memorable interactions and improve information retention.",
          techStack: ["Unity", "ARKit", "ARCore", "WebXR"],
          caseStudies: [
            CaseStudy(
              title: "Automotive Manufacturer",
              description: "AR product visualization increased conversion rates by 37% and reduced returns by 42%",
              metrics: ["37% higher conversion", "42% fewer returns", "8.2 minutes average engagement"],
              logoUrl: "https://example.com/logos/automotive.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.gesture,
          title: "Advanced Interactions",
          description: "Voice, gesture, and contextual interfaces",
          details: "Implement cutting-edge interaction models including conversational interfaces, gesture control, and predictive experiences that anticipate user needs.",
          techStack: ["Dialogflow", "Amazon Lex", "Custom NLP", "Gesture Recognition"],
          caseStudies: [
            CaseStudy(
              title: "Smart Home Platform",
              description: "Voice and gesture controls increased daily active users by 87% and reduced support calls by 42%",
              metrics: ["87% more daily users", "42% fewer support calls", "92% user satisfaction"],
              logoUrl: "https://example.com/logos/smarthome.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.data_usage,
          title: "Personalization Engine",
          description: "AI-driven dynamic content and recommendations",
          details: "Deploy sophisticated personalization systems that analyze user behavior, preferences, and context to deliver tailored experiences that improve engagement and conversion.",
          techStack: ["Recommendation Systems", "A/B Testing", "User Segmentation", "Behavioral Analytics"],
          caseStudies: [
            CaseStudy(
              title: "Media Streaming Company",
              description: "Personalization engine increased content consumption by 47% and subscriber retention by 28%",
              metrics: ["47% more content consumption", "28% better retention", "52% recommendation adoption"],
              logoUrl: "https://example.com/logos/streaming.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.palette,
          title: "Design Systems",
          description: "Scalable, consistent visual language and components",
          details: "Establish enterprise-wide design systems that ensure brand consistency, accelerate development, and improve accessibility across all digital properties.",
          techStack: ["Figma", "Storybook", "Material Design", "Design Tokens"],
          caseStudies: [
            CaseStudy(
              title: "Financial Services Platform",
              description: "Design system implementation reduced development time by 63% and improved accessibility compliance by 100%",
              metrics: ["63% faster development", "100% accessibility compliance", "74% component reuse"],
              logoUrl: "https://example.com/logos/finance.png",
            ),
          ],
        ),
      ],
      industryApplications: [
        IndustryApplication(
          industry: "Retail",
          description: "Virtual try-on, in-store navigation, personalized experiences",
          icon: Icons.shopping_bag,
        ),
        IndustryApplication(
          industry: "Real Estate",
          description: "Virtual tours, property visualization, interactive planning",
          icon: Icons.home,
        ),
        IndustryApplication(
          industry: "Education",
          description: "Immersive learning, virtual laboratories, interactive simulations",
          icon: Icons.school,
        ),
        IndustryApplication(
          industry: "Healthcare",
          description: "Surgical planning, patient education, therapeutic applications",
          icon: Icons.local_hospital,
        ),
      ],
      testimonials: [
        Testimonial(
          quote: "The immersive AR experience they developed has fundamentally changed how customers interact with our products. We've seen engagement metrics we didn't think were possible.",
          author: "Emma Roberts",
          position: "Chief Digital Officer, Luxury Retail Group",
          avatar: "https://example.com/avatars/emma.jpg",
        ),
        Testimonial(
          quote: "Their personalization engine has transformed our content delivery strategy. We're seeing unprecedented levels of user engagement and retention.",
          author: "Thomas Lee",
          position: "VP of Digital Experience, Media Corporation",
          avatar: "https://example.com/avatars/thomas.jpg",
        ),
      ],
      relatedWhitepapers: [
        Whitepaper(
          title: "The Business Case for Extended Reality in Enterprise Applications",
          description: "ROI analysis and implementation strategies for AR/VR in business contexts",
          downloadUrl: "https://example.com/whitepapers/xr-business-case.pdf",
          thumbnailUrl: "https://example.com/thumbnails/ar-whitepaper.jpg",
        ),
        Whitepaper(
          title: "Personalization at Scale: AI-Driven Experience Optimization",
          description: "Strategies for implementing advanced personalization while respecting privacy",
          downloadUrl: "https://example.com/whitepapers/personalization-scale.pdf",
          thumbnailUrl: "https://example.com/thumbnails/personalization-whitepaper.jpg",
        ),
      ],
    ),
    EnterpriseService(
      title: "Intelligent Connected Systems",
      color: Color(0xFFBF360C),
      image: "https://images.unsplash.com/photo-1518770660439-4636190af475",
      videoUrl: "https://example.com/videos/connected-systems.mp4",
      badgeText: "Industry 4.0",
      features: [
        EnterpriseFeature(
          icon: Icons.developer_board,
          title: "Industrial IoT",
          description: "Connected manufacturing and intelligent monitoring",
          details: "Transform industrial operations with comprehensive IoT solutions that connect equipment, monitor performance, predict maintenance needs, and optimize production processes.",
          techStack: ["MQTT", "OPC UA", "Edge Computing", "Azure IoT"],
          caseStudies: [
            CaseStudy(
              title: "Manufacturing Conglomerate",
              description: "IoT implementation reduced downtime by 78% and increased production efficiency by 34%",
              metrics: ["78% less downtime", "34% efficiency improvement", "\$7.2M annual savings"],
              logoUrl: "https://example.com/logos/manufacturing.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.sensors,
          title: "Sensor Networks",
          description: "Environmental monitoring and data collection",
          details: "Deploy sophisticated sensor networks for environmental monitoring, asset tracking, and real-time data collection in challenging environments with limited connectivity.",
          techStack: ["LoRaWAN", "Zigbee", "BLE Mesh", "Wireless Sensor Networks"],
          caseStudies: [
            CaseStudy(
              title: "Agricultural Technology",
              description: "Precision agriculture system increased crop yields by 28% while reducing water usage by 32%",
              metrics: ["28% higher yields", "32% water reduction", "52% less fertilizer used"],
              logoUrl: "https://example.com/logos/agriculture.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.hub,
          title: "Smart Infrastructure",
          description: "Connected buildings, cities, and transportation",
          details: "Create intelligent infrastructure with integrated systems for energy management, occupancy optimization, and environmental monitoring that reduce costs and improve sustainability.",
          techStack: ["Building Management Systems", "Smart City Platforms", "Energy Analytics"],
          caseStudies: [
            CaseStudy(
              title: "Commercial Real Estate Developer",
              description: "Smart building implementation reduced energy consumption by 42% and operating costs by 27%",
              metrics: ["42% energy reduction", "27% lower operating costs", "68% tenant satisfaction increase"],
              logoUrl: "https://example.com/logos/realestate.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.analytics,
          title: "Real-time Analytics",
          description: "Stream processing and event-driven architecture",
          details: "Implement real-time analytics systems that process data streams, detect patterns, and trigger automated responses to changing conditions with millisecond latency.",
          techStack: ["Apache Kafka", "Apache Flink", "Time Series DB", "Streaming Analytics"],
          caseStudies: [
            CaseStudy(
              title: "Energy Utility",
              description: "Real-time grid management system reduced outages by 64% and optimized distribution by 28%",
              metrics: ["64% fewer outages", "28% distribution optimization", "3.2M customers served reliably"],
              logoUrl: "https://example.com/logos/energy.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.security,
          title: "IoT Security",
          description: "End-to-end protection for connected devices",
          details: "Secure connected devices with comprehensive solutions including secure boot, encrypted communications, intrusion detection, and automated patch management.",
          techStack: ["Device Identity", "PKI", "Secure Elements", "OTA Updates"],
          caseStudies: [
            CaseStudy(
              title: "Healthcare Devices Manufacturer",
              description: "Security framework achieved regulatory compliance and prevented 100% of attempted breaches",
              metrics: ["100% regulatory compliance", "Zero successful breaches", "42% faster security certifications"],
              logoUrl: "https://example.com/logos/healthcare.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.auto_graph,
          title: "Predictive Operations",
          description: "AI-powered forecasting and optimization",
          details: "Leverage predictive analytics to optimize operations, forecast maintenance needs, and prevent costly failures before they occur, maximizing equipment lifespan and reliability.",
          techStack: ["Machine Learning", "Anomaly Detection", "Predictive Models", "Digital Twins"],
          caseStudies: [
            CaseStudy(
              title: "Logistics Company",
              description: "Predictive fleet management reduced maintenance costs by 38% and vehicle downtime by 47%",
              metrics: ["38% lower maintenance costs", "47% less downtime", "14% fuel efficiency improvement"],
              logoUrl: "https://example.com/logos/logistics.png",
            ),
          ],
        ),
      ],
      industryApplications: [
        IndustryApplication(
          industry: "Manufacturing",
          description: "Equipment monitoring, predictive maintenance, quality control",
          icon: Icons.precision_manufacturing,
        ),
        IndustryApplication(
          industry: "Energy",
          description: "Grid management, consumption optimization, fault detection",
          icon: Icons.electric_bolt,
        ),
        IndustryApplication(
          industry: "Smart Cities",
          description: "Infrastructure monitoring, traffic management, environmental sensing",
          icon: Icons.location_city,
        ),
        IndustryApplication(
          industry: "Agriculture",
          description: "Precision farming, crop monitoring, resource optimization",
          icon: Icons.grass,
        ),
      ],
      testimonials: [
        Testimonial(
          quote: "Their industrial IoT solution has revolutionized our manufacturing processes. We've achieved levels of efficiency and predictability that were previously impossible.",
          author: "Robert Chen",
          position: "COO, Global Manufacturing Corporation",
          avatar: "https://example.com/avatars/robert.jpg",
        ),
        Testimonial(
          quote: "The smart building platform they implemented has not only reduced our operating costs significantly but has become a key selling point for our premium commercial spaces.",
          author: "Patricia Alvarez",
          position: "Director of Operations, Commercial Real Estate Group",
          avatar: "https://example.com/avatars/patricia.jpg",
        ),
      ],
      relatedWhitepapers: [
        Whitepaper(
          title: "The Industrial Internet of Things: Implementation Framework and ROI Analysis",
          description: "Comprehensive guide to deploying IIoT solutions in manufacturing environments",
          downloadUrl: "https://example.com/whitepapers/iiot-implementation.pdf",
          thumbnailUrl: "https://example.com/thumbnails/iiot-whitepaper.jpg",
        ),
        Whitepaper(
          title: "Securing the Connected Enterprise: IoT Security Best Practices",
          description: "Strategies for maintaining security and compliance in large-scale IoT deployments",
          downloadUrl: "https://example.com/whitepapers/iot-security.pdf",
          thumbnailUrl: "https://example.com/thumbnails/security-whitepaper.jpg",
        ),
      ],
    ),
    EnterpriseService(
      title: "Digital Transformation Consulting",
      color: Color(0xFF1B5E20),
      image: "https://images.unsplash.com/photo-1552664730-d307ca884978",
      videoUrl: "https://example.com/videos/digital-transformation.mp4",
      badgeText: "Strategic Partner",
      features: [
        EnterpriseFeature(
          icon: Icons.auto_stories,
          title: "Technology Strategy",
          description: "Digital roadmaps and innovation planning",
          details: "Develop comprehensive technology strategies that align with business objectives, prioritize initiatives, and create actionable implementation roadmaps with clear ROI metrics.",
          techStack: ["Enterprise Architecture", "Technology Assessment", "Digital Maturity"],
          caseStudies: [
            CaseStudy(
              title: "Global Insurance Company",
              description: "Digital transformation strategy delivered \$92M in business value over 3 years",
              metrics: ["\$92M business value", "42% faster time-to-market", "87% improved customer satisfaction"],
              logoUrl: "https://example.com/logos/insurance.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.integration_instructions,
          title: "Legacy Modernization",
          description: "System migration and integration",
          details: "Transform legacy systems through strategic modernization approaches including refactoring, replatforming, and replacement while maintaining business continuity.",
          techStack: ["API Strategy", "Microservices", "Cloud Migration", "Containerization"],
          caseStudies: [
            CaseStudy(
              title: "Financial Institution",
              description: "Core banking modernization reduced operating costs by 47% and enabled 89% faster product launches",
              metrics: ["47% cost reduction", "89% faster launches", "62% improved system reliability"],
              logoUrl: "https://example.com/logos/banking.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.people,
          title: "Organizational Change",
          description: "Digital culture and talent development",
          details: "Build digital capabilities through organizational transformation, addressing culture, skills, processes, and structure to enable sustained innovation and agility.",
          techStack: ["Change Management", "Agile/DevOps", "Talent Development", "Digital Leadership"],
          caseStudies: [
            CaseStudy(
              title: "Retail Chain",
              description: "Digital transformation increased employee engagement by 68% and reduced time-to-market by 74%",
              metrics: ["68% engagement improvement", "74% faster time-to-market", "42% higher innovation rate"],
              logoUrl: "https://example.com/logos/retail.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.fact_check,
          title: "Process Optimization",
          description: "Workflow redesign and automation",
          details: "Reimagine business processes through customer-centric design, intelligent automation, and continuous improvement frameworks that boost efficiency and outcomes.",
          techStack: ["Process Mining", "Service Design", "Lean Six Sigma", "Workflow Automation"],
          caseStudies: [
            CaseStudy(
              title: "Healthcare Provider",
              description: "Process optimization reduced patient wait times by 62% and administrative costs by 37%",
              metrics: ["62% shorter wait times", "37% lower admin costs", "84% staff satisfaction improvement"],
              logoUrl: "https://example.com/logos/healthcare.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.query_stats,
          title: "Data Strategy",
          description: "Governance, analytics, and insights",
          details: "Develop enterprise data strategies that establish robust governance, enable advanced analytics, and create value through actionable insights and data monetization.",
          techStack: ["Data Governance", "Analytics Platforms", "Master Data Management", "Data Lakes"],
          caseStudies: [
            CaseStudy(
              title: "Consumer Goods Manufacturer",
              description: "Data strategy implementation improved decision accuracy by 58% and market responsiveness by 71%",
              metrics: ["58% more accurate decisions", "71% faster market response", "\$45M incremental revenue"],
              logoUrl: "https://example.com/logos/consumer.png",
            ),
          ],
        ),
        EnterpriseFeature(
          icon: Icons.cloud_sync,
          title: "Digital Acceleration",
          description: "Rapid innovation and experimentation",
          details: "Accelerate digital initiatives through innovation labs, rapid prototyping, and agile delivery models that reduce time-to-market and validate concepts quickly.",
          techStack: ["Innovation Labs", "Design Thinking", "MVPs", "Rapid Prototyping"],
          caseStudies: [
            CaseStudy(
              title: "Telecommunications Provider",
              description: "Digital acceleration program reduced product development time by 74% and increased innovation success rate by 52%",
              metrics: ["74% faster development", "52% higher success rate", "3.2x ROI on innovation spending"],
              logoUrl: "https://example.com/logos/telecom.png",
            ),
          ],
        ),
      ],
      industryApplications: [
        IndustryApplication(
          industry: "Banking",
          description: "Digital banking, customer experience, operational efficiency",
          icon: Icons.account_balance,
        ),
        IndustryApplication(
          industry: "Healthcare",
          description: "Patient experience, telehealth, operational optimization",
          icon: Icons.local_hospital,
        ),
        IndustryApplication(
          industry: "Retail",
          description: "Omnichannel, supply chain, customer analytics",
          icon: Icons.shopping_bag,
        ),
        IndustryApplication(
          industry: "Manufacturing",
          description: "Smart factories, supply chain visibility, digital product design",
          icon: Icons.precision_manufacturing,
        ),
      ],
      testimonials: [
        Testimonial(
          quote: "Their strategic approach to our digital transformation has been invaluable. We've not only achieved our technical goals but transformed our entire business model.",
          author: "Richard Thompson",
          position: "CEO, Global Insurance Corporation",
          avatar: "https://example.com/avatars/richard.jpg",
        ),
        Testimonial(
          quote: "The data strategy they developed has become the foundation of our competitive advantage. We're making faster, more accurate decisions that have measurably improved our market position.",
          author: "Lisa Martinez",
          position: "Chief Data Officer, Consumer Products Inc.",
          avatar: "https://example.com/avatars/lisa.jpg",
        ),
      ],
      relatedWhitepapers: [
        Whitepaper(
          title: "Digital Transformation: Beyond Technology to Business Outcomes",
          description: "A framework for aligning transformation initiatives with strategic business goals",
          downloadUrl: "https://example.com/whitepapers/digital-transformation.pdf",
          thumbnailUrl: "https://example.com/thumbnails/transformation-whitepaper.jpg",
        ),
        Whitepaper(
          title: "The Data-Driven Enterprise: Strategies for Creating Value from Enterprise Data",
          description: "Best practices for implementing enterprise data strategies that deliver measurable ROI",
          downloadUrl: "https://example.com/whitepapers/data-driven-enterprise.pdf",
          thumbnailUrl: "https://example.com/thumbnails/data-whitepaper.jpg",
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize multiple animation controllers for complex effects
    _particleAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
    
    _pulseAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _floatAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
    
    _rotateAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
    
    _shimmerAnimController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    // Initialize service expansion states
    for (int i = 0; i < _services.length; i++) {
      _expandedSections[i] = false;
    }
    
    // Set the first service as expanded by default
    _expandedSections[0] = true;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_controllerInitialized) {
      final size = MediaQuery.of(context).size;
      final isSmallMobile = size.width < 480;
      final isMobile = size.width < 768;
      final isTablet = size.width >= 768 && size.width < 1024;
      
      // Configure PageController with adaptive viewport fraction
      _pageController = PageController(
        viewportFraction: isSmallMobile ? 0.85 : isMobile ? 0.88 : isTablet ? 0.85 : 0.75,
        initialPage: 0,
      );
      
      _pageController.addListener(() {
        _pageNotifier.value = _pageController.page!;
        // Add haptic feedback when page changes
        if (_pageController.page! % 1.0 < 0.01 || _pageController.page! % 1.0 > 0.99) {
          HapticFeedback.lightImpact();
        }
      });
      
      _controllerInitialized = true;
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _particleAnimController.dispose();
    _pulseAnimController.dispose();
    _floatAnimController.dispose();
    _rotateAnimController.dispose();
    _shimmerAnimController.dispose();
    super.dispose();
  }

  // Advanced particle effect background
  Widget _buildAnimatedBackground() {
    return IgnorePointer(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Rotating gradient background
              AnimatedBuilder(
                animation: _rotateAnimController,
                builder: (context, _) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: SweepGradient(
                        center: Alignment.center,
                        startAngle: 0,
                        endAngle: 2 * pi,
                        transform: GradientRotation(_rotateAnimController.value * 2 * pi),
                        colors: [
                          Colors.black,
                          _services[_pageNotifier.value.round() % _services.length].color.withOpacity(0.3),
                          Colors.black,
                          Colors.black.withOpacity(0.8),
                        ],
                        stops: const [0.0, 0.3, 0.6, 1.0],
                      ),
                    ),
                  );
                },
              ),
              
              // Dynamic particle system
              AnimatedBuilder(
                animation: _particleAnimController,
                builder: (context, _) {
                  final service = _services[_pageNotifier.value.round() % _services.length];
                  return Stack(
                    children: List.generate(80, (index) {
                      final random = Random(index * 2);
                      
                      // Create different particle types
                      final particleType = index % 4;
                      
                      // Calculate dynamic positions with various movement patterns
                      final angle = _particleAnimController.value * 2 * pi + index;
                      final radius = 50 + 200 * random.nextDouble() * (1 + 0.2 * sin(angle));
                      final dx = cos(angle) * radius;
                      final dy = sin(angle) * radius;
                      
                      // Dynamic size that pulses and varies by particle
                      final pulseOffset = index % 10 / 10;
                      final pulseValue = sin(_particleAnimController.value * 2 * pi + pulseOffset * 2 * pi);
                      final size = (5 + 15 * random.nextDouble()) * (1 + 0.2 * pulseValue);
                      
                      // Dynamic opacity
                      final opacity = 0.1 + 0.2 * random.nextDouble() + 0.1 * (1 + sin(_particleAnimController.value * 2 * pi + index))/2;
                      
                      return Positioned(
                        left: constraints.maxWidth / 2 + dx - size/2,
                        top: constraints.maxHeight / 2 + dy - size/2,
                        child: Transform.rotate(
                          angle: particleType == 1 ? _particleAnimController.value * 2 * pi : 0,
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 500 + random.nextInt(500)),
                            width: size,
                            height: size,
                            decoration: BoxDecoration(
                              color: particleType == 3 
                                  ? Colors.white.withOpacity(opacity * 0.8)
                                  : service.color.withOpacity(opacity),
                              shape: particleType == 2 ? BoxShape.rectangle : BoxShape.circle,
                              borderRadius: particleType == 2 ? BorderRadius.circular(2) : null,
                              boxShadow: [
                                BoxShadow(
                                  color: service.color.withOpacity(opacity * 0.5),
                                  blurRadius: 15,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),
              
              // Lens flare effect
              AnimatedBuilder(
                animation: _pulseAnimController,
                builder: (context, child) {
                  final service = _services[_pageNotifier.value.round() % _services.length];
                  return Positioned(
                    top: constraints.maxHeight * 0.2,
                    right: constraints.maxWidth * 0.15,
                    child: Container(
                      width: 150 + 30 * _pulseAnimController.value,
                      height: 150 + 30 * _pulseAnimController.value,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            service.color.withOpacity(0.1 + 0.1 * _pulseAnimController.value),
                            Colors.transparent,
                          ],
                          stops: [0.1, 1.0],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: service.color.withOpacity(0.1),
                            blurRadius: 50,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              
              // Subtle grid overlay
              Opacity(
                opacity: 0.15,
                child: Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1553481187-be93c21490a9?auto=format&fit=crop&w=100&q=10'),
                      repeat: ImageRepeat.repeat,
                      opacity: 0.1,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Enhanced navigation indicator
  Widget _buildNavigationIndicator() {
    final size = MediaQuery.of(context).size;
    final isSmallMobile = size.width < 480;
    final isMobile = size.width < 768;
    
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallMobile ? 20 : 30),
      child: Column(
        children: [
          ValueListenableBuilder<double>(
            valueListenable: _pageNotifier,
            builder: (context, value, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_services.length, (index) {
                  final distance = (value - index).abs();
                  final isActive = distance < 0.5;
                  final isNearby = distance < 1.5;
                  
                  return GestureDetector(
                    onTap: () => _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                    ),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isActive 
                          ? (isSmallMobile ? 30 : 50) 
                          : isNearby 
                              ? (isSmallMobile ? 12 : 18) 
                              : (isSmallMobile ? 8 : 12),
                      height: isSmallMobile ? 6 : 8,
                      margin: EdgeInsets.symmetric(horizontal: isSmallMobile ? 3 : 5),
                      decoration: BoxDecoration(
                        color: isActive 
                            ? _services[index].color
                            : isNearby 
                                ? _services[index].color.withOpacity(0.4)
                                : Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(isSmallMobile ? 3 : 4),
                        boxShadow: isActive ? [
                          BoxShadow(
                            color: _services[index].color.withOpacity(0.6),
                            blurRadius: 8,
                            spreadRadius: 2,
                          )
                        ] : [],
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          
          // Service labels beneath indicators
          if (!isMobile) 
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ValueListenableBuilder<double>(
                valueListenable: _pageNotifier,
                builder: (context, value, _) {
                  final currentIndex = value.round() % _services.length;
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    child: Text(
                      _services[currentIndex].title,
                      key: ValueKey('nav_title_${_services[currentIndex].title}'),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.7),
                        fontFamily: "Inter",
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Enhanced content section
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallMobile = size.width < 480;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;
    final isDesktop = size.width >= 1024;

    return Container(
      height: isSmallMobile 
          ? size.height * 1.2 
          : isMobile 
              ? size.height * 1.1 
              : isTablet 
                  ? size.height * 1.0 
                  : size.height * 0.95,
      child: Stack(
        children: [
          // Complex animated background
          _buildAnimatedBackground(),
          
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header section
              Padding(
                padding: EdgeInsets.only(
                  top: isSmallMobile ? 40 : isMobile ? 60 : isTablet ? 80 : 100,
                  left: isSmallMobile ? 20 : isMobile ? 30 : isTablet ? 60 : 100,
                  right: isSmallMobile ? 20 : isMobile ? 30 : isTablet ? 60 : 100,
                  bottom: isSmallMobile ? 20 : 30,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Interactive title with hover effects
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
                                stops: [
                                  0.0, 
                                  (_shimmerAnimController.value + 0.5) % 1.0, 
                                  1.0
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: Text(
                              "Enterprise Technology Solutions",
                              style: TextStyle(
                                fontSize: isSmallMobile ? 28 : isMobile ? 36 : isTablet ? 42 : 52,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontFamily: "SpaceGrotesk",
                                height: 1.1,
                                letterSpacing: isSmallMobile ? -1 : -2,
                                shadows: [
                                  BoxShadow(
                                    color: _isHoveringTitle
                                        ? _services[_pageNotifier.value.round() % _services.length].color.withOpacity(0.7)
                                        : Colors.black.withOpacity(0.5),
                                    blurRadius: _isHoveringTitle ? 25 : 15,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      ),
                    ),
                    
                    // Subtitle with dynamic content based on current service
                    SizedBox(height: isSmallMobile ? 15 : 25),
                    ValueListenableBuilder<double>(
                      valueListenable: _pageNotifier,
                      builder: (context, value, _) {
                        final currentIndex = value.round() % _services.length;
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 600),
                          child: Column(
                            key: ValueKey('subtitle_column_${_services[currentIndex].title}'),
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Service-specific subtitle
                              Text(
                                _services[currentIndex].subtitle,
                                style: TextStyle(
                                  fontSize: isSmallMobile ? 14 : isMobile ? 16 : isTablet ? 18 : 22,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                  fontFamily: "Inter",
                                  height: 1.5,
                                  letterSpacing: 0.2,
                                ),
                              ),
                              
                              // Service badge
                              Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.symmetric(
                                  horizontal: isSmallMobile ? 10 : 12, 
                                  vertical: isSmallMobile ? 4 : 6
                                ),
                                decoration: BoxDecoration(
                                  color: _services[currentIndex].color.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: _services[currentIndex].color.withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: _services[currentIndex].color.withOpacity(0.2),
                                      blurRadius: 10,
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: isSmallMobile ? 14 : 16,
                                      color: _services[currentIndex].color,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      _services[currentIndex].badgeText,
                                      style: TextStyle(
                                        fontSize: isSmallMobile ? 12 : 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white.withOpacity(0.9),
                                        letterSpacing: 0.5,
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
              
              // Main service showcase with PageView
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _services.length,
                  physics: _customScrollPhysics,
                  itemBuilder: (context, index) {
                    return _EnterpriseServiceCard(
                      key: ValueKey(_services[index].title),
                      service: _services[index],
                      pageNotifier: _pageNotifier,
                      index: index,
                      expandedSections: _expandedSections,
                      selectedCaseStudy: _selectedCaseStudy,
                      onToggleSection: (sectionIndex, expanded) {
                        setState(() {
                          _expandedSections[sectionIndex] = expanded;
                        });
                      },
                      onSelectCaseStudy: (caseStudyIndex) {
                        setState(() {
                          _selectedCaseStudy = caseStudyIndex;
                        });
                        
                        // Provide haptic feedback when selecting case study
                        HapticFeedback.mediumImpact();
                      },
                      pulseAnimation: _pulseAnimController,
                      floatAnimation: _floatAnimController,
                    );
                  },
                ),
              ),
              
              // Enhanced navigation indicators
              _buildNavigationIndicator(),
            ],
          ),
        ],
      ),
    );
  }
}

// Enhanced service card with advanced animations and interactivity
class _EnterpriseServiceCard extends StatefulWidget {
  final EnterpriseService service;
  final ValueNotifier<double> pageNotifier;
  final int index;
  final Map<int, bool> expandedSections;
  final int? selectedCaseStudy;
  final Function(int, bool) onToggleSection;
  final Function(int?) onSelectCaseStudy;
  final AnimationController pulseAnimation;
  final AnimationController floatAnimation;

  const _EnterpriseServiceCard({
    required super.key,
    required this.service,
    required this.pageNotifier,
    required this.index,
    required this.expandedSections,
    required this.selectedCaseStudy,
    required this.onToggleSection,
    required this.onSelectCaseStudy,
    required this.pulseAnimation,
    required this.floatAnimation,
  });

  @override
  State<_EnterpriseServiceCard> createState() => _EnterpriseServiceCardState();
}

class _EnterpriseServiceCardState extends State<_EnterpriseServiceCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _featureController;
  double tiltX = 0;
  double tiltY = 0;
  bool _isHovering = false;
  Map<String, bool> _hoveredFeatures = {};
  
  final _scrollController = ScrollController();
  bool _showScrollIndicator = false;

  @override
  void initState() {
    super.initState();
    _featureController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _scrollController.addListener(() {
      setState(() {
        _showScrollIndicator = _scrollController.offset > 20 &&
            _scrollController.position.maxScrollExtent > _scrollController.offset + 100;
      });
    });
    
    // Initialize feature hover states
    for (var feature in widget.service.features) {
      _hoveredFeatures[feature.title] = false;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateAnimation();
  }

  void _updateAnimation() {
    final isActive = widget.pageNotifier.value.round() == widget.index;
    if (isActive) {
      _featureController.forward();
    } else {
      _featureController.reset();
    }
  }

  @override
  void dispose() {
    _featureController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // Enhanced 3D tilt effect with smooth transitions
  void _updatePosition(Offset localPosition) {
    final size = context.size!;
    final x = (localPosition.dx / size.width) * 2 - 1;
    final y = (localPosition.dy / size.height) * 2 - 1;
    
    // Calculate tilt angles with magnification near edges
    final magnificationFactor = 1.0 + (x.abs() + y.abs()) * 0.3;
    
    setState(() {
      // Smooth transition with increased tilt near the edges
      tiltX = y * 5 * magnificationFactor;
      tiltY = -x * 5 * magnificationFactor;
      
      // Apply haptic feedback when tilting past threshold
      if ((tiltX.abs() > 8 || tiltY.abs() > 8) && 
          (tiltX.abs() % 2.0).abs() < 0.1) {
        HapticFeedback.lightImpact();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallMobile = size.width < 480;
    final isMobile = size.width < 768;
    final isTablet = size.width >= 768 && size.width < 1024;
    final isDesktop = size.width >= 1024;
    
    final page = widget.pageNotifier.value;
    final pageOffset = (page - widget.index).abs();
    final active = page.round() == widget.index;

    return ValueListenableBuilder<double>(
      valueListenable: widget.pageNotifier,
      builder: (context, page, _) {
        _updateAnimation();
        final scale = 1.0 - (pageOffset * 0.05).clamp(0.0, 0.1); 
        final opacity = (1.0 - pageOffset).clamp(0.3, 1.0);
        
        return MouseRegion(
          onEnter: (e) => setState(() => _isHovering = true),
          onHover: (e) => _updatePosition(e.localPosition),
          onExit: (_) => setState(() {
            _isHovering = false;
            tiltX = 0;
            tiltY = 0;
          }),
          child: AnimatedScale(
            scale: active ? 1 : scale,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutQuint,
            child: AnimatedOpacity(
              opacity: opacity,
              duration: const Duration(milliseconds: 400),
              child: isMobile
                  ? _buildMobileCard(context)
                  : _buildDesktopCard(context),
            ),
          ),
        );
      },
    );
  }

  // Desktop card with advanced animations and 3D effects
  Widget _buildDesktopCard(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width >= 768 && size.width < 1024;
    final isLargeDesktop = size.width >= 1440;
    
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(_isHovering ? tiltX * pi / 180 : 0)
        ..rotateY(_isHovering ? tiltY * pi / 180 : 0)
        ..translate(0.0, widget.floatAnimation.value * 8, 0.0),
      alignment: Alignment.center,
      child: Container(
        margin: EdgeInsets.symmetric(
          vertical: isTablet ? 30 : 40, 
          horizontal: isTablet ? 15 : 25
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey.shade900,
              Colors.black.withOpacity(0.8),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: widget.service.color.withOpacity(0.5),
              blurRadius: 30 + widget.pulseAnimation.value * 20,
              spreadRadius: 5,
              offset: Offset(0, 15),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.7),
              blurRadius: 50,
              spreadRadius: 10,
              offset: Offset(0, 20),
            ),
          ],
          border: Border.all(
            color: widget.service.color.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Stack(
              children: [
                // Background image with parallax effect
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOutQuint,
                  top: _isHovering ? -10 : 0,
                  left: _isHovering ? -10 : 0,
                  right: _isHovering ? -10 : 0,
                  bottom: _isHovering ? -10 : 0,
                  child: ShaderMask(
                    shaderCallback: (bounds) => LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.black.withOpacity(0.9),
                      ],
                    ).createShader(bounds),
                    child: Transform.scale(
                      scale: 1.1 + (tiltX.abs() + tiltY.abs()) * 0.01,
                      child: Image.network(
                        widget.service.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.4),
                        colorBlendMode: BlendMode.darken,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: widget.service.color,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded / 
                                    loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                
                // Gradient overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        widget.service.color.withOpacity(0.2),
                        Colors.black.withOpacity(0.9),
                      ],
                      stops: const [0.0, 0.8],
                    ),
                  ),
                ),
                
                // Animated service content
                SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.all(isTablet ? 30 : 40),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service title with advanced effects
                      ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white.withOpacity(0.9),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ).createShader(bounds),
                        child: Text(
                          widget.service.title,
                          style: TextStyle(
                            fontSize: isTablet ? 40 : isLargeDesktop ? 52 : 46,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontFamily: "SpaceGrotesk",
                            letterSpacing: -2,
                            height: 1.1,
                            shadows: [
                              Shadow(
                                color: widget.service.color.withOpacity(0.7),
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 30 : 40),
                      
                      // Advanced feature grid with animations and interactivity
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isTablet ? 2 : 3,
                          childAspectRatio: isTablet ? 2.2 : isLargeDesktop ? 3.0 : 2.5,
                          crossAxisSpacing: isTablet ? 20 : 25,
                          mainAxisSpacing: isTablet ? 20 : 25,
                        ),
                        itemCount: widget.service.features.length,
                        itemBuilder: (context, index) => _buildFeature(index, widget.service.features[index]),
                      ),
                      
                      SizedBox(height: 30),
                      
                      // Industry applications section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Industry Applications",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: "SpaceGrotesk",
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 15,
                            runSpacing: 15,
                            children: widget.service.industryApplications.map((industry) {
                              return Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 15, 
                                  vertical: 12
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: widget.service.color.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      industry.icon,
                                      size: 18,
                                      color: widget.service.color,
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          industry.industry,
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          industry.description,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white.withOpacity(0.7),
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
                      
                      SizedBox(height: 40),
                      
                      // Testimonials section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Client Success Stories",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: "SpaceGrotesk",
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: widget.service.testimonials.map((testimonial) {
                              return Container(
                                width: isTablet ? double.infinity : 400,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      widget.service.color.withOpacity(0.1),
                                      Colors.black.withOpacity(0.2),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.1),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(
                                      Icons.format_quote,
                                      color: widget.service.color,
                                      size: 30,
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      testimonial.quote,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                        color: Colors.white.withOpacity(0.9),
                                        height: 1.6,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: widget.service.color,
                                            boxShadow: [
                                              BoxShadow(
                                                color: widget.service.color.withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: 2,
                                              ),
                                            ],
                                            // Replace with actual avatar when available
                                            image: DecorationImage(
                                              image: NetworkImage('https://i.pravatar.cc/150?u=${testimonial.author.hashCode}'),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 15),
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
                                                fontSize: 14,
                                                color: Colors.white.withOpacity(0.7),
                                              ),
                                            ),
                                          ],
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
                      
                      SizedBox(height: 40),
                      
                      // Resources section
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Resources & Whitepapers",
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 26,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              fontFamily: "SpaceGrotesk",
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: 20),
                          Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            children: widget.service.relatedWhitepapers.map((whitepaper) {
                              return Container(
                                width: isTablet ? double.infinity : 350,
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: widget.service.color.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: widget.service.color.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.article,
                                        color: widget.service.color,
                                        size: 24,
                                      ),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      whitepaper.title,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                        height: 1.4,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      whitepaper.description,
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white.withOpacity(0.7),
                                        height: 1.5,
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.download,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                      label: Text(
                                        "Download Whitepaper",
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                        ),
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: widget.service.color,
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        elevation: 5,
                                        shadowColor: widget.service.color.withOpacity(0.5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      
                      SizedBox(height: 40),
                      
                      // Call to action button
                      Center(
                        child: _buildCtaButton(),
                      ),
                    ],
                  ),
                ),
                
                // Scrolling indicator
                if (_showScrollIndicator)
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _showScrollIndicator ? 1.0 : 0.0,
                        duration: const Duration(milliseconds: 300),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: widget.service.color.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white.withOpacity(0.8),
                                size: 20,
                              ),
                              SizedBox(width: 8),
                              Text(
                                "Scroll for more",
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Mobile card with responsive design and interactive elements
  Widget _buildMobileCard(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallMobile = size.width < 480;
    
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: isSmallMobile ? 20 : 25,
        horizontal: isSmallMobile ? 15 : 20
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.grey.shade900,
            Colors.black.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: widget.service.color.withOpacity(0.4),
            blurRadius: 20 + widget.pulseAnimation.value * 15,
            spreadRadius: 2,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 30,
            spreadRadius: 5,
            offset: Offset(0, 15),
          ),
        ],
        border: Border.all(
          color: widget.service.color.withOpacity(0.2),
          width: 1.5,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background image with overlay
            ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.95),
                ],
                stops: const [0.2, 0.8],
              ).createShader(bounds),
              child: Image.network(
                widget.service.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.5),
                colorBlendMode: BlendMode.darken,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      color: widget.service.color,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / 
                            loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  );
                },
              ),
            ),
            
            // Service content
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.all(isSmallMobile ? 20 : 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Service title
                  Text(
                    widget.service.title,
                    style: TextStyle(
                      fontSize: isSmallMobile ? 28 : 32,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontFamily: "SpaceGrotesk",
                      letterSpacing: -1,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: widget.service.color.withOpacity(0.7),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                  
                  // Service badge
                  Container(
                    margin: EdgeInsets.only(top: 15),
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.service.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: widget.service.color.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified,
                          size: 14,
                          color: widget.service.color,
                        ),
                        SizedBox(width: 5),
                        Text(
                          widget.service.badgeText,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Service description
                  Text(
                    widget.service.subtitle,
                    style: TextStyle(
                      fontSize: isSmallMobile ? 14 : 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                      height: 1.5,
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Features list
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.service.features.length,
                    separatorBuilder: (context, index) => SizedBox(height: 15),
                    itemBuilder: (context, index) => _buildMobileFeature(widget.service.features[index]),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Industry applications
                  Text(
                    "Industry Applications",
                    style: TextStyle(
                      fontSize: isSmallMobile ? 18 : 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: "SpaceGrotesk",
                    ),
                  ),
                  
                  SizedBox(height: 15),
                  
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: widget.service.industryApplications.map((industry) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: widget.service.color.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              industry.icon,
                              size: 16,
                              color: widget.service.color,
                            ),
                            SizedBox(width: 8),
                            Text(
                              industry.industry,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Testimonial
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.service.color.withOpacity(0.1),
                          Colors.black.withOpacity(0.2),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.format_quote,
                          color: widget.service.color,
                          size: 24,
                        ),
                        SizedBox(height: 10),
                        Text(
                          widget.service.testimonials.isNotEmpty 
                              ? widget.service.testimonials[0].quote
                              : "Our clients have experienced transformative results with our solutions.",
                          style: TextStyle(
                            fontSize: 15,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withOpacity(0.9),
                            height: 1.5,
                          ),
                        ),
                        if (widget.service.testimonials.isNotEmpty) ...[
                          SizedBox(height: 15),
                          Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: widget.service.color,
                                  image: DecorationImage(
                                    image: NetworkImage('https://i.pravatar.cc/150?u=${widget.service.testimonials[0].author.hashCode}'),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.service.testimonials[0].author,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                Text(
                                    widget.service.testimonials[0].position,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 25),
                  
                  // Call to action button
                  Center(
                    child: _buildCtaButton(),
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Resources
                  if (widget.service.relatedWhitepapers.isNotEmpty) ...[
                    Text(
                      "Related Resources",
                      style: TextStyle(
                        fontSize: isSmallMobile ? 18 : 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: "SpaceGrotesk",
                      ),
                    ),
                    
                    SizedBox(height: 15),
                    
                    ...widget.service.relatedWhitepapers.map((whitepaper) => Container(
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: widget.service.color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: widget.service.color.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.article,
                                  size: 16,
                                  color: widget.service.color,
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  whitepaper.title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Text(
                            whitepaper.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: 15),
                          ElevatedButton.icon(
                            onPressed: () {},
                            icon: Icon(
                              Icons.download,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: Text(
                              "Download",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: widget.service.color,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              minimumSize: Size(120, 36),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                  
                  SizedBox(height: 30),
                  
                  // Show "Get in touch" call-to-action
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          widget.service.color.withOpacity(0.2),
                          Colors.black.withOpacity(0.4),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.service.color.withOpacity(0.3),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: widget.service.color.withOpacity(0.2),
                          blurRadius: 15,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Ready to transform your business?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallMobile ? 16 : 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: "SpaceGrotesk",
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Our experts are ready to discuss your specific needs and develop a tailored solution.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmallMobile ? 13 : 14,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {},
                              icon: Icon(
                                Icons.calendar_today,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: Text(
                                "Schedule Consultation",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: widget.service.color,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
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
        ),
      ),
    );
  }

  // Enhanced feature card with advanced animations and interactions
  Widget _buildFeature(int index, EnterpriseFeature feature) {
    // Create staggered animations for features
    return AnimatedBuilder(
      animation: _featureController,
      builder: (context, _) {
        // Create staggered appearance with customized timing
        final animation = CurvedAnimation(
          parent: _featureController,
          curve: Interval(
            index * 0.12, // Staggered start times
            min(0.7 + index * 0.12, 1.0), // Overlapping animations
            curve: Curves.easeOutCubic, // Smoother easing
        ));

        // Animated feature entry with multiple effects
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.5),
              end: Offset.zero,
            ).animate(animation),
            child: MouseRegion(
              onEnter: (_) => setState(() {
                feature.isHovered = true;
                HapticFeedback.lightImpact(); // Subtle feedback on hover
              }),
              onExit: (_) => setState(() => feature.isHovered = false),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.mediumImpact();
                  setState(() {
                    // Toggle expanded state for this feature
                    feature.isExpanded = !feature.isExpanded;
                    // Update the selected case study
                    if (feature.isExpanded && feature.caseStudies.isNotEmpty) {
                      widget.onSelectCaseStudy(widget.service.features.indexOf(feature));
                    } else if (!feature.isExpanded && widget.selectedCaseStudy == widget.service.features.indexOf(feature)) {
                      widget.onSelectCaseStudy(null);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    gradient: feature.isHovered
                        ? LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              widget.service.color.withOpacity(0.15),
                              Colors.black.withOpacity(0.3),
                            ],
                          )
                        : null,
                    color: feature.isHovered 
                        ? null 
                        : Colors.black.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: feature.isHovered
                        ? [
                            BoxShadow(
                              color: widget.service.color.withOpacity(0.3),
                              blurRadius: 15,
                              offset: Offset(0, 5),
                            )
                          ]
                        : null,
                    border: Border.all(
                      color: feature.isHovered
                          ? widget.service.color
                          : Colors.white.withOpacity(0.1),
                      width: feature.isHovered ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Feature header with icon and title
                      Row(
                        children: [
                          // Animated icon container
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: feature.isHovered
                                  ? widget.service.color
                                  : Colors.white.withOpacity(0.1),
                              shape: BoxShape.circle,
                              boxShadow: feature.isHovered
                                  ? [
                                      BoxShadow(
                                        color: widget.service.color.withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: 1,
                                      )
                                    ]
                                  : null,
                            ),
                            child: ShaderMask(
                              shaderCallback: (Rect bounds) {
                                return LinearGradient(
                                  colors: feature.isHovered
                                      ? [Colors.white, Colors.white]
                                      : [
                                          widget.service.color,
                                          widget.service.color.withOpacity(0.7),
                                        ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ).createShader(bounds);
                              },
                              child: Icon(
                                feature.icon,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Animated title with custom effect
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return LinearGradient(
                                      colors: [
                                        Colors.white,
                                        Colors.white.withOpacity(0.9),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ).createShader(bounds);
                                  },
                                  child: Text(
                                    feature.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 18,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 6),
                                // Feature description
                                Text(
                                  feature.description,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          // Expandable indicator
                          AnimatedRotation(
                            turns: feature.isExpanded ? 0.25 : 0,
                            duration: const Duration(milliseconds: 300),
                            child: Icon(
                              Icons.chevron_right,
                              color: feature.isHovered
                                  ? widget.service.color
                                  : Colors.white.withOpacity(0.5),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                      
                      // Expandable content
                      if (feature.isExpanded) ...[
                        SizedBox(height: 20),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: widget.service.color.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  feature.details,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    fontSize: 14,
                                    height: 1.6,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                SizedBox(height: 15),
                                
                                // Tech stack section
                                Text(
                                  "Technologies",
                                  style: TextStyle(
                                    color: widget.service.color,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: feature.techStack.map((tech) => Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: widget.service.color.withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      tech,
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.9),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  )).toList(),
                                ),
                                
                                // Case studies section
                                if (feature.caseStudies.isNotEmpty) ...[
                                  SizedBox(height: 20),
                                  Text(
                                    "Case Studies",
                                    style: TextStyle(
                                      color: widget.service.color,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 15,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  ...feature.caseStudies.map((caseStudy) => Container(
                                    margin: EdgeInsets.only(bottom: 10),
                                    padding: EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.1),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          caseStudy.title,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        SizedBox(height: 6),
                                        Text(
                                          caseStudy.description,
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                        SizedBox(height: 8),
                                        Wrap(
                                          spacing: 8,
                                          runSpacing: 8,
                                          children: caseStudy.metrics.map((metric) => Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color: widget.service.color.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(15),
                                            ),
                                            child: Text(
                                              metric,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          )).toList(),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Mobile feature card with enhanced interactivity
  Widget _buildMobileFeature(EnterpriseFeature feature) {
    // Interactive expandable mobile feature card
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() {
          feature.isExpanded = !feature.isExpanded;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.all(feature.isExpanded ? 16 : 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              widget.service.color.withOpacity(feature.isExpanded ? 0.2 : 0.1),
              Colors.black.withOpacity(0.3),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: feature.isExpanded
                ? widget.service.color.withOpacity(0.4)
                : Colors.white.withOpacity(0.1),
            width: feature.isExpanded ? 1.5 : 1,
          ),
          boxShadow: feature.isExpanded ? [
            BoxShadow(
              color: widget.service.color.withOpacity(0.3),
              blurRadius: 15,
              spreadRadius: 1,
            )
          ] : null,
        ),
        child: Column(
          children: [
            // Feature header
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon with glow effect
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: feature.isExpanded
                        ? widget.service.color 
                        : Colors.white.withOpacity(0.05),
                    shape: BoxShape.circle,
                    boxShadow: feature.isExpanded ? [
                      BoxShadow(
                        color: widget.service.color.withOpacity(0.5),
                        blurRadius: 10,
                        spreadRadius: 2,
                      )
                    ] : null,
                  ),
                  child: Icon(
                    feature.icon,
                    color: feature.isExpanded ? Colors.white : widget.service.color,
                    size: 22,
                  ),
                ),
                SizedBox(width: 12),
                
                // Title and description
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        feature.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        feature.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Expand indicator
                AnimatedRotation(
                  turns: feature.isExpanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Icon(
                    Icons.chevron_right,
                    color: feature.isExpanded
                        ? widget.service.color
                        : Colors.white.withOpacity(0.5),
                    size: 20,
                  ),
                ),
              ],
            ),
            
            // Expandable content
            AnimatedCrossFade(
              firstChild: SizedBox(height: 0),
              secondChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 15),
                  Divider(
                    color: Colors.white.withOpacity(0.1),
                    thickness: 1,
                  ),
                  SizedBox(height: 12),
                  Text(
                    feature.details,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  SizedBox(height: 12),
                  
                  // Tech stack chips
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: feature.techStack.map((tech) => Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: widget.service.color.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        tech,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )).toList(),
                  ),
                  
                  // Case study highlight
                  if (feature.caseStudies.isNotEmpty) ...[
                    SizedBox(height: 15),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: widget.service.color.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Case Study: ${feature.caseStudies[0].title}",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            feature.caseStudies[0].description,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 12,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
              crossFadeState: feature.isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      ),
    );
  }

  // Enhanced CTA button with animations and effects
  Widget _buildCtaButton() {
    // Get screen dimensions for responsive sizing
    final size = MediaQuery.of(context).size;
    final isSmallMobile = size.width < 480;
    final isMobile = size.width < 768;
    
    // Create hover state tracker for desktop
    final isHovered = _hoveredFeatures.containsKey('cta') ? _hoveredFeatures['cta']! : false;
    
    return MouseRegion(
      onEnter: !isMobile ? (_) {
        setState(() => _hoveredFeatures['cta'] = true);
        HapticFeedback.lightImpact();
      } : null,
      onExit: !isMobile ? (_) => setState(() => _hoveredFeatures['cta'] = false) : null,
      child: AnimatedBuilder(
        animation: widget.pulseAnimation,
        builder: (context, child) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: widget.service.color.withOpacity(0.4 + widget.pulseAnimation.value * 0.2),
                  blurRadius: 20 + widget.pulseAnimation.value * 10,
                  spreadRadius: 2 + widget.pulseAnimation.value * 2,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: AnimatedScale(
              scale: isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: isHovered ? widget.service.color : Colors.transparent,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallMobile ? 25 : 40, 
                    vertical: isSmallMobile ? 15 : 25
                  ),
                  elevation: isHovered ? 15 : 0,
                  shadowColor: widget.service.color.withOpacity(0.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                    side: BorderSide(
                      color: widget.service.color,
                      width: 2,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Discover Solutions",
                      style: TextStyle(
                        color: isHovered ? Colors.white : widget.service.color,
                        fontFamily: "SpaceGrotesk",
                        fontSize: isSmallMobile ? 16 : 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(width: 10),
                    AnimatedRotation(
                      turns: isHovered ? 0.125 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: EdgeInsets.all(isHovered ? 8 : 0),
                        decoration: BoxDecoration(
                          color: isHovered ? Colors.white.withOpacity(0.2) : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward,
                          color: isHovered ? Colors.white : widget.service.color,
                          size: isSmallMobile ? 18 : 22,
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
    );
  }
}

/// Enhanced service model with extensive metadata and related entities
class EnterpriseService {
  final String title;
  final Color color;
  final String image;
  final String videoUrl;
  final String badgeText;
  final List<EnterpriseFeature> features;
  final List<IndustryApplication> industryApplications;
  final List<Testimonial> testimonials;
  final List<Whitepaper> relatedWhitepapers;
  bool isHovered;
  bool isAnimating;
  DateTime? lastInteraction;
  
  /// Analytics data for dashboard integration
  final ServiceAnalytics? analytics;
  
  /// Optional list of related services for cross-selling
  final List<String> relatedServices;
  
  /// Optional list of technologies used in this service
  final List<String> coreTechnologies;

  EnterpriseService({
    required this.title,
    required this.color,
    required this.image,
    required this.videoUrl,
    required this.badgeText,
    required this.features,
    required this.industryApplications,
    required this.testimonials,
    required this.relatedWhitepapers,
    this.isHovered = false,
    this.isAnimating = false,
    this.lastInteraction,
    this.analytics,
    this.relatedServices = const [],
    this.coreTechnologies = const [],
  });

  String get subtitle {
    switch (title) {
      case "Advanced Intelligence Solutions":
        return "Pioneering AI, machine learning, and robotics solutions powering next-generation business automation";
      case "Digital Ecosystem Architecture":
        return "Enterprise-grade web platforms and cloud architectures built for performance and scalability";
      case "Immersive Experience Design":
        return "Sophisticated mobile applications delivering seamless experiences across all devices";
      case "Intelligent Connected Systems":
        return "Connected intelligent ecosystems empowering data-driven decision making and automation";
      case "Digital Transformation Consulting":
        return "Strategic digital transformation services driving organizational innovation and growth";
      default:
        return "Advanced technology solutions engineered for enterprise excellence";
    }
  }
  
  /// Returns a brief marketing tagline appropriate for social media
  String get tagline {
    switch (title) {
      case "Advanced Intelligence Solutions":
        return "Transform your business with AI that delivers measurable results";
      case "Digital Ecosystem Architecture":
        return "Build scalable platforms that grow with your business";
      case "Immersive Experience Design":
        return "Create memorable experiences that keep customers coming back";
      case "Intelligent Connected Systems":
        return "Connect, monitor, and optimize your entire operation";
      case "Digital Transformation Consulting":
        return "Navigate change with confidence and strategic vision";
      default:
        return "Empowering innovation through technology excellence";
    }
  }
  
  /// Returns ROI metrics associated with this service
  Map<String, String> get roiMetrics {
    switch (title) {
      case "Advanced Intelligence Solutions":
        return {
          "Efficiency Gain": "35-60%",
          "Cost Reduction": "28-45%",
          "Time-to-Value": "3-6 months",
          "ROI": "4.2x annual"
        };
      case "Digital Ecosystem Architecture":
        return {
          "Performance Improvement": "85-200%",
          "Infrastructure Savings": "40-65%",
          "Development Speed": "3x faster",
          "Uptime": "99.99%"
        };
      default:
        return {
          "Efficiency Gain": "30-50%",
          "Cost Reduction": "25-40%",
          "Implementation Time": "3-9 months",
          "ROI": "3.5x annual"
        };
    }
  }
}

/// Enhanced feature model with expanded metadata and state properties
class EnterpriseFeature {
  final IconData icon;
  final String title;
  final String description;
  final String details;
  final List<String> techStack;
  final List<CaseStudy> caseStudies;
  bool isHovered;
  bool isExpanded;
  
  // Optional fields for enhanced UI
  final String? videoUrl;
  final String? demoUrl;
  final List<String> benefits;
  final List<String> capabilities;
  
  // Technical specifications
  final Map<String, String> specifications;
  
  // Feature maturity level
  final FeatureMaturity maturityLevel;
  
  // Animation state
  bool isAnimating;

  EnterpriseFeature({
    required this.icon,
    required this.title,
    required this.description,
    required this.details,
    required this.techStack,
    required this.caseStudies,
    this.isHovered = false,
    this.isExpanded = false,
    this.isAnimating = false,
    this.videoUrl,
    this.demoUrl,
    this.benefits = const [],
    this.capabilities = const [],
    this.specifications = const {},
    this.maturityLevel = FeatureMaturity.established,
  });
  
  /// Returns complexity level based on technical stack
  String get complexityLevel {
    if (techStack.length <= 2) return "Basic";
    if (techStack.length <= 4) return "Intermediate";
    return "Advanced";
  }
}

/// Feature maturity level indicating development status
enum FeatureMaturity {
  emerging,    // New, cutting-edge technology
  established, // Proven in production environments
  mature,      // Widely adopted industry standard
}

/// Case study with detailed metrics and implementation information
class CaseStudy {
  final String title;
  final String description;
  final List<String> metrics;
  final String logoUrl;
  
  // Additional case study details
  final String? industry;
  final String? challenge;
  final String? solution;
  final String? outcome;
  final String? testimonialQuote;
  final String? testimonialAuthor;
  final List<String> technologies;
  final DateTime? implementationDate;
  final String? fullCaseStudyUrl;
  
  // Media assets
  final List<String> imageUrls;
  final String? videoUrl;

  CaseStudy({
    required this.title,
    required this.description,
    required this.metrics,
    required this.logoUrl,
    this.industry,
    this.challenge,
    this.solution,
    this.outcome,
    this.testimonialQuote,
    this.testimonialAuthor,
    this.technologies = const [],
    this.implementationDate,
    this.fullCaseStudyUrl,
    this.imageUrls = const [],
    this.videoUrl,
  });
  
  /// Returns a brief headline summarizing the results
  String get headline {
    if (metrics.isNotEmpty) {
      final primaryMetric = metrics.first.replaceAll(RegExp(r'[0-9%$M]'), '').trim();
      return "${title} achieved remarkable ${primaryMetric}";
    }
    return "${title} transformed their business with our solution";
  }
}

/// Industry vertical with specific application details
class IndustryApplication {
  final String industry;
  final String description;
  final IconData icon;
  
  // Enhanced industry information
  final List<String> keyBenefits;
  final List<String> typicalChallenges;
  final List<String> relevantRegulations;
  final List<String> competitiveAdvantages;
  
  // Market information
  final String? marketSize;
  final String? growthRate;
  
  // Additional resources
  final String? industryReportUrl;
  final String? industrySpecificContentUrl;

  IndustryApplication({
    required this.industry,
    required this.description,
    required this.icon,
    this.keyBenefits = const [],
    this.typicalChallenges = const [],
    this.relevantRegulations = const [],
    this.competitiveAdvantages = const [],
    this.marketSize,
    this.growthRate,
    this.industryReportUrl,
    this.industrySpecificContentUrl,
  });
}

/// Client testimonial with attribution and context
class Testimonial {
  final String quote;
  final String author;
  final String position;
  final String avatar;
  
  // Enhanced testimonial metadata
  final String? companyName;
  final String? industry;
  final String? projectContext;
  final DateTime? testimonialDate;
  final List<String> projectResults;
  final bool isVerified;
  final String? videoTestimonialUrl;

  Testimonial({
    required this.quote,
    required this.author,
    required this.position,
    required this.avatar,
    this.companyName,
    this.industry,
    this.projectContext,
    this.testimonialDate,
    this.projectResults = const [],
    this.isVerified = true,
    this.videoTestimonialUrl,
  });
  
  /// Returns a properly formatted attribution string
  String get attribution {
    String attribution = "$author, $position";
    if (companyName != null) {
      attribution += ", $companyName";
    }
    return attribution;
  }
}

/// Whitepaper with detailed metadata and related content
class Whitepaper {
  final String title;
  final String description;
  final String downloadUrl;
  final String thumbnailUrl;
  
  // Enhanced whitepaper metadata
  final List<String> authors;
  final DateTime? publicationDate;
  final List<String> topics;
  final int? pageCount;
  final String? fileFormat;
  final int? fileSize; // in KB
  final List<String> keywords;
  final String? abstract;
  final List<String> relatedWhitepapers;
  final bool requiresRegistration;

  Whitepaper({
    required this.title,
    required this.description,
    required this.downloadUrl,
    required this.thumbnailUrl,
    this.authors = const [],
    this.publicationDate,
    this.topics = const [],
    this.pageCount,
    this.fileFormat,
    this.fileSize,
    this.keywords = const [],
    this.abstract,
    this.relatedWhitepapers = const [],
    this.requiresRegistration = true,
  });
}

/// Analytics data for service performance tracking
class ServiceAnalytics {
  final int inquiriesLastMonth;
  final int projectsCompleted;
  final double averageClientSatisfaction; // 0-10 scale
  final int totalRevenueGenerated; // in thousands
  final double averageImplementationTime; // in months
  final Map<String, double> industryBreakdown; // industry name to percentage
  final List<String> topFeaturesRequested;
  
  ServiceAnalytics({
    required this.inquiriesLastMonth,
    required this.projectsCompleted,
    required this.averageClientSatisfaction,
    required this.totalRevenueGenerated,
    required this.averageImplementationTime,
    required this.industryBreakdown,
    required this.topFeaturesRequested,
  });
}

/// Animation configuration for customizing visual effects
class AnimationConfig {
  final Duration duration;
  final Curve curve;
  final bool enableParticles;
  final bool enableGlow;
  final bool enable3DTilt;
  final double animationIntensity; // 0.0 to 1.0
  
  const AnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutCubic,
    this.enableParticles = true,
    this.enableGlow = true,
    this.enable3DTilt = true,
    this.animationIntensity = 0.7,
  });
}