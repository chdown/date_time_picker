import 'dart:math';

import 'package:date_time_picker/l10n/brn_intl.dart';
import 'package:date_time_picker/picker/base/brn_picker.dart';
import 'package:date_time_picker/picker/base/brn_picker_config.dart';
import 'package:date_time_picker/picker/base/brn_picker_title.dart';
import 'package:date_time_picker/picker/base/brn_picker_title_config.dart';
import 'package:date_time_picker/picker/time_picker/brn_date_picker_constants.dart';
import 'package:date_time_picker/picker/time_picker/date_range_picker/brn_time_range_side_widget.dart';
import 'package:flutter/material.dart';

/// 时间范围选择 TimeRange widget.
// ignore: must_be_immutable
class BrnTimeRangeWidget extends StatefulWidget {
  /// 可选最小时间
  final DateTime? minDateTime;

  /// 可选最大时间
  final DateTime? maxDateTime;

  /// 初始开始选中时间
  final DateTime? initialStartDateTime;

  /// 初始结束选中时间
  final DateTime? initialEndDateTime;

  /// 是否限制 Picker 选择的时间范围（开始时间≤结束时间）
  final bool isLimitTimeRange;

  /// 时间格式
  final String? dateFormat;

  /// cancel 回调
  final DateVoidCallback? onCancel;

  /// 选中时间变化时的回调，返回选中的开始、结束时间
  final DateRangeValueCallback? onChange;

  /// 确定回调，返回选中的开始、结束时间
  final DateRangeValueCallback? onConfirm;

  /// Picker title  相关内容配置
  final BrnPickerTitleConfig pickerTitleConfig;

  /// 分钟展示的间隔
  final int minuteDivider;

  /// 分钟展示的间隔
  final int secondDivider;

  /// 内部变量，记录左右两侧是否触发了滚动
  bool _isFirstScroll = false, _isSecondScroll = false;

  BrnTimeRangeWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.isLimitTimeRange = true,
    this.initialStartDateTime,
    this.initialEndDateTime,
    this.dateFormat = datetimeRangePickerTimeFormat,
    this.pickerTitleConfig = BrnPickerTitleConfig.Default,
    this.minuteDivider = 1,
    this.secondDivider = 1,
    this.onCancel,
    this.onChange,
    this.onConfirm,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) < 0);
  }

  @override
  State<StatefulWidget> createState() => _TimePickerWidgetState(
      this.minDateTime, this.maxDateTime, this.initialStartDateTime, this.initialEndDateTime, this.dateFormat!, this.minuteDivider, this.secondDivider);
}

class _TimePickerWidgetState extends State<BrnTimeRangeWidget> {
  late int _minuteDivider = 1, _secondDivider = 1;
  late DateTime _minTime, _maxTime;
  late int _currStartHour, _currStartMinute, _currStartSecond = 0;
  late int _currEndHour, _currEndMinute, _currEndSecond = 0;
  late List<int> _hourRange, _minuteRange, _secondRange = [];
  late List<int> _startSelectedIndex, _endSelectedIndex;
  late DateTime _startSelectedDateTime, _endSelectedDateTime;
  late String _dateFormat;

  _TimePickerWidgetState(
    DateTime? minTime,
    DateTime? maxTime,
    DateTime? initStartTime,
    DateTime? initEndTime,
    String dateFormat,
    int minuteDivider,
    int secondDriver,
  ) {
    _initData(minTime, maxTime, initStartTime, initEndTime, dateFormat, minuteDivider, secondDriver);
  }

