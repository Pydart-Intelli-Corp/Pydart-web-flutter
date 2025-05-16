import 'package:flutter/material.dart';
import 'package:pydart/components/typography.dart';

RichText slide1Text = RichText(
  text: const TextSpan(
    children: <TextSpan>[
      TextSpan(text: 'Hello', style: carouselBlueTextStyle),
      TextSpan(text: ' and Welcome', style: carouselWhiteTextStyle),
      TextSpan(text: ' to', style: carouselBlueTextStyle),
      TextSpan(text: ' Pydart', style: carouselBlueTextStyle),
      TextSpan(text: ' Intelli', style: carouselWhiteTextStyle),
      TextSpan(text: ' Corp', style: carouselBlueTextStyle),
    ],
  ),
  textAlign: TextAlign.center,
);

RichText slide2Text = RichText(
  text: const TextSpan(
    children: <TextSpan>[
      TextSpan(text: ' End-to-end', style: carouselWhiteTextStyle),
      TextSpan(text: ' IOS, Android &', style: carouselBlueTextStyle),
      TextSpan(text: ' Web', style: carouselBlueTextStyle),
      TextSpan(text: ' development', style: carouselWhiteTextStyle),
     
    ],
  ),
  textAlign: TextAlign.center,
);

RichText slide3Text = RichText(
  text: const TextSpan(
    children: <TextSpan>[
      TextSpan(text: ' Expertise in', style: carouselBlueTextStyle),
      TextSpan(text: ' Embedded', style: carouselWhiteTextStyle),
      TextSpan(text: ' Systems,', style: carouselBlueTextStyle),
      TextSpan(text: ' IOT', style: carouselWhiteTextStyle),
      TextSpan(text: ' &', style: carouselWhiteTextStyle),
      TextSpan(text: ' GUIs', style: carouselWhiteTextStyle),
    ],
  ),
  textAlign: TextAlign.center,
);

RichText slide4Text = RichText(
   text: const TextSpan(
    children: <TextSpan>[
      TextSpan(text: 'Reliable,', style: carouselBlueTextStyle),
      TextSpan(text: ' Scalable, and', style: carouselWhiteTextStyle),
      TextSpan(text: ' Tech-', style: carouselBlueTextStyle),
      TextSpan(text: 'Forward', style: carouselWhiteTextStyle),
      TextSpan(text: ' Solutions', style: carouselWhiteTextStyle),
    
     
    
      
    ],
  ),
  textAlign: TextAlign.center,
);
