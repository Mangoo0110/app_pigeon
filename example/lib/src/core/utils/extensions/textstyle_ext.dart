import 'package:flutter/material.dart';

extension TextstyleExt on TextStyle {

  TextStyle get w100 => copyWith(fontWeight: FontWeight.w100);
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get w900 => copyWith(fontWeight: FontWeight.w900);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  
  TextStyle get regular => copyWith(fontSize: 16);
  TextStyle get chatMessageSize => copyWith(fontSize: 14);
  TextStyle get regularX => copyWith(fontSize: 18);
  TextStyle get h1 => copyWith(fontSize: 96);
  TextStyle get h2 => copyWith(fontSize: 60);
  TextStyle get h3 => copyWith(fontSize: 48);
  TextStyle get h4 => copyWith(fontSize: 34);
  TextStyle get h5 => copyWith(fontSize: 24);
  TextStyle get h6 => copyWith(fontSize: 20);
  TextStyle get small => copyWith(fontSize: 12);
  TextStyle get extraSmall => copyWith(fontSize: 8);
}