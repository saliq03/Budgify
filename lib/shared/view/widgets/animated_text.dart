import 'package:flutter/material.dart';

class AnimatedText extends StatefulWidget {
  final String text;
  final TextStyle style;
  final double oldFontSize;
  final double newFontSize;

  const AnimatedText({super.key, required this.text, required this.style, required this.oldFontSize, required this.newFontSize});

  @override
  State<AnimatedText> createState() => _AnimatedTextState();
}

class _AnimatedTextState extends State<AnimatedText> {
  double _fontSize = 22;

  @override
  void didUpdateWidget(covariant AnimatedText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      setState(() => _fontSize = widget.oldFontSize);
      Future.delayed(Duration(milliseconds: 500), () {
        if (mounted) setState(() => _fontSize = widget.newFontSize);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedDefaultTextStyle(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      style: widget.style.copyWith(fontSize: _fontSize), // Change font size dynamically
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Text(widget.text,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        ),
      ),
    );
  }
}