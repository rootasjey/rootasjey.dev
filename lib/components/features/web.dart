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
      'label': 'Domain name',
      'description': 'Your website address (e.g. https://myawesomesite.com) will be bought for you, if available.',
      'icon': Icon(Icons.domain_verification, color: Colors.grey,),
    },

    {
      'label': 'Website development',
      'description': 'Your website will be handfully crafted to meet your requirements.',
      'icon': Icon(Icons.developer_board, color: Colors.grey,),
    },

    {
      'label': 'Design integration',
      'description': 'If you already have a design template or specifications, they will perfectly be integrated.',
      'icon': Icon(Icons.design_services, color: Colors.grey,),
    },

    {
      'label': 'Responsive layout',
      'description': 'Your website will be beautiful on desktop, tablet and mobile. We will make sure the presentation is perfect.',
      'icon': Icon(Icons.devices, color: Colors.grey,),
    },

    {
      'label': 'Deployment',
      'description': "Your site will be globally accessible through a robust & fast pipeline. Also upgrades will be done with no downtime and your website won't experience cold start.",
      'icon': Icon(Icons.storage, color: Colors.grey,),
    },

    {
      'label': 'Security checks',
      'description': 'Delivered with full HTTPS encryption & vulnerabilities checks.',
      'icon': Icon(Icons.security, color: Colors.grey,),
    },

    {
      'label': 'Scaling',
      'description': "Your site is robust and doesn't crash when you've connection spike.",
      'icon': Icon(Icons.trending_up, color: Colors.grey,),
    },

    {
      'label': 'Upgrade',
      'description': "Whenever a bug is detected or a more recent dependency is available, we'll upgrade your website.",
      'icon': Icon(Icons.upgrade, color: Colors.grey,),
    },

    {
      'label': 'Analytics',
      'description': "You will have metrics on your website. How many users visit each day? How long they stay?",
      'icon': Icon(Icons.analytics, color: Colors.grey,),
    },

    {
      'label': 'Personalized advices',
      'description': "We're avaiable for any question or asistance. You can contact us by email, phone or direct message.",
      'icon': Icon(Icons.speaker_notes, color: Colors.grey,),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return widget.layout == FeaturesLayout.table
      ? tableLayout()
      : wrapLayout();
  }

  Widget tableLayout() {
    return Padding(
      padding: widget.padding,
      child: DataTable(
        columns: const [
          DataColumn(
            label: Text(
              'Features',
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
            icon: data.containsKey('icon') ? data['icon']: null,
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
        ? OutlineButton.icon(
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
        : OutlineButton(
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
    return DataRow(
      cells: [
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
          ),
          onTap: () {
            showDescriptionDialog(
              label: label,
              description: description,
            );
          }
        ),
      ]
    );
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
