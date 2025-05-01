import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ComingSoonScreen extends StatefulWidget {
  @override
  _ComingSoonScreenState createState() => _ComingSoonScreenState();
}

class _ComingSoonScreenState extends State<ComingSoonScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _shineController;
  late AnimationController _particleController;
  final DateTime _launchDate = DateTime(2025, 5, 29, 22, 0, 0);
  late Timer _timer;
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final List<Particle> _particles = [];
  Offset _cursorPosition = Offset.zero;
  int _score = 0;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    )..repeat(reverse: true);
    
    _shineController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    )..repeat();
    
    _particleController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
    )..repeat();
    
    _startTimer();
    _generateParticles();
  }

  void _generateParticles() {
    for (int i = 0; i < 50; i++) {
      _particles.add(Particle());
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) => setState(() {}));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _shineController.dispose();
    _particleController.dispose();
    _timer.cancel();
    _emailController.dispose();
    super.dispose();
  }

  Duration get _remainingTime => _launchDate.difference(DateTime.now());

  String _formatDuration(Duration duration) {
    return duration.isNegative
        ? '00:00:00:00'
        : '${duration.inDays.toString().padLeft(2, '0')} : '
            '${(duration.inHours % 24).toString().padLeft(2, '0')} : '
            '${(duration.inMinutes % 60).toString().padLeft(2, '0')} : '
            '${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  void _subscribe() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.white.withOpacity(0.9),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Color(0xFF00C853), size: 64),
                SizedBox(height: 20),
                Text('Thank You!', 
                     style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text('You\'ve been added to our exclusive launch list.',
                     textAlign: TextAlign.center,
                     style: TextStyle(fontSize: 16)),
              ],
            ),
          ),
        ),
      );
      _emailController.clear();
    }
  }

  void _updateCursorPosition(Offset position) {
    setState(() {
      _cursorPosition = position;
      _particles.forEach((particle) {
        final distance = (position - particle.position).distance;
        if (distance < 50) {
          particle.velocity += (particle.position - position) / distance * 0.1;
        }
      });
    });
  }

  void _collectStar(Offset position) {
    setState(() {
      _particles.removeWhere((particle) {
        final distance = (position - particle.position).distance;
        if (distance < 30) {
          _score++;
          return true;
        }
        return false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
            ),
          ),
          child: SafeArea(
            child: Stack(
              children: [
                // Floating Particles Background
                Positioned.fill(
                  child: MouseRegion(
                    onHover: (event) => _updateCursorPosition(event.position),
                    child: GestureDetector(
                      onTapDown: (details) => _collectStar(details.localPosition),
                      child: CustomPaint(
                        painter: ParticlePainter(
                          particles: _particles,
                          cursorPosition: _cursorPosition,
                          controller: _particleController,
                        ),
                      ),
                    ),
                  ),
                ),

                // Interactive Score Counter
                Positioned(
                  top: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 20),
                        SizedBox(width: 8),
                        Text('$_score', style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                        )),
                      ],
                    ),
                  ),
                ),

                // Main Content
                Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: 800),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated Logo with Shine Effect
                          AnimatedBuilder(
                            animation: _shineController,
                            builder: (context, child) {
                              final gradient = LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.white.withOpacity(0.3),
                                  Colors.transparent,
                                ],
                                stops: [
                                  (_shineController.value - 0.2).clamp(0, 1),
                                  _shineController.value,
                                  (_shineController.value + 0.2).clamp(0, 1),
                                ],
                              );
                              
                              return ShaderMask(
                                shaderCallback: (rect) => gradient.createShader(rect),
                                blendMode: BlendMode.modulate,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              'assets/logos/pydart-GreenWhite.png', // Replace with your logo path
                              width: isSmallScreen ? 180 : 240,
                              height: isSmallScreen ? 180 : 240,
                            ),
                          ),

                          SizedBox(height: 30),
                          // Countdown Timer
                          Container(
                            padding: EdgeInsets.symmetric(vertical: 24, horizontal: 32),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.1)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 20,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.timer, 
                                         color: Colors.white70, 
                                         size: isSmallScreen ? 28 : 32),
                                    SizedBox(width: 12),
                                    Text('LAUNCH COUNTDOWN',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isSmallScreen ? 18 : 22,
                                          fontWeight: FontWeight.w600,
                                        )),
                                  ],
                                ),
                                SizedBox(height: 20),
                                Text(_formatDuration(_remainingTime),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 32 : 48,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF00E676),
                                      fontFamily: 'Digital',
                                      letterSpacing: 4,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          blurRadius: 10,
                                          offset: Offset(2, 2),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          // Email Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Text('Get notified when we launch',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: isSmallScreen ? 16 : 18,
                                    )),
                                SizedBox(height: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.15),
                                        Colors.white.withOpacity(0.05)
                                      ]),
                                  ),
                                  child: TextFormField(
                                    controller: _emailController,
                                    style: TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      hintText: 'Enter your email',
                                      hintStyle: TextStyle(color: Colors.white54),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 24, vertical: 18),
                                      suffixIcon: Container(
                                        margin: EdgeInsets.all(6),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF00B4DB),
                                              Color(0xFF0083B0)
                                            ]),
                                        ),
                                        child: IconButton(
                                          icon: Icon(Icons.arrow_forward,
                                              color: Colors.white),
                                          onPressed: _subscribe,
                                        ),
                                      ),
                                    ),
                                    validator: (value) => value!.contains('@')
                                        ? null
                                        : 'Please enter a valid email',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          // Social Buttons
                          Wrap(
                            spacing: 20,
                            runSpacing: 15,
                            alignment: WrapAlignment.center,
                            children: [
                              _SocialButton(
                                icon: FontAwesomeIcons.discord,
                                color: Color(0xFF7289DA),
                                onPressed: () {},
                              ),
                              _SocialButton(
                                icon: FontAwesomeIcons.twitter,
                                color: Color(0xFF1DA1F2),
                                onPressed: () {},
                              ),
                              _SocialButton(
                                icon: FontAwesomeIcons.linkedin,
                                color: Color(0xFF0077B5),
                                onPressed: () {},
                              ),
                              _SocialButton(
                                icon: FontAwesomeIcons.github,
                                color: Colors.white,
                                onPressed: () {},
                              ),
                            ],
                          ),
                          SizedBox(height: 30),
                          // Footer
                          Text('© 2025 Pydart Intelli Corp Pvt Ltd. All Rights Reserved',
                              style: TextStyle(
                                color: Colors.white54,
                                fontSize: 12,
                                letterSpacing: 1,
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Particle {
  Offset position = Offset(
    Random().nextDouble() * 1000,
    Random().nextDouble() * 1000,
  );
  Offset velocity = Offset(
    (Random().nextDouble() - 0.5) * 0.5,
    (Random().nextDouble() - 0.5) * 0.5,
  );
  double size = Random().nextDouble() * 3 + 2;
  Color color = Colors.accents[Random().nextInt(Colors.accents.length)]
      .withOpacity(Random().nextDouble() * 0.5 + 0.2);
}

class ParticlePainter extends CustomPainter {
  final List<Particle> particles;
  final Offset cursorPosition;
  final Animation<double> controller;

  ParticlePainter({
    required this.particles,
    required this.cursorPosition,
    required this.controller,
  }) : super(repaint: controller);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      particle.position += particle.velocity;
      if (particle.position.dx < 0 || particle.position.dx > size.width) {
        particle.velocity = Offset(-particle.velocity.dx, particle.velocity.dy);
      }
      if (particle.position.dy < 0 || particle.position.dy > size.height) {
        particle.velocity = Offset(particle.velocity.dx, -particle.velocity.dy);
      }

      paint.color = particle.color;
      canvas.drawCircle(particle.position, particle.size, paint);
    }

    // Draw cursor effect
    paint.color = Colors.white.withOpacity(0.1);
    canvas.drawCircle(cursorPosition, 30, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
class _SocialButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _SocialButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  _SocialButtonState createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.easeInOut)
    );
    _scaleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => _scaleController.forward(),
      onExit: (_) => _scaleController.reverse(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: widget.color.withOpacity(0.3),
                blurRadius: 8,
                spreadRadius: 2,
              )
            ],
          ),
          child: IconButton(
            icon: FaIcon(widget.icon, color: widget.color),
            iconSize: 24,
            onPressed: widget.onPressed,
            hoverColor: widget.color.withOpacity(0.1),
            splashColor: widget.color.withOpacity(0.2),
          ),
        ),
      ),
    );
  }


}