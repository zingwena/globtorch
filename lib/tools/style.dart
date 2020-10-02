import 'package:flutter/material.dart';

class Style {
  static final baseTextStyle = const TextStyle(fontFamily: 'Poppins');
  static final smallTextStyle = commonTextStyle.copyWith(
    fontSize: 9.0,
  );
  static final commonTextStyle = baseTextStyle.copyWith(
      color: const Color(0xfffafafa),
      fontSize: 20.0,
      fontWeight: FontWeight.bold);
  static final titleTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 25.0, fontWeight: FontWeight.w700);
  static final appBarTextStyle = baseTextStyle.copyWith(
      color: Color.fromARGB(12, 12, 12, 12),
      fontSize: 25.0,
      fontWeight: FontWeight.w800);
  static final headerTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w400);
  static final topicTextStyle = baseTextStyle.copyWith(
      color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.w400);
}
