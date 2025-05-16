import 'package:flutter/material.dart';
import 'package:pydart/components/icons.dart';
import 'package:pydart/components/spacing.dart';
import 'package:pydart/components/typography.dart';
import 'package:pydart/components/colors.dart';

class ServicesHead extends StatefulWidget {
  const ServicesHead({super.key});

  @override
  State<ServicesHead> createState() => _ServicesHeadState();
}

class _ServicesHeadState extends State<ServicesHead> {
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
                  "OUR SERVICES",
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
