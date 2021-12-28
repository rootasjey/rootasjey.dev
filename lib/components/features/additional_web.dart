import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:supercharged/supercharged.dart';

class WebAdditionalFeatures extends StatefulWidget {
  final Function? onSelectionChanged;
  final EdgeInsets padding;

  WebAdditionalFeatures({
    this.onSelectionChanged,
    this.padding = EdgeInsets.zero,
  });

  @override
  _WebAdditionalFeaturesState createState() => _WebAdditionalFeaturesState();
}

class _WebAdditionalFeaturesState extends State<WebAdditionalFeatures> {
  int countSelected = 0;
  double? additionalCost = 0;
  double? maxCost;

  final featuresDataList = [
    {
      'label': "design_creation".tr(),
      'description': "design_creation_description".tr(),
      'cost': 1500,
      'selected': false,
    },
    {
      'label': "member_gestion".tr(),
      'description': "member_gestion_description".tr(),
      'cost': 500,
      'selected': false,
    },
    {
      'label': "payments".tr(),
      'description': "payments_description".tr(),
      'cost': 2000,
      'selected': false,
    },
    {
      'label': "language_localization".tr(),
      'description': "language_localization_description".tr(),
      'cost': 500,
      'selected': false,
    },
    {
      'label': "extra".tr(),
      'description': "extra_description".tr(),
      'cost': 0,
      'selected': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    maxCost = featuresDataList.sumByDouble((feature) => feature['cost'] as num);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: widget.padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 40.0,
            ),
            child: Wrap(
                spacing: 20.0,
                runSpacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.end,
                children: [
                  Text(
                    '$countSelected',
                    style: TextStyle(
                      fontSize: 70.0,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    "additional_features_selected".plural(countSelected),
                    style: TextStyle(
                      fontSize: 30.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                ]),
          ),
          if (countSelected > 0)
            SizedBox(
              width: 600.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () {
                      featuresDataList.forEach((dataFeature) {
                        dataFeature['selected'] = false;
                      });

                      setState(() {
                        countSelected = 0;
                      });
                    },
                    icon: Icon(Icons.clear_all),
                    label: Opacity(
                      opacity: 0.6,
                      child: Text("clear".tr()),
                    ),
                  ),
                ],
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: featuresDataList.mapIndexed((index, data) {
              return featureCard(
                index: index,
                label: data['label'] as String?,
                description: data['description'] as String?,
                selected: data['selected'] as bool?,
                cost: data['cost'] as double?,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget featureCard({
    String? label,
    String? description,
    bool? selected = false,
    double? cost = 0,
    int index = 0,
  }) {
    final Color foregroundColor =
        Theme.of(context).textTheme.bodyText1?.color ?? Colors.black;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16.0,
      ),
      child: Card(
        elevation: selected! ? 4.0 : 0.0,
        color: selected
            ? Globals.constants.colors.primary
            : Theme.of(context).cardTheme.color,
        child: InkWell(
          onTap: () {
            if (selected) {
              countSelected = countSelected == 0 ? 0 : countSelected - 1;

              additionalCost =
                  additionalCost! > 0 ? additionalCost! - cost! : 0;
            } else {
              countSelected = countSelected == featuresDataList.length
                  ? featuresDataList.length
                  : countSelected + 1;

              additionalCost = additionalCost! < maxCost!
                  ? additionalCost! + cost!
                  : maxCost;
            }

            setState(() {
              featuresDataList[index]['selected'] = !selected;
            });

            if (widget.onSelectionChanged != null) {
              final allSelected = featuresDataList
                  .filter((feature) => feature['selected'] as bool)
                  .toList();

              widget.onSelectionChanged!(additionalCost, allSelected);
            }
          },
          child: Container(
            width: 600.0,
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Opacity(
                        opacity: 1,
                        child: Text(
                          label!,
                          style: TextStyle(
                            color: selected
                                ? Colors.white
                                : foregroundColor.withOpacity(0.6),
                            fontSize: 22.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8.0,
                        ),
                        child: Opacity(
                          opacity: 0.6,
                          child: Text(
                            description!,
                            style: TextStyle(
                              color: selected ? Colors.white : foregroundColor,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Opacity(
                    opacity: 0.6,
                    child: Icon(
                      Icons.check_circle_outline,
                      size: 30.0,
                      color: selected ? Colors.white : foregroundColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
