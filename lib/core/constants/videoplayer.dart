import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_io/io.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
class CommonVideoPlayer extends StatefulWidget {
  final String videoAssetPath;

  const CommonVideoPlayer({super.key, required this.videoAssetPath});

  @override
  State<CommonVideoPlayer> createState() =>
      _CommonVideoPlayerState();
}

class _CommonVideoPlayerState extends State<CommonVideoPlayer> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;
  bool _isFullscreen = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAssetPath);
    _controller.setVolume(1.0);
    _controller.setLooping(true);
    _initializeVideoPlayerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _seekForward() {
    final currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition + const Duration(seconds: 10));
  }

  void _seekBackward() {
    final currentPosition = _controller.value.position;
    _controller.seekTo(currentPosition - const Duration(seconds: 10));
  }

  void _toggleFullscreen() {
    if (_isFullscreen) {
      // Exit fullscreen
      setState(() {
        _isFullscreen = false;
      });
      _restoreOrientation();
    } else {
      // Enter fullscreen
      setState(() {
        _isFullscreen = true;
      });
      _setLandscapeOrientation();
    }
  }

  Future<void> _setLandscapeOrientation() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
      ]);
    }
  }

  Future<void> _restoreOrientation() async {
    if (Platform.isAndroid || Platform.isIOS) {
      await SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }
  }

  Widget _buildFullscreenContent() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: VideoPlayer(_controller),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: _toggleFullscreen,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _seekBackward,
                  icon: const Icon(Icons.replay_10,
                      color: Colors.white, size: 30),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _controller.value.isPlaying
                          ? _controller.pause()
                          : _controller.play();
                    });
                  },
                  icon: Icon(
                    _controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                IconButton(
                  onPressed: _seekForward,
                  icon: const Icon(Icons.forward_10,
                      color: Colors.white, size: 30),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return _isFullscreen
        ? _buildFullscreenContent()
        : Scaffold(
          backgroundColor: Color.fromRGBO(0, 0, 0, 0.8),  // 80% opacity
 // 204 is ~80% opacity (255 * 0.8)

            body: Stack(
              children: [
                // Blur background
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child:Container(color: Color.fromRGBO(0, 0, 0, 0.5)),  // 50% opacity

                ),
                // Close button
                Positioned(
                  top: 20,
                  left: 20,
                  child: IconButton(
                    icon: const Icon(Icons.close,
                        color: Colors.white, size: 28),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                // Main content
                Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Video Player
                        FutureBuilder(
                          future: _initializeVideoPlayerFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return SizedBox(
                                width: screenWidth * 0.5,
                                child: AspectRatio(
                                  aspectRatio: _controller.value.aspectRatio,
                                  child: VideoPlayer(_controller),
                                ),
                              );
                            } else {
                              return const CircularProgressIndicator();
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        // Playback Controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Seek Backward
                            IconButton(
                              onPressed: _seekBackward,
                              icon: const Icon(Icons.replay_10,
                                  color: Colors.white, size: 28),
                            ),
                            // Play/Pause
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _controller.value.isPlaying
                                      ? _controller.pause()
                                      : _controller.play();
                                });
                              },
                              icon: Icon(
                                _controller.value.isPlaying
                                    ? Icons.pause
                                    : Icons.play_arrow,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                            // Seek Forward
                            IconButton(
                              onPressed: _seekForward,
                              icon: const Icon(Icons.forward_10,
                                  color: Colors.white, size: 28),
                            ),
                            // Fullscreen Toggle
                            IconButton(
                              onPressed: _toggleFullscreen,
                              icon: const Icon(Icons.fullscreen,
                                  color: Colors.white, size: 28),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
