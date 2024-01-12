import 'package:date_time_picker/picker/base/brn_picker_config.dart';
import 'package:date_time_picker/picker/base/brn_picker_title.dart';
import 'package:date_time_picker/picker/base/brn_picker_title_config.dart';
import 'package:date_time_picker/picker/brn_picker_cliprrect.dart';
import 'package:date_time_picker/picker/multi_select_bottom_picker/brn_multi_select_data.dart';
import 'package:flutter/material.dart';

/// 点击确定时的回调
/// [checkedItems] 被选中的 item 集合
typedef BrnMultiSelectListPickerSubmit<T> = void Function(List<T> checkedItems);

/// item 被点击时的回调
/// [index] item 的索引
typedef BrnMultiSelectListPickerItemClick = void Function(BuildContext context, int index);

/// 多选列表 Picker

class BrnMultiSelectListPicker<T extends BrnMultiSelectBottomPickerItem> extends StatefulWidget {
  final String? title;
  final List<T> items;
  final BrnMultiSelectListPickerSubmit<T>? onSubmit;
  final VoidCallback? onCancel;
  final BrnMultiSelectListPickerItemClick? onItemClick;
  final BrnPickerTitleConfig pickerTitleConfig;
  final double? maxHeight;

  static void show<T extends BrnMultiSelectBottomPickerItem>(
    BuildContext context, {
    required List<T> items,
    BrnMultiSelectListPickerSubmit<T>? onSubmit,
    VoidCallback? onCancel,
    BrnMultiSelectListPickerItemClick? onItemClick,
    BrnPickerTitleConfig pickerTitleConfig = BrnPickerTitleConfig.Default,
    bool isDismissible = true,
    double? maxHeight,
  }) {
    showModalBottomSheet(
      context: context,
      isDismissible: isDismissible,
      backgroundColor: Colors.transparent,
      builder: (BuildContext dialogContext) {
        return BrnMultiSelectListPicker<T>(
          items: items,
          onSubmit: onSubmit,
          onCancel: onCancel,
          onItemClick: onItemClick,
          pickerTitleConfig: pickerTitleConfig,
          maxHeight: maxHeight,
        );
      },
    );
  }

  BrnMultiSelectListPicker({
    Key? key,
    this.title,
    required this.items,
    this.pickerTitleConfig = BrnPickerTitleConfig.Default,
    this.onSubmit,
    this.onCancel,
    this.onItemClick,
    this.maxHeight,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return MultiSelectDialogWidgetState<T>();
  }
}

class MultiSelectDialogWidgetState<T extends BrnMultiSelectBottomPickerItem> extends State<BrnMultiSelectListPicker<T>> {
  @override
  Widget build(BuildContext context) {
    return BrnPickerClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(BrnPickerConfig.cornerRadius),
        topRight: Radius.circular(BrnPickerConfig.cornerRadius),
      ),
      child: Container(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Offstage(
                  offstage: !widget.pickerTitleConfig.showTitle,
                  child: BrnPickerTitle(
                    pickerTitleConfig: widget.pickerTitleConfig,
                    onConfirm: () {
                      List<T> selectedItems = [];
                      if (widget.onSubmit != null) {
                        for (int i = 0; i < widget.items.length; i++) {
                          if (widget.items[i].isChecked) {
                            selectedItems.add(widget.items[i]);
                          }
                        }
                        if (widget.onSubmit != null) {
                          widget.onSubmit!(selectedItems);
                        }
                      }
                    },
                    onCancel: widget.onCancel ??
                        () {
                          Navigator.of(context).pop();
                        },
                  ),
                ),
                LimitedBox(
                    maxWidth: double.infinity,
                    maxHeight: widget.maxHeight ?? BrnPickerConfig.pickerHeight,
                    child: ListView.builder(shrinkWrap: true, itemBuilder: (context, index) => _buildItem(context, index), itemCount: widget.items.length)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, int index) {
    return GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            widget.items[index].isChecked = !widget.items[index].isChecked;
          });
          if (widget.onItemClick != null) {
            widget.onItemClick!(context, index);
          }
        },
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      widget.items[index].content,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: widget.items[index].isChecked ? FontWeight.w600 : FontWeight.normal,
                        color: widget.items[index].isChecked ? BrnPickerConfig.colorPrimary : BrnPickerConfig.colorTextBase,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    height: 50,
                    child: widget.items[index].isChecked ? BrnPickerConfig.checked : BrnPickerConfig.checkedUn,
                  ),
                ],
              ),
            ),
            index != widget.items.length - 1
                ? Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Divider(
                      color: BrnPickerConfig.dividerColor,
                      indent: 0.0,
                      height: 0.5,
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ));
  }
}
