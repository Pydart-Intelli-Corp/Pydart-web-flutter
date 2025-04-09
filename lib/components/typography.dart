import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart';

const String fontFamily = "Montserrat";

// Simple
const TextStyle headlineTextStyle = TextStyle(
    fontSize: 44, color: textPrimary, height: 1.2, fontFamily: fontFamily);
const TextStyle headlineTextStyleMobile = TextStyle(
    fontSize: 30, color: textPrimary, height: 1.2, fontFamily: fontFamily);

const TextStyle headlineSecondaryTextStyle = TextStyle(
    fontSize: 16,
    color: Color.fromARGB(255, 255, 255, 255),
    height: 2.0,
    fontFamily: fontFamily);

const TextStyle bodyTextStyle = TextStyle(
    fontSize: 13,
    color: Color.fromARGB(255, 121, 121, 121),
    height: 1.5,
    fontFamily: fontFamily);

TextStyle bodyLinkTextStyle = bodyTextStyle.copyWith(
    color: const Color.fromARGB(255, 121, 121, 121), fontSize: 12);

const TextStyle buttonTextStyle = TextStyle(
    fontSize: 18, color: Colors.white, height: 1, fontFamily: fontFamily);

// Carousel
const TextStyle carouselBlueTextStyle = TextStyle(
    fontSize: 100,
    color: Color(0xFF008AFE),
    fontFamily: fontFamily,
    shadows: [
      Shadow(
        color: Color(0x40000000),
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ]);
const TextStyle carouselYellowTextStyle = TextStyle(
    fontSize: 100,
    color: Color.fromARGB(255, 13, 3, 150),
    fontFamily: fontFamily,
    shadows: [
      Shadow(
        color: Color(0x40000000),
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ]);

const TextStyle carouselWhiteTextStyle = TextStyle(
    fontSize: 100,
    color: Colors.white,
    fontFamily: fontFamily,
    shadows: [
      Shadow(
        color: Color(0x40000000),
        offset: Offset(1, 1),
        blurRadius: 2,
      )
    ]);
