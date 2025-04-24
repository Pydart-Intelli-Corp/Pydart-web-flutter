import 'package:flutter/material.dart';
import 'package:flutter_website/screen/home/blocks/ai_service.dart';
import 'package:flutter_website/screen/home/blocks/app_dev.dart';
import 'package:flutter_website/screen/home/blocks/digital_marketing.dart';
import 'package:flutter_website/screen/home/blocks/project_solution.dart';
import 'package:flutter_website/screen/home/blocks/web_dev.dart';


class ServicesBlock extends StatefulWidget {
  const ServicesBlock({super.key});

  @override
  State<ServicesBlock> createState() => _ServicesBlockState();
}

class _ServicesBlockState extends State<ServicesBlock> {
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _serviceKeys = List.generate(5, (index) => GlobalKey());

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isMobile ? 40 : 100),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black,
            Colors.blueGrey.shade900,
          ],
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 20 : 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionHeader(isMobile),
                const SizedBox(height: 40),
                _buildServiceGrid(isMobile),
                const SizedBox(height: 60),
                _buildCTASection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "🚀 What We Do",
          style: TextStyle(
            fontSize: isMobile ? 34 : 52,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            fontFamily: 'Inter',
            letterSpacing: -1.5,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          "Full-cycle digital product development with cutting-edge technologies and data-driven approach",
          style: TextStyle(
            fontSize: isMobile ? 18 : 22,
            color: Colors.white70,
            height: 1.5,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  Widget _buildServiceGrid(bool isMobile) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : 2,
        mainAxisSpacing: 24,
        crossAxisSpacing: 24,
        childAspectRatio: isMobile ? 1 : 1.2,
      ),
      itemCount: 5,
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return WebDevelopmentService(key: _serviceKeys[index], isMobile: isMobile);
          case 1:
            return AppDevelopmentService(key: _serviceKeys[index], isMobile: isMobile);
          case 2:
            return Project_Solution(key: _serviceKeys[index], isMobile: isMobile);
          case 3:
            return DigitalMarketing_Designs(key: _serviceKeys[index], isMobile: isMobile);
          case 4:
            return AIService(key: _serviceKeys[index], isMobile: isMobile);
          default:
            return const SizedBox();
        }
      },
    );
  }

  Widget _buildCTASection() {
    return Column(
      children: [
        const Divider(color: Colors.white24),
        const SizedBox(height: 40),
        AnimatedButton(
          onPressed: () => _handleScrollToContact(),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Start Innovation Journey",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 24),
            ],
          ),
        ),
      ],
    );
  }

  void _handleScrollToContact() {
    // Add scroll logic here
  }
}

class AnimatedButton extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;

  const AnimatedButton({super.key, required this.onPressed, required this.child});

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _controller.forward(),
      onExit: (_) => _controller.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: TextButton(
          onPressed: widget.onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
            backgroundColor: Colors.blueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Colors.blue.shade400, width: 2),
            ),
            elevation: 4,
            shadowColor: Colors.blueAccent.withOpacity(0.3),
          ),
          child: DefaultTextStyle.merge(
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}