import 'package:fils/core/styles/themes.dart';
import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress({super.key, this.color});
  final Color? color;
  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(color: primaryColor,);
  }
}