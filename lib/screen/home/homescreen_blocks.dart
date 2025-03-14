import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';

import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';

import 'package:flutter_website/core/constants/videoplayer.dart';
import 'package:flutter_website/widgets/Forms/enquiry_Page.dart';

import 'package:flutter_website/widgets/Forms/investmentEnquiry.dart';
import 'package:flutter_website/widgets/buttons/loading_button.dart';

import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: const EdgeInsets.all(40),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 780),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: RichText(
                  text: TextSpan(
                    children: [
                      const TextSpan(
                          text:
                              "At Pydart, we craft innovative digital solutions for businesses and individuals. From cutting-edge embedded systems to robust  ",
                          style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/docs");
                            },
                          text: "mobile",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text: ", ", style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/web");
                            },
                          text: "web",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text: ", and ", style: headlineSecondaryTextStyle),
                      TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              openUrl("https://flutter.dev/desktop");
                            },
                          text: "software applications",
                          style: headlineSecondaryTextStyle.copyWith(
                              color: primary)),
                      const TextSpan(
                          text:
                              ", we bring your ideas to life. Our expertise extends across industries, ensuring every product we create is functional, user-friendly, and future-ready.",
                          style: headlineSecondaryTextStyle),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 32),
                child: ResponsiveRowColumn(
                  layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
                      ? ResponsiveRowColumnType.COLUMN
                      : ResponsiveRowColumnType.ROW,
                  rowMainAxisAlignment: MainAxisAlignment.center,
                  rowCrossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Mobile Application');
                        },
                        text: "Enquire Now",
                        buttonColor: const Color.fromARGB(181, 56, 134, 49),
                        hoverColor: const Color.fromARGB(181, 56, 134, 49),
                        onClickColor: const Color.fromARGB(255, 27, 69, 111),
                        textColor: Colors.white,
                        textSize: 20,
                        textWeight:
                            FontWeight.w700, // Setting the text color to white
                        buttonWidth: 200,
                        buttonHeight: 50,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void openUrl(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      child: ResponsiveRowColumn(
        layout: ResponsiveBreakpoints.of(context).smallerThan(DESKTOP)
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        columnCrossAxisAlignment: CrossAxisAlignment.center,
        columnMainAxisSize: MainAxisSize.min,
        rowPadding: const EdgeInsets.symmetric(horizontal: 80, vertical: 80),
        columnPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
        columnSpacing: 50,
        rowSpacing: 50,
        children: [
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: buildMaterialIconCircle(
                      "assets/icons/icon_development.png", 68),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text("Fast Development",
                      style: headlineSecondaryTextStyle,
                      textAlign: TextAlign.center),
                ),
                const Text(
                    "At Pydart, we deliver fast, efficient, and high-quality solutions. Our expert team uses cutting-edge tools and agile methods to ensure timely delivery of mobile apps, websites, and embedded systems. Partner with us for speed, precision, and excellence",
                    style: bodyTextStyle,
                    textAlign: TextAlign.justify),
              ],
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: buildMaterialIconCircle("assets/icons/icon_ui.png", 68),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text("Expressive and Flexible UI",
                      style: headlineSecondaryTextStyle,
                      textAlign: TextAlign.center),
                ),
                const Text(
                    "We craft expressive, flexible UIs that captivate users and adapt effortlessly to their needs. With a focus on aesthetics, functionality, and responsiveness, we deliver flawless experiences across all platforms. Let us bring your vision to life with intuitive, stunning interfaces.",
                    style: bodyTextStyle,
                    textAlign: TextAlign.justify),
              ],
            ),
          ),
          ResponsiveRowColumnItem(
            rowFlex: 1,
            rowFit: FlexFit.tight,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: buildMaterialIconCircle(
                      "assets/icons/icon_performance.png", 68),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text("Native Performance",
                      style: headlineSecondaryTextStyle,
                      textAlign: TextAlign.center),
                ),
                RichText(
                  text: TextSpan(
                    style: bodyTextStyle,
                    children: [
                      const TextSpan(
                          text:
                              "We deliver native performance that ensures seamless functionality and optimal speed. Whether it's a mobile app or an embedded system, our solutions are built to leverage the full potential of the platform, providing a smooth and reliable user experience."),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileDevelopment extends StatefulWidget {
  const MobileDevelopment({super.key});

  @override
  State<MobileDevelopment> createState() => _MobileDevelopmentState();
}

class _MobileDevelopmentState extends State<MobileDevelopment> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/videos/mobile.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        // Display the first frame of the video before playback.
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/user-interface.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("IOS & Android Development",
                              style: headlineTextStyleMobile),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                              text:
                                  "We develop cutting-edge mobile applications using the latest technologies, including AI, machine learning, and modern frameworks like Flutter and React Native, to deliver seamless, intelligent, and high-performance experiences for Android and iOS users."),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🚀 Rapid Prototyping   ",
                        ),
                        const TextSpan(
                          text: "📱 Cross-Platform Compatibility   ",
                        ),
                        const TextSpan(
                          text: "🔒 Enhanced Security   ",
                        ),
                      ],
                    ),
                  ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🚀 Rapid Prototyping   ",
                        ),
                        const TextSpan(
                          text: "  📱 Cross-Platform Compatibility   ",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🤖 AI & ML Integration    ",
                        ),
                        const TextSpan(
                          text:
                              "👌 User-Friendly Experience ", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Mobile Application');
                        },
                        text: "BUILD NOW",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: const Color.fromARGB(255, 197, 177, 177),
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle(
                          "assets/icons/user-interface.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text("Mobile App Development",
                          style: headlineTextStyle),
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                              text:
                                  "Pydart provides end-to-end mobile app development services for both  "),
                          TextSpan(
                              text: "Android and iOS,",
                              style: bodyTextStyle.copyWith(
                                  fontStyle: FontStyle.italic)),
                          const TextSpan(
                              text:
                                  " ensuring apps are fast, secure, and user-friendly. "),
                          const TextSpan(text: "\n"),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showDetailsPopup(
                                    context, 'Mobile Application');
                              },
                              text: "BUILD NOW",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight.w400,
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class WebDevelopment extends StatefulWidget {
  const WebDevelopment({super.key});

  @override
  State<WebDevelopment> createState() => _WebDevelopmentState();
}

