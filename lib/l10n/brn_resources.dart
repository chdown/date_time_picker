import 'dart:core';
import 'dart:ui';

/// 资源抽象类
abstract class BrnBaseResource {
  String get cancel;

  String get confirm;

  String get pleaseChoose;

  List<String> get months;

  List<String> get weekFullName;

  List<String> get weekShortName;

  String get done;

  String get to;
}

///
/// 中文资源
///
class BrnResourceZh extends BrnBaseResource {
  static Locale locale = Locale('zh', 'CN');

  @override
  String get cancel => '取消';

  @override
  String get confirm => '确认';

  @override
  String get pleaseChoose => '请选择';

  List<String> get months => [
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
      ];

  @override
  List<String> get weekFullName => [
        '星期一',
        '星期二',
        '星期三',
        '星期四',
        '星期五',
        '星期六',
        '星期日',
      ];

  @override
  List<String> get weekShortName => [
        '周一',
        '周二',
        '周三',
        '周四',
        '周五',
        '周六',
        '周日',
      ];

  @override
  String get done => '完成';

  @override
  String get to => '至';
}

///
/// en resources
///
class BrnResourceEn extends BrnBaseResource {
  static Locale locale = Locale('en', 'US');

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get pleaseChoose => 'Please choose';

  @override
  List<String> get months => [
        '01',
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '09',
        '10',
        '11',
        '12',
      ];

  @override
  List<String> get weekFullName => [
        'Monday',
        'Tuesday',
        'Wednesday',
        'Thursday',
        'Friday',
        'Saturday',
        'Sunday',
      ];

  @override
  List<String> get weekShortName => [
        'Mon',
        'Tue',
        'Wed',
        'Thu',
        'Fri',
        'Sat',
        'Sun',
      ];

  @override
  String get done => 'Done';

  @override
  String get to => 'to';
}
