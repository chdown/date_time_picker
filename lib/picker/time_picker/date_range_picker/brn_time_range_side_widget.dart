import 'dart:math';

import 'package:date_time_picker/picker/base/brn_picker.dart';
import 'package:date_time_picker/picker/base/brn_picker_config.dart';
import 'package:date_time_picker/picker/time_picker/brn_date_picker_constants.dart';
import 'package:date_time_picker/picker/time_picker/brn_date_time_formatter.dart';
import 'package:flutter/material.dart';

/// TimeRangeSidePicker widget.
// ignore: must_be_immutable
class BrnTimeRangeSideWidget extends StatefulWidget {
  /// 可选最小时间
  final DateTime? minDateTime;

  /// 可选最大时间
  final DateTime? maxDateTime;

  /// 初始开始选中时间
  final DateTime? initialStartDateTime;

  /// 时间展示格式
  final String? dateFormat;

  /// 时间选择变化时回调
  final DateRangeSideValueCallback? onChange;

  /// 分钟的展示间隔
  final int? minuteDivider;

  /// 秒的展示间隔
  final int? secondDivider;

  /// 当前默认选择的时间变化时对外部回调，外部监听该事件同步修改默认初始选中的时间
  final DateRangeSideValueCallback? onInitSelectChange;

  BrnTimeRangeSideWidget({
    Key? key,
    this.minDateTime,
    this.maxDateTime,
    this.initialStartDateTime,
    this.dateFormat = datetimeRangePickerTimeFormat,
    this.minuteDivider = 1,
    this.secondDivider = 1,
    this.onChange,
    this.onInitSelectChange,
  }) : super(key: key) {
    DateTime minTime = minDateTime ?? DateTime.parse(datePickerMinDatetime);
    DateTime maxTime = maxDateTime ?? DateTime.parse(datePickerMaxDatetime);
    assert(minTime.compareTo(maxTime) <= 0);
  }

  @override
  State<StatefulWidget> createState() => _TimePickerWidgetState(
      this.minDateTime, this.maxDateTime, this.initialStartDateTime, this.dateFormat!, this.minuteDivider, this.secondDivider, this.onInitSelectChange);
}

class _TimePickerWidgetState extends State<BrnTimeRangeSideWidget> {
  late DateTime _minTime, _maxTime;
  late int _currStartHour, _currStartMinute, _currStartSecond = 0;
  late int _minuteDivider = 1, _secondDivider = 1;
  late List<int> _hourRange, _minuteRange, _secondRange = [];
  late FixedExtentScrollController _startHourScrollCtrl, _startMinuteScrollCtrl, _startSecondScrollCtrl;

  late Map<String, FixedExtentScrollController> _startScrollCtrlMap;
  late Map<String, List<int>> _valueRangeMap;
  late String _dateFormat;

  bool _isChangeTimeRange = false;
  bool _scrolledNotMinute = false, _scrolledNotSecond = false;

  DateRangeSideValueCallback? _onInitSelectChange;

  _TimePickerWidgetState(
    DateTime? minTime,
    DateTime? maxTime,
    DateTime? initStartTime,
    String dateFormat,
    int? minuteDivider,
    int? secondDivider,
    DateRangeSideValueCallback? onInitSelectChange,
  ) {
    _onInitSelectChange = onInitSelectChange;
    _initData(minTime, maxTime, initStartTime, dateFormat, minuteDivider, secondDivider);
  }

  void _initData(DateTime? minTime, DateTime? maxTime, DateTime? initStartTime, String dateFormat, int? minuteDivider, int? secondDivider) {
    _dateFormat = dateFormat;
    if (minuteDivider == null || minuteDivider <= 0) _minuteDivider = 1;
    if (secondDivider == null || secondDivider <= 0) _secondDivider = 1;
    if (secondDivider == null || secondDivider <= 0) _secondDivider = 1;
    minTime ??= DateTime.parse(datePickerMinDatetime);
    maxTime ??= DateTime.parse(datePickerMaxDatetime);
    _minTime = minTime;
    _maxTime = maxTime;

    initStartTime ??= DateTime.now();

    _currStartHour = initStartTime.hour;
    _hourRange = _calcHourRange();
    _currStartHour = min(max(_hourRange.first, _currStartHour), _hourRange.last);

    _currStartMinute = initStartTime.minute;
    _minuteRange = _calcMinuteRange();
    _currStartMinute = min(max(_minuteRange.first, _currStartMinute), _minuteRange.last);
    _currStartMinute -= _currStartMinute % _minuteDivider;

    if (_dateFormat.contains("s")) {
      _currStartSecond = initStartTime.second;
      _secondRange = _calcSecondRange();
      _currStartSecond = min(max(_secondRange.first, _currStartSecond), _secondRange.last);
      _currStartSecond -= _currStartSecond % _secondDivider;
    }

    _onInitSelectedChange();
    // create scroll controller
    _startHourScrollCtrl = FixedExtentScrollController(initialItem: _currStartHour - _hourRange.first);
    _startMinuteScrollCtrl = FixedExtentScrollController(initialItem: (_currStartMinute - _minuteRange.first) ~/ _minuteDivider);
    if (_dateFormat.contains("s")) _startSecondScrollCtrl = FixedExtentScrollController(initialItem: (_currStartSecond - _secondRange.first) ~/ _secondDivider);
    _startScrollCtrlMap = {
      'H': _startHourScrollCtrl,
      'm': _startMinuteScrollCtrl,
      if (_dateFormat.contains("s")) 's': _startSecondScrollCtrl,
    };

    _valueRangeMap = {
      'H': _hourRange,
      'm': _minuteRange,
      if (_dateFormat.contains("s")) 's': _secondRange,
    };
  }

