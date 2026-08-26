import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';


class TextNormalWidget extends StatelessWidget {
  final  String text;
  final  double size;
  final  Color color;
  final  TextDecoration decoration;
  final  Color decorationColor;
  final  int maxLines;
  final  FontWeight weight;


  const TextNormalWidget({super.key, required this.text, required this.size, required this.color, required this.decoration, required this.decorationColor, required this.maxLines, required this.weight});

  @override
  Widget build(BuildContext context) {
    return Text(text,maxLines: maxLines,overflow: TextOverflow.ellipsis, style: GoogleFonts.elMessiri(fontWeight:weight,fontSize: size,color: color,decoration: decoration,decorationColor: decorationColor, ),) ;
  }
}
