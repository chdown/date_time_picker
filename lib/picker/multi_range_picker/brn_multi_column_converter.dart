import 'package:date_time_picker/utils/brn_tools.dart';

import 'bean/brn_multi_column_picker_entity.dart';
import 'brn_multi_column_picker_util.dart';

class BrnMultiRangeSelConverter {
  const BrnMultiRangeSelConverter();

  Map<String, List<BrnPickerEntity>> convertPickedData(
      List<BrnPickerEntity> selectedResults,
      {bool includeUnlimitSelection = false}) {
    return getSelectionParams(selectedResults,
        includeUnlimitSelection: includeUnlimitSelection);
  }

  Map<String, List<BrnPickerEntity>> getSelectionParams(
      List<BrnPickerEntity>? selectedResults,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<BrnPickerEntity>> params = Map();
    if (selectedResults == null) return params;
    for (BrnPickerEntity menuItemEntity in selectedResults) {
      int levelCount =
          BrnMultiColumnPickerUtil.getTotalColumnCount(menuItemEntity);
      if (levelCount == 1) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
      } else if (levelCount == 2) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) => mergeParams(
            params,
            getCurrentSelectionEntityParams(firstLevelItem,
                includeUnlimitSelection: includeUnlimitSelection)));
      } else if (levelCount == 3) {
        params.addAll(getCurrentSelectionEntityParams(menuItemEntity,
            includeUnlimitSelection: includeUnlimitSelection));
        menuItemEntity.children.forEach((firstLevelItem) {
          mergeParams(
              params,
              getCurrentSelectionEntityParams(firstLevelItem,
                  includeUnlimitSelection: includeUnlimitSelection));
          firstLevelItem.children.forEach((secondLevelItem) {
            mergeParams(
                params,
                getCurrentSelectionEntityParams(secondLevelItem,
                    includeUnlimitSelection: includeUnlimitSelection));
          });
        });
      }
    }
    return params;
  }

  Map<String?, List<BrnPickerEntity>> mergeParams(
      Map<String?, List<BrnPickerEntity>> params,
      Map<String?, List<BrnPickerEntity>> selectedParams) {
    selectedParams.forEach((String? key, List<BrnPickerEntity> value) {
      if (params.containsKey(key)) {
        params[key]?.addAll(value);
      } else {
        params.addAll(selectedParams);
      }
    });
    return params;
  }

  Map<String, List<BrnPickerEntity>> getCurrentSelectionEntityParams(
      BrnPickerEntity selectionEntity,
      {bool includeUnlimitSelection = false}) {
    Map<String, List<BrnPickerEntity>> params = Map();
    String parentKey = selectionEntity.key ?? '';
    var selectedEntity = selectionEntity.children
        .where((BrnPickerEntity f) => f.isSelected)
        .where((BrnPickerEntity f) {
          if (includeUnlimitSelection) {
            return true;
          } else {
            return !BrunoTools.isEmpty(f.value);
          }
        })
        .map((BrnPickerEntity f) => f)
        .toList();
    List<BrnPickerEntity> selectedParams = selectedEntity;
    if (!BrunoTools.isEmpty(selectedParams) && !BrunoTools.isEmpty(parentKey)) {
      params[parentKey] = selectedParams;
    }
    return params;
  }
}
