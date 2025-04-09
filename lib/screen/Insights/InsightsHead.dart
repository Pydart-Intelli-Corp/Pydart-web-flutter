import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';

class InsightsHead extends StatefulWidget {
  const InsightsHead({super.key});

  @override
  State<InsightsHead> createState() => _InsightsHeadState();
}

class _InsightsHeadState extends State<InsightsHead> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color.fromARGB(0, 255, 255, 255),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: border),
      ),
      margin: blockMargin,
      padding: blockPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Heading and logo at the top
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                SizedBox(width: 100),
                Text(
                  "INSIGHTS",
                  style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 255, 255, 255)),
                ),
              ],
            ),
          ),
          SizedBox(height: 10,),
          Divider(
            color: const Color.fromARGB(93, 255, 255, 255),
            thickness: 2,
            height: 1,
            indent: 100,   // Adjust this value as needed
            endIndent: 100, // Adjust this value as needed
          ),
          // Description below
          Padding(
            padding: const EdgeInsets.all(16),
            child: RichText(
              textAlign: TextAlign.justify,
              text: const TextSpan(
                style: bodyTextStyle,
                children: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
