import 'package:flutter/material.dart';

class WebDevelopmentService extends StatefulWidget {
  final bool isMobile;

  const WebDevelopmentService({super.key, required this.isMobile});

  @override
  State<WebDevelopmentService> createState() => _WebDevelopmentServiceState();
}

class _WebDevelopmentServiceState extends State<WebDevelopmentService>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _backgroundFadeAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _backgroundFadeAnimation = Tween<double>(begin: 0, end: 0.4).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _floatAnimation = Tween<double>(begin: -8, end: 8).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 300,
            minHeight: 500,
            maxWidth: 600,
          ),
          decoration: _buildCardDecoration(),
          child: Stack(
            children: [
              Positioned.fill(
                child: FadeTransition(
                  opacity: _backgroundFadeAnimation,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1487017159836-4e23ece2e4cf',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.black12,
                    ),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ))),
              Positioned.fill(
                child: AnimatedContainer(
                  duration: const Duration(seconds: 2),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      radius: 0.5,
                      colors: [
                        Colors.blueAccent.withOpacity(0.1),
                        Colors.transparent
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildDescription(),
                    const SizedBox(height: 24),
                    _buildFeatureList(),
                    const Spacer(),
                    _buildTechStack(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF1A237E).withOpacity(0.9),
          const Color(0xFF0D47A1).withOpacity(0.9)
        ],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.blueAccent.withOpacity(0.3),
          blurRadius: 30,
          spreadRadius: 5,
          offset: const Offset(0, 10),
        )
      ],
      border: Border.all(
        color: Colors.white.withOpacity(0.1),
        width: 1,
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _floatAnimation.value),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blueAccent.withOpacity(0.3),
                      blurRadius: 10,
                      spreadRadius: 2,
                    )
                  ],
                ),
                child: const Text("💻", style: TextStyle(fontSize: 28)),
              ),
            );
          },
        ),
        const SizedBox(width: 16),
        Text(
          "Web Development",
          style: TextStyle(
            fontSize: widget.isMobile ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: 'Inter',
            shadows: [
              Shadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 4,
                offset: const Offset(2, 2),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      "Crafting high-performance web applications with modern architectures and SEO optimization",
      style: TextStyle(
        fontSize: widget.isMobile ? 16 : 17,
        color: Colors.white70,
        height: 1.5,
        fontFamily: 'Inter',
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: [
        _buildFeatureItem("⚡ Next.js/React/Angular frontends"),
        _buildFeatureItem("🎯 SEO-optimized architecture"),
        _buildFeatureItem("🌍 Geo-targeted content delivery"),
        _buildFeatureItem("🔐 Enterprise-grade security"),
        _buildFeatureItem("📱 Progressive Web Apps"),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              const Icon(Icons.arrow_right_alt,
                  color: Colors.white70, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: widget.isMobile ? 15 : 16,
                    color: Colors.white70,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTechStack() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _buildTechChip("Next.js", Colors.blue),
        _buildTechChip("TypeScript", Colors.blueAccent),
        _buildTechChip("GraphQL", Colors.pink),
        _buildTechChip("Node.js", Colors.green),
        _buildTechChip("AWS", Colors.orange),
        _buildTechChip("Docker", Colors.cyan),
        _buildTechChip("PostgreSQL", Colors.indigo),
        _buildTechChip("Firebase", Colors.amber),
      ],
    );
  }

  Widget _buildTechChip(String text, Color color) {
    return MouseRegion(
      onHover: (_) {},
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'Inter',
          ),
        ),
      ),
    );
  }
}