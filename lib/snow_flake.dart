import 'dart:math';

import 'package:flutter/material.dart';

class SnowFlake extends StatefulWidget {
  const SnowFlake({super.key});

  @override
  State<SnowFlake> createState() => _SnowFlakeState();
}

class _SnowFlakeState extends State<SnowFlake>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Snowflake> _snowflaks;

  double n = 0;

  @override
  void initState() {
    changeNTimeSnowFlake(n.toInt());

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeNTimeSnowFlake(int n) {
    _snowflaks = List.generate(
      n,
      (index) => Snowflake(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: CustomPaint(
                isComplex: true,
                painter: SnowPainter(_snowflaks, _controller),
              ),
            ),
            Slider(
              min: 0,
              max: 1000,
              value: n,
              onChanged: (value) {
                n = value;
                changeNTimeSnowFlake(n.toInt());
                setState(() {});
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SnowPainter extends CustomPainter {
  List<Snowflake> snowflakes;

  final Animation<double> falling;

  SnowPainter(this.snowflakes, this.falling) : super(repaint: falling);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;

    for (var snowflake in snowflakes) {
      snowflake.update();
      canvas.drawCircle(
          Offset(snowflake.x, snowflake.y), snowflake.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class Snowflake {
  double x, y, radius, speed;
  static final Random _random = Random();

  Snowflake()
      : x = _random.nextDouble() * 500,
        y = _random.nextDouble() * 500,
        radius = _random.nextDouble() * 2 + 1,
        speed = _random.nextDouble() * 2;

  void update() {
    y += speed;
    if (y > 800) {
      y = 0;
      x = _random.nextDouble() * 400;
    }
  }
}