  void _initData(
    DateTime? minTime,
    DateTime? maxTime,
    DateTime? initStartTime,
    DateTime? initEndTime,
    String dateFormat,
    int? minuteDivider,
    int? secondDriver,
  ) {
    _dateFormat = dateFormat;
    if (minuteDivider == null || minuteDivider <= 0) _minuteDivider = 1;
    if (secondDriver == null || secondDriver <= 0) _secondDivider = 1;

    minTime ??= DateTime.parse(datePickerMinDatetime);
    maxTime ??= DateTime.parse(datePickerMaxDatetime);
    DateTime now = DateTime.now();
    _minTime = DateTime(now.year, now.month, now.day, minTime.hour, minTime.minute, minTime.second);
    _maxTime = DateTime(now.year, now.month, now.day, maxTime.hour, maxTime.minute, maxTime.second);

    initStartTime ??= DateTime.now();
    initEndTime ??= DateTime.now();

    _currStartHour = initStartTime.hour;
    _hourRange = _calcHourRange();
    _currStartHour = min(max(_hourRange.first, _currStartHour), _hourRange.last);
    _currEndHour = initEndTime.hour;
    _currEndHour = min(_currEndHour, _hourRange.last);

    _currStartMinute = initStartTime.minute;
    _minuteRange = _calcMinuteRange();
    _currStartMinute = min(max(_minuteRange.first, _currStartMinute), _minuteRange.last);
    _currStartMinute -= _currStartMinute % _minuteDivider;
    _currEndMinute = initEndTime.minute;
    _currEndMinute = min(_currEndMinute, _minuteRange.last);
    _currEndMinute -= _currEndMinute % _minuteDivider;

    if (_dateFormat.contains("s")) {
      _currStartSecond = initStartTime.second;
      _secondRange = _calcSecondRange();
      _currStartSecond = min(max(_secondRange.first, _currStartSecond), _secondRange.last);
      _currStartSecond -= _currStartSecond % _secondDivider;
      _currEndSecond = initEndTime.second;
      _currEndSecond = min(_currEndSecond, _secondRange.last);
      _currEndSecond -= _currEndSecond % _minuteDivider;
    }

    _startSelectedDateTime = DateTime(now.year, now.month, now.day, _currStartHour, _currStartMinute, _currStartSecond);
    _endSelectedDateTime = DateTime(now.year, now.month, now.day, _currEndHour, _currEndMinute, _currEndSecond);

    _startSelectedIndex = _calcStartSelectIndexList(_minuteDivider);
    _endSelectedIndex = _calcEndSelectIndexList(_minuteDivider);
  }

