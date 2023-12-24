import 'package:date_time_picker/picker/brn_text_style.dart';
import 'package:flutter/material.dart';

class BrnPickerConfig {
  /// 背景颜色
  static Color backgroundColor = Colors.white;

  /// picker弹窗默认高度
  static double pickerHeight = 240.0;

  /// 标题高度
  static double titleHeight = 48.0;

  /// 列表项 高度
  static double itemHeight = 48.0;

  /// 圆角
  static double cornerRadius = 8.0;

  /// 分割线颜色
  static Color dividerColor = const Color(0xFFF0F0F0);

  /// 字体颜色
  static Color colorTextHint = const Color(0xFFCCCCCC);

  /// 主题色
  static Color colorPrimary = const Color(0xFF0984F9);

  /// 默认色
  static Color colorTextBase = const Color(0xFF222222);

  /// 副标题字体
  static double fontSizeSubHead = 16.0;

  /// 标题字体
  static double fontSizeHead = 18.0;

  /// 选中图标
  static Widget checked = const Icon(Icons.check_circle_outline, color: Colors.blue);

  /// 未选择图标
  static Widget checkedUn = Icon(Icons.radio_button_unchecked, color: dividerColor);

  /// item文字style
  static BrnTextStyle itemTextStyle = BrnTextStyle(
    color: colorTextBase,
    fontSize: fontSizeHead,
  );

  /// item文字选中style
  static BrnTextStyle itemTextSelectedStyle = BrnTextStyle(
    color: colorPrimary,
    fontSize: fontSizeHead,
    fontWeight: FontWeight.w600,
  );

  /// 标题文字style
  static BrnTextStyle titleTextStyle = BrnTextStyle(
    color: colorTextBase,
    fontSize: fontSizeSubHead,
  );

  /// 取消文字style
  static BrnTextStyle cancelTextStyle = BrnTextStyle(
    color: colorTextBase,
    fontSize: fontSizeSubHead,
  );

  /// 确认文字style
  static BrnTextStyle confirmTextStyle = BrnTextStyle(
    color: colorPrimary,
    fontSize: fontSizeSubHead,
  );
}