class _WebDevelopmentState extends State<WebDevelopment> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/videos/website.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/webdev.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Web Development",
                              style: headlineTextStyleMobile),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                              text:
                                  "We craft high-performance websites and web applications using the latest technologies, including AI, machine learning, and modern frameworks like Next.js, React, and ASP.NET Core. Our solutions are scalable, secure, and optimized for a seamless user experience across all devices."),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                const SizedBox(height: 16),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "⚡ Fast Development  ",
                        ),
                        const TextSpan(
                          text: "🛒 E-commerce Platforms",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🔍 SEO Optimization",
                        ),
                        const TextSpan(
                          text:
                              "    📈 Custom Web Applications   ", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Web Application');
                        },
                        text: "BUILD YOUR WEBSITE",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "📈 Custom Web Applications   ",
                        ),
                        const TextSpan(
                          text: "🛒 E-commerce Platforms   ",
                        ),
                        const TextSpan(
                          text: "📂 Content Management Systems (CMS)   ",
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child:
                          buildMaterialIconCircle("assets/icons/webdev.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child:
                          Text("Website Development", style: headlineTextStyle),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "Our web development services cater to your business needs, ensuring responsive, secure, and user-friendly websites.",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showDetailsPopup(context, 'Web Application');
                              },
                              text: "BUILD YOUR WEBSITE",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight.w400,
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class SoftwareDevelopment extends StatefulWidget {
  const SoftwareDevelopment({super.key});

  @override
  State<SoftwareDevelopment> createState() => _SoftwareDevelopmentState();
}

class _SoftwareDevelopmentState extends State<SoftwareDevelopment> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController = VideoPlayerController.asset("assets/videos/software.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/softdev.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Software Development",
                              style: headlineTextStyleMobile),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                              text:
                                  "we design and develop powerful, custom software solutions tailored to meet your unique business needs. Leveraging cutting-edge technologies like AI, machine learning, cloud computing, and blockchain, we build scalable, secure, and high-performance applications. Our expertise spans desktop, web, and mobile software, ensuring seamless integration, user-friendly experiences, and innovative solutions that drive efficiency and growth."),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🖥️ Custom Software Development",
                        ),
                        const TextSpan(
                          text: " 🔗 System Integration  ",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "☁️ Cloud-based Solutions   ",
                        ),
                        const TextSpan(
                          text:
                              "           📈 Scalability & Flexibility   ", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Web Application');
                        },
                        text: "BUILD YOUR SOFTWARE",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🖥️ Custom Software Development   ",
                        ),
                        const TextSpan(
                          text: "☁️ Cloud-based Solutions   ",
                        ),
                        const TextSpan(
                          text: "🔗 System Integration   ",
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle(
                          "assets/icons/softdev.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text("Software Development",
                          style: headlineTextStyle),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "We deliver custom software solutions designed to meet your specific requirements, leveraging expertise across a wide range of programming languages and platforms.",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showDetailsPopup(
                                    context, 'Software Application');
                              },
                              text: "BUILD YOUR SOFTWARE",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight.w400,
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class BeautifulUI extends StatefulWidget {
  const BeautifulUI({super.key});

  @override
  State<BeautifulUI> createState() => _BeautifulUIState();
}

