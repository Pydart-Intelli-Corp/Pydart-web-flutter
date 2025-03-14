import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';


class IntroBlock extends StatefulWidget {
  const IntroBlock({super.key});

  @override
  State<IntroBlock> createState() => _IntroBlockState();
}

class _IntroBlockState extends State<IntroBlock> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      margin: blockMargin,
      padding: blockPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading and logo at the top
          Padding(
            padding: const EdgeInsets.fromLTRB(25, 32, 25, 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                buildMaterialIconCircle("assets/icons/whoweare.png", 68),
                const SizedBox(width: 16),
                const Text("Who We Are?", style: headlineTextStyle),
              ],
            ),
          ),
          // Single, justified paragraph with additional lines and bold emphasis.
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: bodyTextStyle,
                children: [
                  TextSpan(text: "At "),
                  TextSpan(
                    text: "Pydart Intelli Corp",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          ", we are dedicated to creating innovative digital solutions that empower businesses and individuals alike. Our team leverages state-of-the-art technology, including "),
                  TextSpan(
                    text: "AI",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "machine learning",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          ", to craft robust, scalable applications that deliver exceptional user experiences. Our commitment to "),
                  TextSpan(
                    text: "excellence",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                      text:
                          " drives us to push the boundaries of what's possible, ensuring that every project not only meets but exceeds expectations while exploring new frontiers in technology. We embrace challenges as opportunities for growth and innovation, and we continuously strive to inspire change across the digital landscape. With a passion for quality and a focus on future-forward solutions, we invite you to join us in creating a smarter, more connected world where every idea can become a reality."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
