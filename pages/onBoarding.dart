import 'dart:math';

import 'package:berber_proje/pages/signup.dart';
import 'package:flutter/material.dart';

class onBoarding extends StatefulWidget {
  const onBoarding({super.key});

  @override
  State<onBoarding> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<onBoarding>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..repeat();

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Animasyonlu ışık efekti
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: Size(300, 300),
                      painter: LightPainter(_animation.value),
                    );
                  },
                ),
                // Berber fotoğrafı
                Image.asset(
                  "images/barber.png",
                  width: 200,
                  height: 200,
                ),
              ],
            ),
            SizedBox(
              height: 80.0,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => SignUp()));
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                decoration: BoxDecoration(
                    color: Color(0xFFdf711a),
                    borderRadius: BorderRadius.circular(30)),
                child: Text(
                  "Şık Bir Saç Kesimi Alın",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LightPainter extends CustomPainter {
  final double animationValue;

  LightPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 * (1 + animationValue * 0.3);

    // Renkli ışık efekti
    final colors = [
      Colors.red.withOpacity(0.8),
      Colors.orange.withOpacity(0.8),
      Colors.yellow.withOpacity(0.8),
      Colors.green.withOpacity(0.8),
      Colors.blue.withOpacity(0.8),
      Colors.indigo.withOpacity(0.8),
      Colors.purple.withOpacity(0.8),
    ];

    for (int i = 0; i < 8; i++) {
      final angle = i * 45.0 * (3.14 / 180);
      final start = Offset(
          center.dx + radius * cos(angle), center.dy + radius * sin(angle));
      final end = Offset(center.dx + radius * 1.5 * cos(angle),
          center.dy + radius * 1.5 * sin(angle));

      final paint = Paint()
        ..color = colors[i % colors.length]
        ..strokeWidth = 4.0
        ..strokeCap = StrokeCap.round; // Işınların köşeli olmasını sağlar

      canvas.drawLine(start, end, paint);
    }

    // Merkezdeki ışık efekti
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