class _BeautifulUIState extends State<BeautifulUI> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController =
        VideoPlayerController.asset("assets/videos/BeautifulUI.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child:
                              buildMaterialIconCircle("assets/icons/ui.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Expressive, beautiful UIs",
                              style: headlineTextStyleMobile),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                              text:
                                  "We craft expressive and beautiful UIs that combine aesthetics with functionality, delivering visually stunning and highly intuitive user experiences. By leveraging modern design principles, animations, and interactive elements, we create seamless interfaces that enhance user engagement. Our approach ensures that every application is not only visually appealing but also easy to navigate, responsive, and optimized for performance across all devices."),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🎨 User-Centered Design  ",
                        ),
                        const TextSpan(
                          text: "📐 Visual Hierarchy   ",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🧪 Usability Testing",
                        ),
                        const TextSpan(
                          text:
                              "          🖌️ Aesthetic & Minimalist Design ", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Mobile Application');
                        },
                        text: "BUILD NOW",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🎨 User-Centered Design   ",
                        ),
                        const TextSpan(
                          text: "📐 Consistency & Visual Hierarchy   ",
                        ),
                        const TextSpan(
                          text: "⚡ Performance & Responsiveness   ",
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle("assets/icons/ui.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text("Expressive, beautiful UIs",
                          style: headlineTextStyle),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "At Pydart, we specialize in designing expressive and visually stunning user interfaces that "
                                "captivate and engage users. Our approach focuses on creating UIs that are both aesthetically "
                                "pleasing and highly functional, ensuring a seamless and intuitive experience across all devices.",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showDetailsPopup(
                                    context, 'Mobile Application');
                              },
                              text: "BUILD NOW",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight.w400,
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class NativePerformance extends StatefulWidget {
  const NativePerformance({super.key});

  @override
  State<NativePerformance> createState() => _NativePerformanceState();
}

