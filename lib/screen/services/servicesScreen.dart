import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart';

import 'package:flutter_website/screen/services/blocks/Embeddedsystem.dart';
import 'package:flutter_website/screen/services/blocks/Generative_AI.dart';
import 'package:flutter_website/screen/services/blocks/MobileDevelopment.dart';

import 'package:flutter_website/screen/services/blocks/SoftwareDevelopment.dart';
import 'package:flutter_website/screen/services/blocks/WebDevelopment.dart';

import 'package:flutter_website/screen/services/blocks/features.dart';

import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'dart:async';

import 'ServicesHead.dart';

// Custom Scroll Behavior to disable the overscroll glow.
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButtons = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      if (currentScroll > maxScroll / 10) {
        if (!_showScrollButtons) {
          setState(() {
            _showScrollButtons = true;
          });
        }
      } else {
        if (_showScrollButtons) {
          setState(() {
            _showScrollButtons = false;
          });
        }
      }
    });
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using LayoutBuilder to get the available height (excluding the AppBar)
    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 66),
        child: Header(),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final halfHeight = constraints.maxHeight / 2;
          // Adjust the offset here (e.g. 50 pixels) to move all content upward.
          const double upwardOffset = 300;
          return Stack(
            children: [
              // Background with two halves:
              // Top half: Video player.
              // Bottom half: Black screen.
              Column(
                children: [
                  SizedBox(
                    height: halfHeight,
                    child: const FixedImageBackground(),
                  ),
                  Expanded(
                    child: Container(color: Colors.black),
                  ),
                ],
              ),
              // Scrollable Content Layer – starting below the video,
              // but shifted upward by subtracting from the top padding.
              ScrollConfiguration(
                behavior: NoGlowScrollBehavior(),
                child: ListView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(top:10),
                  children:  [
                    ServicesHead(),
                    GenerativeAIBlock(),
                    Features(),
                    MobileAppDevelopmentBlock(),
                    WebDevelopmentBlock(),
                    SoftwareDevelopmentBlock(),
                   
                    EmbeddedSystemDevelopmentBlock(),
            
                    Footer(  g1: Color.fromARGB(255, 5, 11, 13), // First gradient color
        g2: Color.fromARGB(255, 4, 6, 9), // Second gradient color
        ),
                  ],
                ),
              ),
              // Floating Scroll Buttons Layer
              if (_showScrollButtons)
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FloatingActionButton(
                        onPressed: _scrollToTop,
                        backgroundColor: Color.fromARGB(23, 32, 95, 122),
                        child: Icon(Icons.arrow_upward, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        onPressed: _scrollToBottom,
                        backgroundColor: Color.fromARGB(23, 32, 95, 122),
                        child: Icon(Icons.arrow_downward, color: Colors.white),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class FixedImageBackground extends StatefulWidget {
  const FixedImageBackground({Key? key}) : super(key: key);

  @override
  _FixedImageBackgroundState createState() => _FixedImageBackgroundState();
}

class _FixedImageBackgroundState extends State<FixedImageBackground> {
  // List of image asset paths.
  final List<String> imagePaths = [
    'assets/images/service1.png',
    'assets/images/service2.png',
    'assets/images/service6.png',
  ];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    // Change image every 5 seconds.
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _currentPage = (_currentPage + 1) % imagePaths.length;
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _pageController,
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return Image.asset(
          imagePaths[index],
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