  @override
  Widget build(BuildContext context) {
    _initData(_minTime, _maxTime, widget.initialStartDateTime, _dateFormat, _minuteDivider, _secondDivider);
    return GestureDetector(
      child: Container(color: BrnPickerConfig.backgroundColor, child: _renderPickerView(context)),
    );
  }

  /// render time picker widgets
  Widget _renderPickerView(BuildContext context) {
    return _renderDatePickerWidget();
  }

  /// notify selected time changed
  void _onInitSelectedChange() {
    if (_onInitSelectChange != null) {
      DateTime now = DateTime.now();
      DateTime startDateTime = DateTime(now.year, now.month, now.day, _currStartHour, _currStartMinute, _currStartSecond);
      _onInitSelectChange!(startDateTime, _calcStartSelectIndexList());
    }
  }

  /// notify selected time changed
  void _onSelectedChange() {
    if (widget.onChange != null) {
      DateTime now = DateTime.now();
      DateTime startDateTime = DateTime(now.year, now.month, now.day, _currStartHour, _currStartMinute, _currStartSecond);
      widget.onChange!(startDateTime, _calcStartSelectIndexList());
    }
  }

  /// find start scroll controller by specified format
  FixedExtentScrollController? _findScrollCtrl(String format) {
    FixedExtentScrollController? scrollCtrl;
    _startScrollCtrlMap.forEach((key, value) {
      if (format.contains(key)) {
        scrollCtrl = value;
      }
    });
    return scrollCtrl;
  }

  /// find item value range by specified format
  List<int>? _findPickerItemRange(String format) {
    List<int>? valueRange;
    _valueRangeMap.forEach((key, value) {
      if (format.contains(key)) {
        valueRange = value;
      }
    });
    return valueRange;
  }

