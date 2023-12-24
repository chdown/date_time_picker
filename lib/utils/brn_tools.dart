import 'package:flutter/material.dart';

/// 图片加载工具类
class BrunoTools {
  const BrunoTools._();

  /// 根据 TextStyle 计算 text 宽度。
  static Size textSize(String text, TextStyle style) {
    if (isEmpty(text)) return Size(0, 0);
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size;
  }

  /// 判空
  static bool isEmpty(Object? obj) {
    if (obj is String) {
      return obj.isEmpty;
    }
    if (obj is Iterable) {
      return obj.isEmpty;
    }
    if (obj is Map) {
      return obj.isEmpty;
    }
    return obj == null;
  }
}
