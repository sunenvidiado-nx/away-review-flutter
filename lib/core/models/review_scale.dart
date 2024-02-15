import 'package:flutter/material.dart';

abstract class ReviewScale {
  static const one = '😡';
  static const two = '😠';
  static const three = '🙁';
  static const four = '😐';
  static const five = '🙂';

  static String getEmojiByRating(num rating) {
    if (rating > 4) {
      return one;
    } else if (rating > 3) {
      return two;
    } else if (rating > 2) {
      return three;
    } else if (rating > 1) {
      return four;
    } else {
      return five;
    }
  }

  static const oneColor = Colors.red;
  static const twoColor = Colors.orange;
  static const threeColor = Colors.amber;
  static const fourColor = Colors.lime;
  static const fiveColor = Colors.lightGreen;

  static Color getColorByRating(
    num rating, {
    int weight = 500,
  }) {
    if (rating > 4) {
      return oneColor[weight]!;
    } else if (rating > 3) {
      return twoColor[weight]!;
    } else if (rating > 2) {
      return threeColor[weight]!;
    } else if (rating > 1) {
      return fourColor[weight]!;
    } else {
      return fiveColor[weight]!;
    }
  }
}
