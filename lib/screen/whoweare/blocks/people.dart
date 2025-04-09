import 'package:flutter/material.dart';
import 'package:flutter_website/components/icons.dart';
import 'package:flutter_website/components/spacing.dart';
import 'package:flutter_website/components/typography.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

void _showEmailDialog(BuildContext context) {
  final email = 'info.pydart@gmail.com';

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.black.withOpacity(0.9),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
          side: BorderSide(color: AppColors.pydart.withOpacity(0.3), width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.group, color: AppColors.pydart, size: 28),
                  const SizedBox(width: 12),
                  Text(
                    "Leadership Contact",
                    style: TextStyle(
                      fontFamily: "Montserrat",
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                "For executive inquiries, please contact:",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => launchUrl(Uri.parse('mailto:$email')),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.pydart.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        email,
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: AppColors.pydart,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Icon(Icons.arrow_outward,
                          color: AppColors.pydart, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white70,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      "Close",
                      style: TextStyle(fontFamily: "Montserrat"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => launchUrl(Uri.parse('mailto:$email')),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.pydart,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 14),
                    ),
                    child: Text(
                      "Send Email",
                      style: TextStyle(fontFamily: "Montserrat"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

class PeopleBlock extends StatefulWidget {
  const PeopleBlock({super.key});

  @override
  State<PeopleBlock> createState() => _PeopleBlockState();
}

class _PeopleBlockState extends State<PeopleBlock> {
  final List<Map<String, String>> teamMembers = [
    {
      'name': 'Tishnu Thankappan',
      'role': 'Founder / CEO',
      'bio':
          'With a strong background in research and development in embedded systems, as well as expertise in Flutter and .NET',
      'image': 'assets/images/team/tishnu.jpg'
    },
    {
      'name': 'Adwaith Raj PR',
      'role': 'Co-Founder / CTO',
      'bio':
          'Expertise in cloud technologies and a keen understanding of the latest industry trends',
      'image': 'assets/images/team/adwaith.jpg'
    },
    {
      'name': 'Akshara Ravi',
      'role': 'Co-Founder / CMO',
      'bio':
          'Transforming brands with agile digital strategies and data-driven innovation.',
      'image': 'assets/images/team/akshara.jpg'
    }
  ];

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return Container(
      width: double.infinity,
      margin: blockMargin.copyWith(top: 40, bottom: 40),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 0,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            // Enhanced background with gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/others/team.jpg'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.8),
                      BlendMode.darken,
                    ),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primary.withOpacity(0.1),
                      AppColors.secondary.withOpacity(0.3),
                    ],
                  ),
                ),
              ),
            ),

            // Content container
            Container(
              padding: blockPadding(context).copyWith(top: 40, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildMaterialIconCircle("assets/icons/team.png", 68),
                        const SizedBox(width: 24),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Exceptional Minds",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: Colors.white,
                                  fontSize: isMobile ? 28 : 40,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                  shadows: [
                                    Shadow(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      blurRadius: 10,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Driving Innovation Through Expertise",
                                style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: AppColors.whitegrey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Core Values Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Wrap(
                          spacing: 24,
                          runSpacing: 24,
                          children: [
                            _buildValueCard(
                              icon: Icons.psychology_alt,
                              title: "Deep Expertise",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: AppColors.pydart),
                              content:
                                  "Advanced degrees & 5+ years in Software , Hardware and Artificial Intelligence.",
                            ),
                            _buildValueCard(
                              icon: Icons.diversity_3,
                              title: "Collaborative Culture",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: AppColors.pydart),
                              content:
                                  "Cross-functional teams solving complex problems through synergy",
                            ),
                            _buildValueCard(
                              icon: Icons.auto_awesome_mosaic,
                              title: "Innovation DNA",
                              style: TextStyle(
                                  fontFamily: "Montserrat",
                                  color: AppColors.pydart),
                              content:
                                  "Innovative products under wraps—with a wink. Launch soon.",
                            ),
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 50),

                  // Team Members Grid
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            MediaQuery.of(context).size.width > 900 ? 3 : 1,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: teamMembers.length,
                      itemBuilder: (context, index) {
                        return _buildTeamMemberCard(teamMembers[index]);
                      },
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Metrics Section
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: IntrinsicHeight(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        padding: const EdgeInsets.all(50),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(0),
                          border:
                              Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: isMobile
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildMetric("5+", "Years Experience"),
                                  const SizedBox(height: 16),
                                  _buildMetric("50+", "Projects Delivered"),
                                  const SizedBox(height: 16),
                                  _buildMetric("98%", "Client Satisfaction"),
                                ],
                              )
                            : IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    _buildMetric("5+", "Years Experience"),
                                    VerticalDivider(
                                        color: Colors.white.withOpacity(0.2)),
                                    _buildMetric("50+", "Projects Delivered"),
                                    VerticalDivider(
                                        color: Colors.white.withOpacity(0.2)),
                                    _buildMetric("98%", "Client Satisfaction"),
                                  ],
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // CTA Section
                  Center(
                    child: PrimaryGradientButton(
                      onPressed: () {
                        _showEmailDialog(context);
                      },
                      text: "Meet Our Leadership Team →",
                      padding: isMobile
                          ? const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 14)
                          : const EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueCard(
      {required IconData icon,
      required String title,
      required String content,
      required TextStyle style}) {
    return Container(
      width: 300,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(0),
        border: Border.all(color: Colors.white.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 32),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: AppColors.pydart,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.white70,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMemberCard(Map<String, String> member) {
    return Container(
      height: 100, // Smaller fixed height
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color:
            const Color.fromARGB(60, 0, 0, 0), // Set background color to black
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40, // Small circular image
            backgroundImage: AssetImage(member['image']!),
          ),
          const SizedBox(height: 8),
          Text(
            member['name']!,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            member['role']!,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: AppColors.pydart,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            member['bio']!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Colors.white70,
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String value, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white,
            fontSize: 42,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white.withOpacity(0.8),
            fontSize: 16,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
