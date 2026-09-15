import 'package:flutter/material.dart';

class LineWidget extends StatelessWidget {
  final bool isVertical;
  final double size;
  final Color color;
  final double thick;
  const LineWidget({super.key, required this.isVertical, required this.size, required this.color, required this.thick});

  @override
  Widget build(BuildContext context) {
    return isVertical? SizedBox(height: size,
      width: 5,
      child: VerticalDivider(
        endIndent: 0,
      indent: 0,

      width: size,
        color: color,
        thickness: thick,


      ),
    ):SizedBox(
      width: size,
      height: 5,
      child: Divider(
        endIndent: 0,
        indent: 0,
        height: size,
        color: color,
        thickness: thick,
      ),
    );
  }
}
