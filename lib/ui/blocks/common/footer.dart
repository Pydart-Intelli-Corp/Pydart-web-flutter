
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pydart/widgets/buttons/icon_hover_button.dart';


import 'package:pydart/api/config.dart';
import 'package:pydart/widgets/notifications/snackbar.dart';
import 'package:http/http.dart' as http;


import 'package:responsive_framework/responsive_framework.dart';
import 'package:url_launcher/url_launcher.dart';


class Footer extends StatelessWidget {

    final Color g1;
  final Color g2;
   Footer({super.key, required this.g1, required this.g2});
  final TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final bool isMobile =
        ResponsiveBreakpoints.of(context).smallerThan(DESKTOP);

    return Container(
      decoration:  BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            g1,
            g2,
          ],
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 20 : 30,
        vertical: 40,
      ),
      child: Column(
        children: [
          ResponsiveRowColumn(
            layout: isMobile
                ? ResponsiveRowColumnType.COLUMN
                : ResponsiveRowColumnType.ROW,
            columnSpacing: 30,
            rowSpacing: 30,
            rowMainAxisAlignment: MainAxisAlignment.spaceAround,
            columnMainAxisAlignment: MainAxisAlignment.start,
            children: [
              ResponsiveRowColumnItem(
                rowFit: FlexFit.tight,
                child: _buildServicesSection(),
              ),
              ResponsiveRowColumnItem(
                rowFit: FlexFit.tight,
                child: _buildCareerSection(context),
              ),
              ResponsiveRowColumnItem(
                rowFit: FlexFit.tight,
                child: _buildEcommerceSection(context),
              ),
              ResponsiveRowColumnItem(
                rowFit: FlexFit.tight,
                child: _buildContactSection(),
              ),
              ResponsiveRowColumnItem(child: _buildLogoSection()),
            ],
          ),
          SizedBox(
            height: 50,
          ),
          Text(
            '© 2025 Pydart Intelli Corp Pvt Ltd. All Rights Reserved',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  ResponsiveRowColumnItem _buildLogoSection() {
    return ResponsiveRowColumnItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: SizedBox(
  width: 200, // desired width
  height: 100, // desired height
 child: SvgPicture.asset(
  "assets/logos/pydart-logo.svg",
  semanticsLabel: 'Pydart Logo',
  fit: BoxFit.scaleDown,
  allowDrawingOutsideViewBox: true,
  color: null, // Ensures the original colors from the SVG are used.
),

),

          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Innovate. Integrate. Inspire.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "--------------- Follow us on ---------------",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconHoverButton(
                    iconPath: "assets/logos/github-logo.png",
                    onPressed: () => openUrl('https://github.com/Pydart-Intelli-Corp')),
                IconHoverButton(
                    iconPath: "assets/logos/linkedin.png",
                    onPressed: () => openUrl('https://www.linkedin.com/company/pydart-intelli-corp/')),
                IconHoverButton(
                    iconPath: "assets/logos/instagram.png",
                    onPressed: () => openUrl('https://www.instagram.com/pydart.india?igsh=MTVwMWhlMm9qNWRydw==')),
                // IconHoverButton(
                //     iconPath: "assets/logos/facebook.png",
                //     onPressed: () {}),
                // IconHoverButton(
                //     iconPath: "assets/logos/x.png",
                //     onPressed: (){}),
                // IconHoverButton(
                //     iconPath: "assets/logos/youtube.png",
                //     onPressed: (){}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  ResponsiveRowColumnItem _buildServicesSection() {
    return ResponsiveRowColumnItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Our Services"),
          _buildFooterLink("Website Development", Icons.code, () { openUrl("$domainurl/services");}),
          _buildFooterLink(
              "IOS & Android Development", Icons.mobile_friendly, () { openUrl("$domainurl/services");}),
          _buildFooterLink("Embedded System Development", Icons.cast_for_education_outlined, () { openUrl("$domainurl/services");}),
          _buildFooterLink("Cloud Solutions", Icons.cloud, () { openUrl("$domainurl/services");}),
          _buildFooterLink("IOT", Icons.broadcast_on_home_outlined, () { openUrl("$domainurl/services");}),
          _buildFooterLink("AI Integration", Icons.add_to_home_screen_sharp, () { openUrl("$domainurl/services");}),
        ],
      ),
    );
  }

  ResponsiveRowColumnItem _buildCareerSection(BuildContext context) {
    return ResponsiveRowColumnItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Careers"),
          _buildFooterLink("Current Openings", Icons.work_outline, () {
            openUrl("$domainurl/career"); // Navigate to CareerScreen
          }),
          _buildFooterLink("Internship Programs", Icons.school, () {
          CustomSnackbar.info(context, "Coming soon ");
          }),
          _buildFooterLink("Employee Benefits", Icons.card_giftcard, () {
            openUrl("$domainurl/career");
          }),
          _buildFooterLink("Tech Stack", Icons.memory, () {
          CustomSnackbar.info(context, "Coming soon ");
          }),
          const SizedBox(height: 30),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(181, 56, 134, 49),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
             openUrl("$domainurl/career");
            },
            child: const Text(
              "Join Our Team",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String text, IconData icon, VoidCallback onTap) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 8), // Increases hover width
      child: InkWell(
        onTap: onTap,
        hoverColor: const Color.fromARGB(45, 255, 255, 255),
        borderRadius: BorderRadius.circular(4),
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 6, horizontal: 12), // Extra padding for hover area
          child: Row(
            children: [
              Icon(icon, color: Colors.white70, size: 16), // Icon added here
              const SizedBox(width: 8), // Space between icon and text
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
Future<bool> sendEnquiryEmail({
  required String recipientEmail,
 
  required BuildContext context,
}) async {
  // Build the URI with query parameters
  final Uri uri = Uri.parse("$apiUrl/Email/EnquiryMail").replace(
    queryParameters: {
      'recipientEmail': recipientEmail,
      'recipientName': 'Sir/Madam',
      'mobile': 'NA',
      'selectedService': 'your interest in Pydart Intelli Corp ',
      'purpose': 'Interested in Pydart Intelli Corp',
    },
  );
 CustomSnackbar.info(context, "Please wait...");
  try {
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    final success = response.statusCode == 200;
    if (context.mounted) {
      success
          ? CustomSnackbar.success(context, "Your inquiry has been received successfully")
          : CustomSnackbar.error(context, "Submission failed. Please try again later.");
    }
    return success;
  } catch (e) {
    if (context.mounted) {
      CustomSnackbar.error(context, "Server error occurred. Please try again later.");
    }
    return false;
  }
}


  ResponsiveRowColumnItem _buildEcommerceSection(BuildContext context) {
    return ResponsiveRowColumnItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Our Store"),
          _buildFooterLink("Tech Gadgets", Icons.devices, () {
           CustomSnackbar.info(context, "Coming soon ");
          }),
          _buildFooterLink("Development Kits", Icons.build, () {
          CustomSnackbar.info(context, "Coming soon ");
          }),
          _buildFooterLink("Latest Product", Icons.support_agent, () {
          CustomSnackbar.info(context, "Coming soon ");
          }),
          const SizedBox(height: 15),
          const Text(
            "Subscribe to our newsletter:",
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 200,
            
            child: TextField(
                controller:emailController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
              
                hintText: "Enter your email",
                hintStyle: const TextStyle(color: Colors.white54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(25, 255, 255, 255),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Colors.white),
                  onPressed: () async{
                     await sendEnquiryEmail(
                                      recipientEmail: emailController.text,
                                  
                                      context: context,
                                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  ResponsiveRowColumnItem _buildContactSection() {
    return ResponsiveRowColumnItem(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle("Contact Us"),
          _buildFooterLink("info@pydart.in", Icons.email, () {
            openUrl("mailto:info@pydart.in");
          }),
          _buildFooterLink("+91 73567-65056", Icons.phone, () {
            openUrl("tel:+917356765036");
          }),
          _buildFooterLink("Palarivattom, Kochi", Icons.location_on, () {
            openUrl(
                "https://www.google.com/maps?q=10.001321532145445,76.30230229063729"); // Replace with desired coordinates
          }),
          _buildFooterLink("Mon-Fri: 9AM - 6PM", Icons.access_time, () {}),
          const SizedBox(height: 5),
          _buildSectionTitle("Investor Relations"),
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color.fromARGB(181, 255, 255, 255)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () { openUrl("mailto:founder@pydart.in");},
            child: const Text(
              "Investment Enquiry",
              style: TextStyle(color: Color.fromARGB(181, 255, 255, 255)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
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
