import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class TextClickWidget extends StatelessWidget {
  final  String text;
  final  double size;
  final  Color color;
  final  TextDecoration decoration;
  final  Color decorationColor;
  final  int maxLines;
  final  FontWeight weight;
  final  void Function() onPress;


  const TextClickWidget({super.key, required this.text, required this.size, required this.color, required this.decoration, required this.decorationColor, required this.maxLines, required this.weight,required this.onPress});

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: onPress,
        child: Text(text,maxLines: maxLines,overflow: TextOverflow.ellipsis, style: GoogleFonts.elMessiri(fontWeight:weight,fontSize: size,color: color,decoration: decoration,decorationColor: decorationColor, ),)) ;
  }
}
