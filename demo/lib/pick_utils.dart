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
      timeRangeCustomList: ['本日', '次日'],
      dateFormat: dateFormat,
      onConfirm: (startDateTime, endDateTime, startSelectedIndex, endSelectedIndex, {timeRangeCustomIndex}) {
        resultFormat ??= dateFormat;
      },
    );
  }

  /// 单列选择
  static showItem(
    BuildContext context,
    String title,
    String? defaultValue,
    List<String> dataList,
    Function(int index) onTap, {
    double? pickerHeight,
  }) {
    List<BrnMultiDataPickerEntity> list = [];
    for (var value in dataList) {
      list.add(BrnMultiDataPickerEntity(text: value, value: value));
    }
    int index = dataList.indexOf(defaultValue ?? "");
    BrnMultiDataPicker(
      context: context,
      delegate: BrnDefaultMultiDataPickerDelegate(
        data: list,
        firstSelectedIndex: index < 0 ? 0 : index,
      ),
      title: title,
      confirmClick: (selectedIndexList) {
        if (selectedIndexList.isNotEmpty) onTap(selectedIndexList[0]);
      },
      pickerHeight: BrnPickerConfig.itemHeight * 8,
    ).show();
  }
}