class _NativePerformanceState extends State<NativePerformance> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController =
        VideoPlayerController.asset("assets/videos/NativePerformance.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/perfomance.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Native Performance",
                              style: headlineTextStyleMobile),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "We deliver native performance in our applications, ensuring speed, reliability, and seamless integration with device capabilities. By leveraging platform-specific tools and technologies, we optimize apps for superior functionality and responsiveness.Experience the power of native development with solutions crafted for peak performance and user satisfaction.",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: " 🛠️ Custom Native Features   ",
                        ),
                        const TextSpan(
                          text: "🚀 Faster Time-to-Market   ",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🔗 Third-Party Integrations",
                        ),
                        const TextSpan(
                          text:
                              "      ✨ Smooth Animations  ", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showDetailsPopup(context, 'Mobile Application');
                        },
                        text: "BUILD NOW",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: " 🛠️ Custom Native Features   ",
                        ),
                        const TextSpan(
                          text: "🚀 Faster Time-to-Market   ",
                        ),
                        const TextSpan(
                          text: "🔗 Seamless Third-Party Integrations   ",
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle(
                          "assets/icons/perfomance.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child:
                          Text("Native Performance", style: headlineTextStyle),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "We deliver native performance in our applications, ensuring speed, reliability, and seamless integration with device capabilities. By leveraging platform-specific tools and technologies, we optimize apps for superior functionality and responsiveness.Experience the power of native development with solutions crafted for peak performance and user satisfaction.",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showDetailsPopup(
                                    context, 'Mobile Application');
                              },
                              text: "BUILD NOW",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight.w400,
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class Embeddedsystem extends StatefulWidget {
  const Embeddedsystem({super.key});

  @override
  State<Embeddedsystem> createState() => _EmbeddedsystemState();
}

class _EmbeddedsystemState extends State<Embeddedsystem> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController =
        VideoPlayerController.asset("assets/videos/embeddedd.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/cpu.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Embedded System Development",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 74, 74, 74),
                                  height: 1.2,
                                  fontFamily: fontFamily)),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "We specialize in embedded system development, crafting high-performance firmware, intuitive embedded GUIs, and real-time solutions that seamlessly integrate with hardware, ensuring efficiency, reliability, and an exceptional user experience. 🚀",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "📡 IoT & Connectivity ",
                        ),
                        const TextSpan(
                          text: "       ⏳ Real-Time OS (RTOS)",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🛠️ Debugging & Testing ",
                        ),
                        const TextSpan(
                          text:
                              "    📉 Cost & Size Optimization", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const CommonVideoPlayer(
                                videoAssetPath: 'assets/videos/embedded.mp4',
                              ),
                            ),
                          );
                        },
                        text: "VIEW SAMPLE PROJECT",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "📡Embedded GUI Design and Development",
                        ),
                        const TextSpan(
                          text: "  ⏳Human-Machine Interfaces (HMI)",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🛠️ Hardware-optimized software solutions",
                        ),
                        const TextSpan(
                          text:
                              "    ✨ Firmware Development & Optimization", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle("assets/icons/cpu.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text("Embedded System\nDevelopment",
                          style: TextStyle(
                              fontSize: 40,
                              color: Color.fromARGB(255, 74, 74, 74),
                              height: 1.2,
                              fontFamily: fontFamily)),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "We specialize in embedded system development, crafting high-performance firmware, intuitive embedded GUIs, and real-time solutions that seamlessly integrate with hardware, ensuring efficiency, reliability, and an exceptional user experience. 🚀",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const CommonVideoPlayer(
                                      videoAssetPath:
                                          'assets/videos/embedded.mp4',
                                    ),
                                  ),
                                );
                              },
                              text: "VIEW SAMPLE PROJECT",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight
                                  .w400, // Setting the text color to white
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

class Freestyle extends StatefulWidget {
  const Freestyle({super.key});

  @override
  State<Freestyle> createState() => _FreestyleState();
}

