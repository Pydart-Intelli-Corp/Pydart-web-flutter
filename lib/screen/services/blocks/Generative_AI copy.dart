import 'package:flutter/material.dart';
import 'package:flutter_website/components/colors.dart';
import 'package:flutter_website/components/typography.dart';

class GenerativeAIBlock extends StatelessWidget {
  const GenerativeAIBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topLeft,
          radius: 1.5,
          colors: [
            Colors.deepPurple.shade900,
            Colors.black,
          ],
        ),
      ),
      child: Column(
        children: [
          _buildCyberHeader(context),
          _buildNeonGridSection(),
          _buildFloatingFeatures(),
          _buildTechSphere(),
          _buildCTASection(),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildCyberHeader(BuildContext context) {
    return SizedBox(
      height: 600,
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.2,
              child: Image.asset(
                'assets/images/ai.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ShaderMask(
                  shaderCallback: (bounds) => LinearGradient(
                    colors: [Colors.cyan, Colors.pinkAccent],
                    stops: [0.3, 0.7],
                  ).createShader(bounds),
                  child: Text(
                    'Next-Gen AI Solutions',
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  width: 200,
                  height: 4,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.pinkAccent, Colors.cyan],
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Container(
                  padding: EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: Colors.pinkAccent.withOpacity(0.3),
                      width: 2,
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.blueAccent.withOpacity(0.1),
                        Colors.purpleAccent.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Text(
                    'Transform your business with\nadaptive AI systems',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonGridSection() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color.fromARGB(0, 74, 20, 140).withOpacity(0.5),
            Colors.transparent,
          ],
        ),
      ),
      child: Column(
        children: [
          Wrap(
            spacing: 30,
            runSpacing: 30,
            alignment: WrapAlignment.center,
            children: [
              _buildNeonCard('Natural Language\nProcessing', Icons.chat),
              _buildNeonCard('Computer\nVision', Icons.remove_red_eye),
              _buildNeonCard('Predictive\nAnalytics', Icons.trending_up),
              _buildNeonCard('Generative\nModels', Icons.auto_awesome),
            ],
          ),
          SizedBox(height: 60),
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.pinkAccent.withOpacity(0.3),
                  Colors.transparent,
                ],
              ),
            ),
            child: Image.asset('assets/images/ai1.jpg'),
          ),
        ],
      ),
    );
  }

  Widget _buildNeonCard(String text, IconData icon) {
    return Container(
      width: 200,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.cyan.withOpacity(0.3),
          width: 2,
        ),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purpleAccent.withOpacity(0.1),
            Colors.blueAccent.withOpacity(0.1),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: Colors.pinkAccent),
          SizedBox(height: 20),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingFeatures() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Transform.rotate(
            angle: -0.1,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    Colors.purpleAccent.withOpacity(0.2),
                    Colors.blueAccent.withOpacity(0.2),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'AI Capabilities',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 40,
                    runSpacing: 40,
                    children: [
                      _buildFeatureTile('Real-time Processing', '⚡'),
                      _buildFeatureTile('Multi-modal AI', '🌐'),
                      _buildFeatureTile('Ethical Framework', '⚖️'),
                      _buildFeatureTile('Continuous Learning', '🔄'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 60),
          Transform.rotate(
            angle: 0.1,
            child: Container(
              padding: EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                gradient: LinearGradient(
                  colors: [
                    Colors.cyan.withOpacity(0.2),
                    Colors.pinkAccent.withOpacity(0.2),
                  ],
                ),
              ),
              child: Column(
                children: [
                  Text(
                    'Technical Edge',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 30),
                  Wrap(
                    spacing: 40,
                    runSpacing: 40,
                    children: [
                      _buildFeatureTile('Neural Architecture', '🧠'),
                      _buildFeatureTile('Quantum ML', '🌀'),
                      _buildFeatureTile('Edge AI', '📱'),
                      _buildFeatureTile('Federated Learning', '🔐'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureTile(String title, String emoji) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.05),
            Colors.white.withOpacity(0.02),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 40)),
          SizedBox(height: 10),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechSphere() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 80),
      child: Column(
        children: [
          Text(
            'Supported Technologies',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 40),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _buildTechBubble('TensorFlow'),
              _buildTechBubble('PyTorch'),
              _buildTechBubble('HuggingFace'),
              _buildTechBubble('Keras'),
              _buildTechBubble('ONNX'),
              _buildTechBubble('OpenVINO'),
              _buildTechBubble('CUDA'),
              _buildTechBubble('CoreML'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechBubble(String tech) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.withOpacity(0.3),
            Colors.blueAccent.withOpacity(0.3),
          ],
        ),
      ),
      child: Text(
        tech,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      padding: EdgeInsets.all(40),
      margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        gradient: LinearGradient(
          colors: [
            Colors.pinkAccent.withOpacity(0.2),
            Colors.cyan.withOpacity(0.2),
          ],
        ),
      ),
      child: Column(
        children: [
          Text(
            'Ready for AI Transformation?',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Start your journey with our expert AI team',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
          SizedBox(height: 40),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              backgroundColor: Colors.pinkAccent,
            ),
            onPressed: () {},
            child: Text(
              'Schedule Consultation',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}