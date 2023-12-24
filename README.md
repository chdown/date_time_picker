## 说明

该组件移植于[贝壳的Bruno](https://bruno.ke.com/page/)，主要移独立出`Picker`系列组件，基于3.4.2，对源代码有所修改。

## 接入

Flutter 工程中 pubspec.yaml 文件里加入以下依赖：

```yaml
dependencies:
    date_time_picker:
      git:
        url: https://github.com/chdown/date_time_picker
```

## 使用

| 说明                                                                               |                                                              |
|----------------------------------------------------------------------------------| ------------------------------------------------------------ |
| [Bottom Picker]( /doc/BrnBottomPicker/BrnBottomPicker.md )                        | 支持高度的自定义（内容、头部），解决了 picker 中有输入框，键盘遮挡等问题 |
| [Date Picker](/doc/BrnDatePicker/BrnDatePicker.md )                               | 【单个】时间点的情况                                         |
| [DateRange Picker]( /doc/BrnDateRangePicker/BrnDateRangePicker.md )               | 时间范围选择的情况                                           |
| [MultiData Picker]( /doc/BrnMultiColumnPicker/BrnMultiColumnPicker.md )           | 单列或者多列数据选择的                                       |
| [MultiColumn Picker]( /doc/BrnMultiDataPicker/BrnMultiDataPicker.md )             | 底部的级联选择器                                             |
| [MultiSelect Picker]( /doc/BrnMultiSelectListPicker/BrnMultiSelectListPicker.md ) | 多选底部弹框 ，适用于从页面底部弹出，存在多选列表的情况      |

## 个性化配置

```dart
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
```
