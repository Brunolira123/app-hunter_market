import 'package:flutter/material.dart';

class BackgroundImage extends StatelessWidget {
  final Widget child;

  const BackgroundImage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/fundo_login.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
        child,
      ],
    );
  }
}
