import 'package:flutter/material.dart';
import 'package:pydart/ui/carousel/forHomeScreen/carousel_slide_1.dart';
import 'package:pydart/ui/carousel/forHomeScreen/carousel_slide_2.dart';
import 'package:pydart/ui/carousel/forHomeScreen/carousel_slide_3.dart';
import 'package:pydart/ui/carousel/forHomeScreen/carousel_slide_4.dart';

class Carousel extends StatefulWidget {
  static int slideDuration = 6400;
  static int slideCount = 4;
  final List<Widget> slides = [
    CarouselSlide1(slideDuration: slideDuration),
    CarouselSlide2(slideDuration: slideDuration),
    CarouselSlide3(slideDuration: slideDuration),
    CarouselSlide4(slideDuration: slideDuration),
  ];

  Carousel({super.key});

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController animationController;
  int currentSlide = 0;

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: Duration(
            milliseconds:
                (Carousel.slideDuration * Carousel.slideCount).toInt()),
        vsync: this);
    animation = Tween<double>(begin: 0, end: Carousel.slideCount.toDouble())
        .animate(animationController)
      ..addListener(() {
        if (animation.value.floor() != currentSlide &&
            animation.value.floor() < Carousel.slideCount) {
          currentSlide = animation.value.floor();
          setState(() {});
        }
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          restart();
        }
      });
    animationController.forward();
  }

  void restart() {
    animationController.reset();
    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return widget.slides[currentSlide];
  }
}
