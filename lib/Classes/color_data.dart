import 'package:flutter/material.dart';

class Colordata {
  final Color color;
  final String colorCode;
  final String name;

  Colordata({required this.name, required this.color, required this.colorCode});

  static List<Colordata> availableColors = [
    Colordata(
        color: const Color.fromRGBO(240, 73, 79, 1),
        colorCode: 'R',
        name: 'red'),
    Colordata(
        color: const Color.fromRGBO(76, 179, 212, 1),
        colorCode: 'B',
        name: 'blue'),
    Colordata(
        color: const Color.fromRGBO(211, 183, 120, 1),
        colorCode: 'Y',
        name: 'yellow'),
    Colordata(
        color: const Color.fromRGBO(37, 68, 65, 1),
        colorCode: 'G',
        name: 'green'),
  ];
}
