import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/types/enums.dart';

class WebFeatures extends StatefulWidget {
  final EdgeInsets padding;
  final FeaturesLayout layout;

  WebFeatures({
    this.padding = EdgeInsets.zero,
    this.layout = FeaturesLayout.table,
  });

  @override
  _WebFeaturesState createState() => _WebFeaturesState();
}

class _WebFeaturesState extends State<WebFeatures> {
  final featuresDataList = [
    {
      'label': "domain_name".tr(),
      'description': "domain_name_description".tr(),
      'icon': Icon(
        Icons.domain_verification,
        color: Colors.grey,
      ),
    },
    {
      'label': "website_dev".tr(),
      'description': "website_dev_description".tr(),
      'icon': Icon(
        Icons.developer_board,
        color: Colors.grey,
      ),
    },
    {
      'label': "design_integration".tr(),
      'description': "design_integration_description".tr(),
      'icon': Icon(
        Icons.design_services,
        color: Colors.grey,
      ),
    },
    {
      'label': "responsive_layout".tr(),
      'description': "responsive_layout_description".tr(),
      'icon': Icon(
        Icons.devices,
        color: Colors.grey,
      ),
    },
    {
      'label': "deployment".tr(),
      'description': "deployment_description".tr(),
      'icon': Icon(
        Icons.storage,
        color: Colors.grey,
      ),
    },
    {
      'label': "security_checks".tr(),
      'description': "security_checks_description".tr(),
      'icon': Icon(
        Icons.security,
        color: Colors.grey,
      ),
    },
    {
      'label': "scaling".tr(),
      'description': "scaling_description".tr(),
      'icon': Icon(
        Icons.trending_up,
        color: Colors.grey,
      ),
    },
    {
      'label': "upgrade".tr(),
      'description': "upgrade_description".tr(),
      'icon': Icon(
        Icons.upgrade,
        color: Colors.grey,
      ),
    },
    {
      'label': "analytics".tr(),
      'description': "analytics_description".tr(),
      'icon': Icon(
        Icons.analytics,
        color: Colors.grey,
      ),
    },
    {
      'label': "advices_personalized".tr(),
      'description': "advices_personalized_description".tr(),
      'icon': Icon(
        Icons.speaker_notes,
        color: Colors.grey,
      ),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return widget.layout == FeaturesLayout.table ? tableLayout() : wrapLayout();
  }

  Widget tableLayout() {
    return Padding(
      padding: widget.padding,
      child: DataTable(
        columns: [
          DataColumn(
            label: Text(
              "features".tr(),
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
        ],
        rows: featuresDataList.map((data) {
          return featureRow(
            label: data['label'],
            description: data['description'],
          );
        }).toList(),
      ),
    );
  }

  Widget wrapLayout() {
    return Padding(
      padding: widget.padding,
      child: Wrap(
        spacing: 10.0,
        runSpacing: 10.0,
        children: featuresDataList.map((data) {
          return featureButton(
            label: data['label'],
            description: data['description'],
            icon: data.containsKey('icon') ? data['icon'] : null,
          );
        }).toList(),
      ),
    );
  }

  Widget featureButton({
    String label,
    String description,
    Widget icon,
  }) {
    return Tooltip(
      message: description,
      child: icon != null
          ? OutlinedButton.icon(
              onPressed: () {
                showDescriptionDialog(
                  label: label,
                  description: description,
                );
              },
              icon: icon,
              label: Opacity(
                opacity: 0.6,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            )
          : OutlinedButton(
              onPressed: () {
                showDescriptionDialog(
                  label: label,
                  description: description,
                );
              },
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                  ),
                ),
              ),
            ),
    );
  }

  DataRow featureRow({String label, String description}) {
    return DataRow(cells: [
      DataCell(
          Tooltip(
            message: description,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(Icons.check),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ), onTap: () {
        showDescriptionDialog(
          label: label,
          description: description,
        );
      }),
    ]);
  }

  void showDescriptionDialog({String label, String description}) {
    showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: Opacity(
            opacity: 0.8,
            child: Text(
              label,
            ),
          ),
          children: <Widget>[
            Container(
              width: 400.0,
              padding: const EdgeInsets.only(
                left: 25.0,
                right: 25.0,
              ),
              child: Opacity(
                opacity: 0.6,
                child: Text(
                  description,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
