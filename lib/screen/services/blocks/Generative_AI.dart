import 'package:flutter/material.dart';
import 'package:flutter_website/core/extensions/color_extensions.dart';
import 'package:flutter_website/widgets/Forms/enquiry_Page.dart';

import 'package:flutter_website/widgets/buttons/gradient_button.dart';
import 'package:url_launcher/url_launcher.dart';

class AIBlock extends StatefulWidget {
  const AIBlock({super.key});

  @override
  State<AIBlock> createState() => _AIBlockState();
}

class _AIBlockState extends State<AIBlock> {
  final List<Map<String, dynamic>> services = [
    {
      'title': 'Machine Learning Models',
      'icon': Icons.memory,
      'content': '''Develop robust ML models:
- Data preprocessing
- Model training
- Hyperparameter tuning
- Scalable deployment
- Continuous monitoring''',
      'color': Colors.blueAccent,
    },
    {
      'title': 'Chatbot Solutions',
      'icon': Icons.chat,
      'content': '''Intelligent conversation:
- Natural Language Processing
- Multi-platform integration
- Context-aware responses
- Self-learning algorithms
- Seamless user experience''',
      'color': Colors.greenAccent,
    },
    {
      'title': 'Predictive Analytics',
      'icon': Icons.insights,
      'content': '''Data-driven insights:
- Trend analysis
- Real-time predictions
- Data visualization
- Business intelligence
- Custom analytics solutions''',
      'color': Colors.orangeAccent,
    },
    {
      'title': 'Generative AI Solutions',
      'icon': Icons.auto_awesome,
      'content': '''Creative content generation:
- Image synthesis
- Text generation
- Music and video creation
- Code assistance
- Personalized content creation''',
      'color': Colors.purpleAccent,
    },
    {
      'title': 'Robotics & Automation',
      'icon': Icons.precision_manufacturing,
      'content': '''Innovative robotics solutions:
- Automated manufacturing
- IoT integration
- Process automation
- Real-time control systems
- Smart robotics''',
      'color': Colors.redAccent,
    },
    {
      'title': 'AI Integration Services',
      'icon': Icons.integration_instructions,
      'content': '''Seamless integration:
- API development
- Software embedding
- Website & mobile app integration
- Cross-platform support
- Scalable architecture''',
      'color': Colors.tealAccent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        top: isMobile ? 40 : 60,
        bottom: isMobile ? 40 : 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.black.withOpacity(0.9),
            const Color.fromARGB(255, 10, 5, 29).withOpacity(0.7),
          ],
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.deepPurple.withOpacity(0.3),
              blurRadius: 30,
              spreadRadius: 5)
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 20 : 30,
                vertical: isMobile ? 40 : 60,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Next-Gen AI Solutions",
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
                        const SizedBox(height: 20),
                        Text(
                          "Transform ideas into intelligent solutions with our full-cycle AI development process. From concept to deployment - we handle it all.",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white70,
                            fontSize: isMobile ? 15 : 18,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Service Cards
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final gridDelegate = SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 1 : isTablet ? 2 : 3,
                          crossAxisSpacing: isMobile ? 15 : 25,
                          mainAxisSpacing: isMobile ? 15 : 25,
                          childAspectRatio: isMobile ? 1.1 : 0.9,
                        );
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: gridDelegate,
                          itemCount: services.length,
                          itemBuilder: (context, index) =>
                              _buildServiceCard(services[index], isMobile: isMobile),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 50),
                  // AI Tech Stack Section
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: isMobile ? 10 : 20,
                    ),
                    padding: EdgeInsets.all(isMobile ? 15 : 25),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(0),
                      border: Border.all(
                        color: Colors.deepPurple.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Our AI Tech Stack",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: isMobile ? 24 : 28,
                          ),
                        ),
                        SizedBox(height: isMobile ? 15 : 25),
                        Text(
                          "We use modern tools to build intelligent solutions:",
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white70,
                            fontSize: isMobile ? 14 : 16,
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: isMobile ? 20 : 30),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: isMobile ? 2 : 4,
                            crossAxisSpacing: isMobile ? 12 : 20,
                            mainAxisSpacing: isMobile ? 12 : 20,
                            childAspectRatio: isMobile ? 2.2 : 3,
                          ),
                          itemCount: 8,
                          itemBuilder: (context, index) => _buildTechItem(
                            [
                              "TensorFlow",
                              "PyTorch",
                              "scikit-learn",
                              "Keras",
                              "OpenAI GPT",
                              "Hugging Face",
                              "NumPy",
                              "Pandas"
                            ][index],
                            [
                              "assets/logos/tensorflow.png",
                              "assets/logos/pytorch.png",
                              "assets/logos/scikit-learn.png",
                              "assets/logos/keras.png",
                              "assets/logos/open-ai.png",
                              "assets/logos/huggingface.png",
                              "assets/logos/numpy.png",
                              "assets/logos/pandas.png"
                            ][index],
                            isMobile,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 50),
                  // Call to Action Button
                  Center(
                    child: PrimaryGradientButton(
                      onPressed: () => _showDetailsPopup(context, "AI Services"),
                      text: "Start Your AI Journey →",
                      padding: isMobile
                          ? const EdgeInsets.symmetric(horizontal: 24, vertical: 14)
                          : const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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

  Widget _buildServiceCard(Map<String, dynamic> service, {required bool isMobile}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: isMobile ? 300 : null,
        padding: EdgeInsets.all(isMobile ? 15 : 25),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              service['color'].withOpacity(0.2),
              service['color'].withOpacity(0.05),
            ],
          ),
          border: Border.all(
            color: service['color'].withOpacity(0.2),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: service['color'].withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 2,
            )
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                service['icon'],
                color: service['color'].withOpacity(0.5),
              ),
            ),
            SizedBox(height: isMobile ? 15 : 20),
            Text(
              service['title'],
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Colors.white,
                fontSize: isMobile ? 20 : 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 15),
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white70,
                  fontSize: isMobile ? 14 : 16,
                  height: isMobile ? 1.4 : 1.8,
                ),
                children: _processContent(service['content'], isMobile: isMobile),
              ),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }

  List<TextSpan> _processContent(String content, {required bool isMobile}) {
    List<TextSpan> spans = [];
    final lines = content.split('\n');
    for (var line in lines) {
      if (line.startsWith('-')) {
        spans.add(TextSpan(
          text: '▹ ',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.blueAccent,
            fontSize: isMobile ? 16 : 18,
          ),
        ));
        spans.add(TextSpan(
          text: line.replaceFirst('-', '').trim() + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white70,
            fontSize: isMobile ? 14 : 16,
          ),
        ));
      } else {
        spans.add(TextSpan(
          text: line + '\n',
          style: TextStyle(
            fontFamily: "Montserrat",
            color: Colors.white,
            fontSize: isMobile ? 16 : 18,
            fontWeight: FontWeight.w500,
            height: 1.8,
          ),
        ));
      }
    }
    return spans;
  }

  Widget _buildTechItem(String name, String iconPath, bool isMobile) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(isMobile ? 10 : 12),
            child: Image.asset(
              iconPath,
              width: isMobile ? 28 : 34,
              height: isMobile ? 28 : 34,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: isMobile ? 10 : 15),
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Colors.white,
                  fontSize: isMobile ? 14 : 16,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
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
