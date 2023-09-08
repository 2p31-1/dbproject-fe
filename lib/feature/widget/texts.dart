import 'dart:math';

import 'package:flutter/material.dart';

const bodyColor = Color(0xFFff2222);

class Heading extends StatelessWidget {
  final String text;

  const Heading(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: H1(text, softwrap: true,),
      ),
    );
  }
}

class BodyText extends StatelessWidget{
  const BodyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child:Padding(
        padding: const EdgeInsets.all(10),
        child: Text(
          text,
          softWrap: true,
        )
      ),
    );
  }


}

class H1 extends StatelessWidget {
  const H1(
    this.text, {
    Key? key,
    this.maxLines = 1,
    this.textAlign,
    this.overflow,
    this.color = bodyColor,
        this.softwrap,
  }) : super(key: key);

  final String text;
  final int maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final Color color;
  final bool? softwrap;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Text(
      text,
      style: TextStyle(
        fontSize: max(
            Theme.of(context).textTheme.titleLarge!.fontSize!, width * 0.04),
        fontWeight: FontWeight.bold,
        color: color,
      ),
      textAlign: textAlign,
      softWrap: softwrap,
    );
  }
}