  /// render the picker widget of year、month and day
  Widget _renderDatePickerWidget() {
    List<Widget> pickers = [];
    List<String> formatArr = DateTimeFormatter.splitDateFormat(widget.dateFormat);
    formatArr.forEach((format) {
      List<int>? valueRange = _findPickerItemRange(format);

      Widget pickerColumn = _renderDatePickerColumnComponent(
        scrollCtrl: _findScrollCtrl(format),
        valueRange: valueRange,
        format: format,
        valueChanged: (value) {
          if (format.contains('H')) {
            _changeHourSelection(value);
          } else if (format.contains('m')) {
            _changeMinuteSelection(value);
          } else if (format.contains('s')) {
            _changeSecondSelection(value);
          }
        },
      );
      pickers.add(pickerColumn);
    });
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: pickers);
  }

  Widget _renderDatePickerColumnComponent({
    required FixedExtentScrollController? scrollCtrl,
    required List<int>? valueRange,
    required String format,
    required ValueChanged<int> valueChanged,
  }) {
    GlobalKey? globalKey;
    if (_scrolledNotMinute && format.contains("m")) {
      globalKey = GlobalKey();
      _scrolledNotMinute = false;
    } else if (_scrolledNotSecond && format.contains("s")) {
      globalKey = GlobalKey();
      _scrolledNotSecond = false;
    }

    return Expanded(
      flex: 1,
      child: Container(
        height: BrnPickerConfig.pickerHeight,
        color: BrnPickerConfig.backgroundColor,
        child: BrnPicker.builder(
          key: globalKey,
          backgroundColor: BrnPickerConfig.backgroundColor,
          lineColor: BrnPickerConfig.dividerColor,
          scrollController: scrollCtrl,
          itemExtent: BrnPickerConfig.itemHeight,
          onSelectedItemChanged: (int index) {
            if (!format.contains("m")) {
              _scrolledNotMinute = true;
            }
            if (!format.contains("s")) {
              _scrolledNotSecond = true;
            }
            valueChanged(index);
          },
          childCount: getChildCount(format, valueRange),
          itemBuilder: (context, index) {
            int value = valueRange!.first + index;

            if (format.contains('m')) {
              value = valueRange.first + _minuteDivider * index;
            }
            if (format.contains('s')) {
              value = valueRange.first + _secondDivider * index;
            }
            return _renderDatePickerItemComponent(index, value, format);
          },
        ),
      ),
    );
  }

  int getChildCount(String format, List<int>? valueRange) {
    if (format.contains('m')) {
      return _calculateMinuteChildCount(valueRange, _minuteDivider);
    } else if (format.contains('s')) {
      return _calculateSecondChildCount(valueRange, _secondDivider);
    } else {
      return valueRange!.last - valueRange.first + 1;
    }
  }

  _calculateMinuteChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0 || divider == 1) {
      debugPrint("Cant devide by 0");
      return (valueRange!.last - valueRange.first + 1);
    }

    return ((valueRange!.last - valueRange.first) ~/ divider!) + 1;
  }

  _calculateSecondChildCount(List<int>? valueRange, int? divider) {
    if (divider == 0 || divider == 1) {
      debugPrint("Cant devide by 0");
      return (valueRange!.last - valueRange.first + 1);
    }

    return ((valueRange!.last - valueRange.first) ~/ divider!) + 1;
  }

  Widget _renderDatePickerItemComponent(int index, int value, String format) {
    TextStyle textStyle = BrnPickerConfig.itemTextStyle.generateTextStyle();
    if ((format.contains("H") && (index == _calcStartSelectIndexList()[0])) ||
        ((format.contains("m") && (index == _calcStartSelectIndexList()[1]))) ||
        ((format.contains("s") && (index == _calcStartSelectIndexList()[2])))) {
      textStyle = BrnPickerConfig.itemTextSelectedStyle.generateTextStyle();
    }
    return Container(
        height: BrnPickerConfig.itemHeight,
        alignment: Alignment.center,
        child: Text(
          DateTimeFormatter.formatDateTime(value, format),
          style: textStyle,
        ));
  }

  /// change the selection of hour picker
  void _changeHourSelection(int index) {
    int value = _hourRange.first + index;
    _currStartHour = value;
    _changeStartTimeRange();
    _onSelectedChange();
  }

  /// change the selection of month picker
  void _changeMinuteSelection(int index) {
    int value = _minuteRange.first + index * _minuteDivider;
    _currStartMinute = value;
    _changeStartTimeRange();
    _onSelectedChange();
  }

  /// change the selection of month picker
  void _changeSecondSelection(int index) {
    int value = _secondRange.first + index * _secondDivider;
    _currStartSecond = value;
    _changeStartTimeRange();
    _onSelectedChange();
  }

  /// change range of minute and second
  void _changeStartTimeRange() {
    if (_isChangeTimeRange) {
      return;
    }
    _isChangeTimeRange = true;

    List<int> minuteRange = _calcMinuteRange();
    bool minuteRangeChanged = _minuteRange.first != minuteRange.first || _minuteRange.last != minuteRange.last;
    if (minuteRangeChanged) {
      // selected hour changed
      _currStartMinute = max(min(_currStartMinute, minuteRange.last), minuteRange.first);
    }

    List<int> secondRange = [];
    bool secondRangeChanged = false;
    if (_dateFormat.contains("s")) {
      secondRange = _calcSecondRange();
      secondRangeChanged = _secondRange.first != secondRange.first || _secondRange.last != secondRange.last;
      if (secondRangeChanged) {
        _currStartSecond = max(min(_currStartSecond, secondRange.last), secondRange.first);
      }
    }

    setState(() {
      _minuteRange = minuteRange;
      _valueRangeMap['m'] = minuteRange;
      if (_dateFormat.contains("s")) {
        _secondRange = secondRange;
        _valueRangeMap['s'] = secondRange;
      }
    });

    if (minuteRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currMinute = _currStartMinute;
      _startMinuteScrollCtrl.jumpToItem((minuteRange.last - minuteRange.first) ~/ _minuteDivider);
      if (currMinute < minuteRange.last) {
        _startMinuteScrollCtrl.jumpToItem((currMinute - minuteRange.first) ~/ _secondDivider);
      }
    }
    if (secondRangeChanged) {
      // CupertinoPicker refresh data not working (https://github.com/flutter/flutter/issues/22999)
      int currSecond = _currStartSecond;
      _startSecondScrollCtrl.jumpToItem((secondRange.last - secondRange.first) ~/ _minuteDivider);
      if (currSecond < secondRange.last) {
        _startSecondScrollCtrl.jumpToItem((currSecond - secondRange.first) ~/ _secondDivider);
      }
    }

    _isChangeTimeRange = false;
  }

  /// calculate selected index list
  List<int> _calcStartSelectIndexList() {
    int hourIndex = _currStartHour - _hourRange.first;
    int minuteIndex = (_currStartMinute - _minuteRange.first) ~/ _minuteDivider;
    return [hourIndex, minuteIndex, if (_dateFormat.contains("s")) ((_currStartSecond - _secondRange.first) ~/ _secondDivider)];
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
}
