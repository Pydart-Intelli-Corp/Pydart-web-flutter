import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/screen/whoweare/blocks/about.dart';
import 'package:flutter_website/screen/whoweare/blocks/vision.dart';
import 'package:flutter_website/screen/whoweare/blocks/whoweareblock.dart';
import 'package:flutter_website/screen/whoweare/blocks/mission.dart';
import 'package:flutter_website/screen/whoweare/blocks/people.dart';
import 'package:flutter_website/ui/blocks/common/footer.dart';
import 'package:flutter_website/ui/blocks/common/header.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

// Custom Scroll Behavior to disable the overscroll glow.
class NoGlowScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}

class WhoweareScreen extends StatefulWidget {
  const WhoweareScreen({super.key});

  @override
  State<WhoweareScreen> createState() => _WhoweareScreenState();
}

class _WhoweareScreenState extends State<WhoweareScreen> {
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
                    child: const FixedVideoBackground(),
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
                  children: const [
                    AboutUs(),
                    IntroBlock(),
                    PeopleBlock(),
                    MissionBlock(),
                    VisionBlock(),
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

// Widget for the fixed video background.
class FixedVideoBackground extends StatefulWidget {
  const FixedVideoBackground({Key? key}) : super(key: key);

  @override
  _FixedVideoBackgroundState createState() => _FixedVideoBackgroundState();
}

class _FixedVideoBackgroundState extends State<FixedVideoBackground> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;
  bool _showOverlay = false;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/videos/about_video.mp4")
      ..setVolume(0)
      ..setLooping(false);

    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoController.play();
      }
    });

    // Listen for video completion and show overlay when done.
    videoController.addListener(() {
      if (videoController.value.position >= videoController.value.duration &&
          !_showOverlay) {
        videoController.pause();
        setState(() {
          _showOverlay = true;
        });
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Stack(
            children: [
              // Video fills the container while maintaining its aspect ratio.
              Positioned.fill(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: videoController.value.size.width,
                    height: videoController.value.size.height,
                    child: VideoPlayer(videoController),
                  ),
                ),
              ),
              // Optional overlay that appears when the video ends.
              if (_showOverlay)
                Container(
                  color: Colors.black.withOpacity(0.9),
                ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
