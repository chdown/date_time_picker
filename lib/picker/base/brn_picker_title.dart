import 'package:date_time_picker/l10n/brn_intl.dart';
import 'package:date_time_picker/picker/base/brn_picker_config.dart';
import 'package:date_time_picker/picker/base/brn_picker_title_config.dart';
import 'package:date_time_picker/picker/time_picker/brn_date_picker_constants.dart';
import 'package:flutter/material.dart';

/// DatePicker's title widget.
// ignore: must_be_immutable
class BrnPickerTitle extends StatelessWidget {
  final BrnPickerTitleConfig pickerTitleConfig;
  final DateVoidCallback onCancel, onConfirm;

  BrnPickerTitle({
    Key? key,
    required this.onCancel,
    required this.onConfirm,
    this.pickerTitleConfig = BrnPickerTitleConfig.Default,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (pickerTitleConfig.title != null) {
      return pickerTitleConfig.title!;
    }
    return Container(
      height: BrnPickerConfig.titleHeight,
      decoration: ShapeDecoration(
        color: BrnPickerConfig.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(BrnPickerConfig.cornerRadius),
            topRight: Radius.circular(BrnPickerConfig.cornerRadius),
          ),
        ),
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: BrnPickerConfig.titleHeight - 0.5,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: BrnPickerConfig.titleHeight,
                    alignment: Alignment.center,
                    child: _renderCancelWidget(context),
                  ),
                  onTap: () {
                    this.onCancel();
                  },
                ),
                Text(
                  pickerTitleConfig.titleContent ?? BrnIntl.of(context).localizedResource.pleaseChoose,
                  style: BrnPickerConfig.titleTextStyle.generateTextStyle(),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  child: Container(
                    height: BrnPickerConfig.titleHeight,
                    alignment: Alignment.center,
                    child: _renderConfirmWidget(context),
                  ),
                  onTap: () {
                    this.onConfirm();
                  },
                ),
              ],
            ),
          ),
          Divider(
            color: BrnPickerConfig.dividerColor,
            indent: 0.0,
            height: 0.5,
          ),
        ],
      ),
    );
  }

  /// render cancel button widget
  Widget _renderCancelWidget(BuildContext context) {
    Widget? cancelWidget = pickerTitleConfig.cancel;
    if (cancelWidget == null) {
      TextStyle textStyle = BrnPickerConfig.cancelTextStyle.generateTextStyle();
      cancelWidget = Text(
        BrnIntl.of(context).localizedResource.cancel,
        style: textStyle,
        textAlign: TextAlign.left,
      );
    }
    return cancelWidget;
  }

  /// render confirm button widget
  Widget _renderConfirmWidget(BuildContext context) {
    Widget? confirmWidget = pickerTitleConfig.confirm;
    if (confirmWidget == null) {
      TextStyle textStyle = BrnPickerConfig.confirmTextStyle.generateTextStyle();
      confirmWidget = Text(
        BrnIntl.of(context).localizedResource.done,
        style: textStyle,
        textAlign: TextAlign.right,
      );
    }
    return confirmWidget;
  }
}