  @override
  Widget build(BuildContext context) {
    _initData(_minTime, _maxTime, _startSelectedDateTime, _endSelectedDateTime, _dateFormat, _minuteDivider, _secondDivider);
    return GestureDetector(
      child: Material(color: Colors.transparent, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    Widget pickerWidget = _renderDatePickerWidget();

    // display the title widget
    if (widget.pickerTitleConfig.title != null || widget.pickerTitleConfig.showTitle) {
      Widget titleWidget = BrnPickerTitle(
        pickerTitleConfig: widget.pickerTitleConfig,
        onCancel: () => _onPressedCancel(),
        onConfirm: () => _onPressedConfirm(),
      );
      return Column(children: <Widget>[titleWidget, pickerWidget]);
    }
    return pickerWidget;
  }

  /// pressed cancel widget
  void _onPressedCancel() {
    if (widget.onCancel != null) {
      widget.onCancel!();
    }
    Navigator.pop(context);
  }

  /// pressed confirm widget
  void _onPressedConfirm() {
    if (widget.onConfirm != null) {
      widget.onConfirm!(_startSelectedDateTime, _endSelectedDateTime, _startSelectedIndex, _endSelectedIndex);
    }
    Navigator.pop(context);
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    /// 用于强制刷新 Widget
    GlobalKey? firstGlobalKey;
    GlobalKey? secondGlobalKey;

    if (widget._isFirstScroll) {
      secondGlobalKey = GlobalKey();
      widget._isFirstScroll = false;
    }
    if (widget._isSecondScroll) {
      firstGlobalKey = GlobalKey();
      widget._isSecondScroll = false;
    }

    List<Widget> pickers = [];
    pickers.add(
      Expanded(
        flex: 6,
        child: Container(
          height: BrnPickerConfig.pickerHeight,
          color: BrnPickerConfig.backgroundColor,
          child: BrnTimeRangeSideWidget(
            key: firstGlobalKey,
            dateFormat: widget.dateFormat,
            minDateTime: _minTime,
            maxDateTime: _maxTime,
            initialStartDateTime: _startSelectedDateTime,
            minuteDivider: _minuteDivider,
            secondDivider: _secondDivider,
            onInitSelectChange: (widget.isLimitTimeRange)
                ? (DateTime selectedDateTime, List<int> selected) {
                    _startSelectedDateTime = selectedDateTime;
                    _startSelectedIndex = selected;
                  }
                : null,
            onChange: (DateTime selectedDateTime, List<int> selected) {
              setState(() {
                _startSelectedDateTime = selectedDateTime;
                _startSelectedIndex = selected;
                widget._isFirstScroll = true;
              });
            },
          ),
        ),
      ),
    );
    pickers.add(_renderDatePickerMiddleColumnComponent());
    pickers.add(
      Expanded(
        flex: 6,
        child: Container(
          height: BrnPickerConfig.pickerHeight,
          color: BrnPickerConfig.backgroundColor,
          child: BrnTimeRangeSideWidget(
            key: secondGlobalKey,
            dateFormat: widget.dateFormat,
            minDateTime: (widget.isLimitTimeRange) ? _startSelectedDateTime : _minTime,
            maxDateTime: _maxTime,
            initialStartDateTime: (widget.isLimitTimeRange)
                ? _endSelectedDateTime.compareTo(_startSelectedDateTime) > 0
                    ? _endSelectedDateTime
                    : _startSelectedDateTime
                : _endSelectedDateTime,
            minuteDivider: _minuteDivider,
            secondDivider: _secondDivider,
            onInitSelectChange: (widget.isLimitTimeRange)
                ? (DateTime selectedDateTime, List<int> selected) {
                    _endSelectedDateTime = selectedDateTime;
                    _endSelectedIndex = selected;
                  }
                : null,
            onChange: (DateTime selectedDateTime, List<int> selected) {
              setState(() {
                _endSelectedDateTime = selectedDateTime;
                _endSelectedIndex = selected;
                widget._isSecondScroll = true;
              });
            },
          ),
        ),
      ),
    );
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  /// calculate selected index list
  List<int> _calcStartSelectIndexList(int minuteDivider) {
    int hourIndex = _currStartHour - _hourRange.first;
    int minuteIndex = (_currStartMinute - _minuteRange.first) ~/ minuteDivider;
    return [hourIndex, minuteIndex, if (_dateFormat.contains("s")) ((_currStartSecond - _secondRange.first) ~/ _secondDivider)];
  }

  /// calculate selected index list
  List<int> _calcEndSelectIndexList(int minuteDivider) {
    int hourIndex = _currEndHour - _hourRange.first;
    int minuteIndex = (_currEndMinute - _minuteRange.first) ~/ minuteDivider;
    return [hourIndex, minuteIndex, if (_dateFormat.contains("s")) ((_currEndSecond - _secondRange.first) ~/ _secondDivider)];
  }

  /// calculate the range of hour
  List<int> _calcHourRange() {
    return [_minTime.hour, _maxTime.hour];
  }

  /// calculate the range of minute
  List<int> _calcMinuteRange({currHour}) {
    int minMinute = 0, maxMinute = 59;
    int minHour = _minTime.hour;
    int maxHour = _maxTime.hour;
    currHour ??= _currStartHour;
    if (minHour == currHour) minMinute = _minTime.minute;
    if (maxHour == currHour) maxMinute = _maxTime.minute;
    return [minMinute, maxMinute];
  }

  /// calculate the range of minute
  List<int> _calcSecondRange({currMinute}) {
    int minSecond = 0, maxSecond = 59;
    int minMinute = _minTime.minute;
    int maxMinute = _maxTime.minute;
    currMinute ??= _currStartMinute;
    if (minMinute == currMinute) minSecond = _minTime.second;
    if (maxMinute == currMinute) maxSecond = _maxTime.second;
    return [minSecond, maxSecond];
  }

  Widget _renderDatePickerMiddleColumnComponent() {
    return Expanded(
      flex: 1,
      child: Container(
        height: BrnPickerConfig.pickerHeight,
        decoration: BoxDecoration(border: const Border(left: BorderSide.none, right: BorderSide.none), color: BrnPickerConfig.backgroundColor),
        child: BrnPicker.builder(
          backgroundColor: BrnPickerConfig.backgroundColor,
          lineColor: BrnPickerConfig.dividerColor,
          itemExtent: BrnPickerConfig.itemHeight,
          childCount: 1,
          itemBuilder: (context, index) {
            return Container(
              height: BrnPickerConfig.itemHeight,
              alignment: Alignment.center,
              child: Text(
                BrnIntl.of(context).localizedResource.to,
                style: BrnPickerConfig.itemTextStyle.generateTextStyle(),
              ),
            );
          },
          onSelectedItemChanged: (int value) {},
        ),
      ),
    );
  }
}
