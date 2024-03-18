import 'package:date_time_picker/export.dart';
import 'package:flutter/material.dart';

/// @author : ch
/// @date 2024-03-07 13:55:05
/// @description 选择工具类
///
class PickUtils {
  /// 时间范围选择
  static showTimeRange(
    BuildContext context,
    String? initialStartDateTimeStr,
    String? initialEndDateTimeStr,
    Function(String startTime, String endTime) onConfirm, {
    String dateFormat = 'HH:mm',
    String? resultFormat,
  }) {
    BrnPickerTitleConfig pickerTitleConfig = const BrnPickerTitleConfig(titleContent: "选择时间范围");
    BrnDateRangePicker.showDatePicker(
      context,
      pickerMode: BrnDateTimeRangePickerMode.time,
      minuteDivider: 1,
      pickerTitleConfig: pickerTitleConfig,
      timeRangeCustomIndex: 1,
      timeRangeCustomList: ['本日','次日'],
      dateFormat: dateFormat,
      onConfirm: (startDateTime, endDateTime, startSelectedIndex, endSelectedIndex, {timeRangeCustomIndex}) {
        resultFormat ??= dateFormat;
      },
    );
  }
}
