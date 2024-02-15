import 'package:flutter/material.dart';

abstract class ReviewScale {
  static const one = '😡';
  static const two = '😠';
  static const three = '🙁';
  static const four = '😐';
  static const five = '🙂';

  static String getEmojiByRating(num rating) {
    return switch (rating) {
      1 => one,
      2 => two,
      3 => three,
      4 => four,
      5 => five,
      _ => throw Exception('Invalid rating: $rating'),
    };
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
    return switch (rating) {
      1 => oneColor[weight]!,
      2 => twoColor[weight]!,
      3 => threeColor[weight]!,
      4 => fourColor[weight]!,
      5 => fiveColor[weight]!,
      _ => throw Exception('Invalid rating: $rating'),
    };
  }
}
