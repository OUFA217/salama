import 'package:flutter/material.dart';

abstract class SizeHandler {
  static double getHegiht(context) {
    return MediaQuery.of(context!).size.height;
  }

  static double getWidth(context) {
    return MediaQuery.of(context!).size.width;
  }
}
