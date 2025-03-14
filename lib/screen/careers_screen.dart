import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';


import 'package:flutter_website/ui/carousel/forHomeScreen/carousel.dart';
import 'package:responsive_framework/responsive_framework.dart';



class CareerScreen extends StatefulWidget {
  const CareerScreen({super.key});

  @override
  State<CareerScreen> createState() => _CareerScreenState();
}

class _CareerScreenState extends State<CareerScreen> {
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
    return Scaffold(
      backgroundColor: background,
      appBar: const PreferredSize(
        preferredSize: Size(double.infinity, 66),
        child: Header(),
      ),
      body: Stack(
        children: [
          ListView.builder(
            controller: _scrollController,
            itemCount: blocks.length,
            itemBuilder: (context, index) {
              return blocks[index];
            },
          ),
          if (_showScrollButtons)
            Positioned(
              bottom: 20,
              right: 20,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FloatingActionButton(
                    onPressed: _scrollToTop,
                    backgroundColor: const Color.fromARGB(23, 32, 95, 122),
                    child: const Icon(Icons.arrow_upward, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  FloatingActionButton(
                    onPressed: _scrollToBottom,
                    backgroundColor: const Color.fromARGB(23, 32, 95, 122),
                    child:
                        const Icon(Icons.arrow_downward, color: Colors.white),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

List<Widget> blocks = [
  MaxWidthBox(
    maxWidth: 1200,
    child: FittedBox(
      fit: BoxFit.fitWidth,
      alignment: Alignment.topCenter,
      child: Container(
        width: 1200,
        height: 640,
        alignment: Alignment.center,
        child: RepaintBoundary(child: Carousel()),
      ),
    ),
  ),
 
  const Footer(  g1: Color.fromARGB(22, 17, 49, 63), // First gradient color
        g2: Color.fromARGB(255, 2, 11, 23), // Second gradient color
        ),
];