class _FreestyleState extends State<Freestyle> {
  late VideoPlayerController videoController;
  late Future<void> initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    videoController =
        VideoPlayerController.asset("assets/videos/freestyle.mp4");
    videoController.setVolume(0);
    videoController.setLooping(true);
    initializeVideoPlayerFuture = videoController.initialize().then((_) {
      if (mounted) {
        // Display the first frame of the video before playback.
        setState(() {});
        videoPlay();
      }
    });
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  void videoPlay() {
    videoController.play();
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(23, 32, 95, 122),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: border)),
      margin: blockMargin,
      padding: blockPadding(context),
      child: ResponsiveRowColumn(
        layout: isMobile
            ? ResponsiveRowColumnType.COLUMN
            : ResponsiveRowColumnType.ROW,
        rowCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isMobile)
            ResponsiveRowColumnItem(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: buildMaterialIconCircle(
                              "assets/icons/mobile-app.png", 40),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child: Text("Freestyle",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color.fromARGB(255, 74, 74, 74),
                                  height: 1.2,
                                  fontFamily: fontFamily)),
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "A game-changer in style, wellness, and beyond. It’s built to inspire and redefine how we connect with what matters. Innovative, exciting, and just for you. Get ready for something that speaks to your lifestyle. The wait will be worth it!",
                          ),
                        ],
                      ),
                      textAlign: TextAlign.justify,
                    )
                  ],
                ),
              ),
            ),
          ResponsiveRowColumnItem(
            rowFlex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder(
                  future: initializeVideoPlayerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return AspectRatio(
                        aspectRatio: videoController.value.aspectRatio,
                        child: RepaintBoundary(
                            child: VideoPlayer(videoController)),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                if (isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text:
                              "🌐 A space where connections and trends thrive\n",
                        ),
                        const TextSpan(
                          text: "⏳ A platform that adapts to your lifestyle\n",
                        ),
                        const TextSpan(
                          text:
                              "⚡ A seamless way to save time and look your best\n",
                        ),
                        const TextSpan(
                          text: "✨ Personalized grooming recommendations\n",
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
                if (isMobile)
                  Center(
                    child: ResponsiveRowColumnItem(
                      child: LoadingButton(
                        onPressed: () {
                          _showInvestmentEnquiry(context);
                        },
                        text: "PARTNER WITH US",
                        buttonColor: const Color.fromARGB(181, 30, 94, 147),
                        hoverColor: const Color.fromARGB(181, 30, 94, 147),
                        onClickColor: const Color.fromARGB(181, 56, 134, 49),
                        textColor: Colors.white,
                        textSize: 13,
                        textWeight: FontWeight.w400,
                        buttonWidth: 180,
                        buttonHeight: 30,
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
                if (!isMobile)
                  RichText(
                    textAlign: TextAlign.justify,
                    text: TextSpan(
                      style: bodyTextStyle,
                      children: [
                        const TextSpan(text: "\n"),
                        TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () {},
                          text: "Key Offerings:",
                          style: bodyLinkTextStyle,
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text: "🌐A space where connections and trends thrive",
                        ),
                        const TextSpan(
                          text:
                              "     ⏳A platform that adapts to your lifestyle",
                        ),
                        const TextSpan(text: "\n\n"),
                        const TextSpan(
                          text:
                              "⚡ A seamless way to save time and look your best",
                        ),
                        const TextSpan(
                          text:
                              "    ✨ Personalized grooming recommendations", // Added key offering
                        ),
                        const TextSpan(text: "\n\n"),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          if (!isMobile)
            ResponsiveRowColumnItem(
              rowFlex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 32, 25, 0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: buildMaterialIconCircle(
                          "assets/icons/mobile-app.png", 68),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 32),
                      child: Text("Freestyle",
                          style: TextStyle(
                              fontSize: 40,
                              color: Color.fromARGB(255, 74, 74, 74),
                              height: 1.2,
                              fontFamily: fontFamily)),
                    ),
                    RichText(
                      textAlign: TextAlign.justify,
                      text: TextSpan(
                        style: bodyTextStyle,
                        children: [
                          const TextSpan(
                            text:
                                "A game-changer in style, wellness, and beyond. It’s built to inspire and redefine how we connect with what matters. Innovative, exciting, and just for you. Get ready for something that speaks to your lifestyle. The wait will be worth it!",
                          ),
                          const TextSpan(text: "\n\n"),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ResponsiveRowColumn(
                        layout: ResponsiveBreakpoints.of(context)
                                .smallerThan(DESKTOP)
                            ? ResponsiveRowColumnType.COLUMN
                            : ResponsiveRowColumnType.ROW,
                        rowMainAxisAlignment: MainAxisAlignment.center,
                        rowCrossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ResponsiveRowColumnItem(
                            child: LoadingButton(
                              onPressed: () {
                                _showInvestmentEnquiry(context);
                              },
                              text: "PARTNER WITH US",
                              buttonColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              hoverColor:
                                  const Color.fromARGB(181, 30, 94, 147),
                              onClickColor:
                                  const Color.fromARGB(181, 56, 134, 49),
                              textColor: Colors.white,
                              textSize: 13,
                              textWeight: FontWeight
                                  .w400, // Setting the text color to white
                              buttonWidth: 180,
                              buttonHeight: 30,
                            ),
                          ),
                        ],
                      ),
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

void _showDetailsPopup(BuildContext context, String dropdownValue) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ResponsiveDialog(dropdownValue: dropdownValue);
    },
  );
}

void _showInvestmentEnquiry(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return InvestorInquiryDialog();
    },
  );
}
