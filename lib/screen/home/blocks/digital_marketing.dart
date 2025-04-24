import 'package:flutter/material.dart';

class DigitalMarketing_Designs extends StatefulWidget {
  final bool isMobile;

  const DigitalMarketing_Designs({super.key, required this.isMobile});

  @override
  State<DigitalMarketing_Designs> createState() => _DigitalMarketing_DesignsState();
}

class _DigitalMarketing_DesignsState extends State<DigitalMarketing_Designs> 
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    Future.delayed(const Duration(milliseconds: 300), () => _controller.forward());
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Container(
          decoration: _buildCardDecoration(),
          child: Padding(
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
        ),
      ),
    );
  }

  BoxDecoration _buildCardDecoration() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF4A148C), Color(0xFF6A1B9A)],
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.greenAccent.withOpacity(0.2),
          blurRadius: 20,
          spreadRadius: 2,
        )
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: const Text("📈", style: TextStyle(fontSize: 28)),
        ),
        const SizedBox(width: 16),
        Text(
          "Digital Marketing",
          style: TextStyle(
            fontSize: widget.isMobile ? 24 : 28,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Text(
      "Building cross-platform mobile experiences with native performance and cutting-edge integrations",
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
        _buildFeatureItem("🎯 Targeted advertising campaigns"),
        _buildFeatureItem("📊 Analytics-driven SEO strategy"),
        _buildFeatureItem("🎨 Brand identity design"),
        _buildFeatureItem("📽️ Video production & editing"),
        _buildFeatureItem("📱 Social media management"),
      ],
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.arrow_right_alt, color: Colors.white70, size: 24),
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
    );
  }

  Widget _buildTechStack() {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
     _buildTechChip("Google Ads", Colors.blue),
  _buildTechChip("Meta Business", Colors.indigo),
  _buildTechChip("Adobe Suite", Colors.pink),
  _buildTechChip("Canva", Colors.teal),
  _buildTechChip("Google Analytics", Colors.orange)
      ],
    );
  }

  Widget _buildTechChip(String text, Color color) {
    return Container(
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
    );
  }
}