import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:responsive_framework/responsive_framework.dart';

class Features extends StatelessWidget {
  const Features({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(221, 0, 0, 0),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: border),
      ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Fast Development",
                    style: headlineSecondaryTextStyle.copyWith(
                      fontFamily: "Montserrat",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "At Pydart, we deliver fast, efficient, and high-quality solutions. Our expert team uses cutting-edge tools and agile methods to ensure timely delivery of mobile apps, websites, and embedded systems. Partner with us for speed, precision, and excellence",
                  style: bodyTextStyle.copyWith(
                    fontFamily: "Montserrat",
                    color: AppColors.whitegrey,
                    fontSize: 14
                  ),
                  textAlign: TextAlign.justify,
                ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Expressive and Flexible UI",
                    style: headlineSecondaryTextStyle.copyWith(
                      fontFamily: "Montserrat",
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  "We craft expressive, flexible UIs that captivate users and adapt effortlessly to their needs. With a focus on aesthetics, functionality, and responsiveness, we deliver flawless experiences across all platforms. Let us bring your vision to life with intuitive, stunning interfaces.",
                  style: bodyTextStyle.copyWith(
                    fontFamily: "Montserrat",
                              color: AppColors.whitegrey,
                    fontSize: 14
                  ),
                  textAlign: TextAlign.justify,
                ),
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    "Native Performance",
                    style: headlineSecondaryTextStyle.copyWith(
                      fontFamily: "Montserrat",
                      
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: bodyTextStyle.copyWith(fontFamily: "Montserrat"),
                    children:  [
                      TextSpan(
                        text:
                            "We deliver native performance that ensures seamless functionality and optimal speed. Whether it's a mobile app or an embedded system, our solutions are built to leverage the full potential of the platform, providing a smooth and reliable user experience.",
                      style: bodyTextStyle.copyWith(
                    fontFamily: "Montserrat",
                              color: AppColors.whitegrey,
                    fontSize: 14
                  ), ),
                    ],
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
