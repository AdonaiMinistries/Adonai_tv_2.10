import 'package:flutter/material.dart';

class ResponsiveImage extends StatelessWidget {
  final String imagePath;

  const ResponsiveImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return Image.asset(
          imagePath,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
