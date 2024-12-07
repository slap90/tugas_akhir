import 'package:flutter/material.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true); // Loop animasi untuk membuat gelombang bergerak

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _navigateToHomePage();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _navigateToHomePage() {
    Timer(Duration(seconds: 3), () {
      Navigator.of(context).pushReplacementNamed('/main');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background color
          Container(
            color: Colors.white,
          ),
          // Decorative wave element at the top-left corner
          Positioned(
            top: -40,
            left: -40,
            child: AnimatedWave(
              animation: _animation,
              size: 150,
              color: Colors.lightBlue,
            ),
          ),
          // Decorative wave element at the bottom-right corner
          Positioned(
            bottom: -40,
            right: -40,
            child: AnimatedWave(
              animation: _animation,
              size: 150,
              color: Colors.lightBlue,
            ),
          ),
          // Main content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_app.png',
                  scale: 2,
                ),
                SizedBox(height: 20),
                Text(
                  'Desa Sidakarya',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedWave extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final Color color;

  const AnimatedWave({
    Key? key,
    required this.animation,
    required this.size,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 10 * animation.value),
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size * 0.6,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(size / 2),
            topRight: Radius.circular(size / 2),
            bottomLeft: Radius.circular(size / 4),
            bottomRight: Radius.circular(size / 4),
          ),
        ),
      ),
    );
  }
}
