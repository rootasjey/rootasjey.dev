import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:supercharged/supercharged.dart';

class WebAdditionalFeatures extends StatefulWidget {
  final Function onSelectionChanged;
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
  double additionalCost = 0;
  double maxCost;

  final featuresDataList = [
    {
      'label': 'Design creation',
      'description': "We will craft a personalized design for you.",
      'cost': 1500,
      'selected': false,
    },

    {
      'label': 'Members gestion',
      'description': "Create a section members so your customers can sign up & login.",
      'cost': 500,
      'selected': false,
    },

    {
      'label': 'Payments',
      'description': 'Allow customers to purchase goods and subscribe to recurring payments.',
      'cost': 2000,
      'selected': false,
    },

    {
      'label': 'Language localization',
      'description': 'Make your website available in several languages.',
      'cost': 500,
      'selected': false,
    },

    {
      'label': 'Extra',
      'description': 'You need extra features no listed here.',
      'cost': 0,
      'selected': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    maxCost = featuresDataList
      .sumByDouble((feature) => feature['cost']);
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
                  'additional ${countSelected > 1 ? 'features' : 'feature'} selected',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ]
            ),
          ),

          if (countSelected > 0)
            SizedBox(
              width: 600.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                    FlatButton.icon(
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
                        child: Text('Clear'),
                      ),
                    ),
                ],
              ),
            ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: featuresDataList.mapIndexed((data, index) {
              return featureCard(
                index: index,
                label: data['label'],
                description: data['description'],
                selected: data['selected'],
                cost: data['cost'],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget featureCard({
    String label,
    String description,
    bool selected = false,
    double cost = 0,
    int index = 0,
  }) {

    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
            bottom: 16.0,
          ),
          child: Card(
            elevation: selected
              ? 4.0
              : 0.0,
            color: selected
              ? stateColors.primary
              : stateColors.themeData.cardColor,
            child: InkWell(
              onTap: () {
                if (selected) {
                  countSelected = countSelected == 0
                    ? 0
                    : countSelected - 1;

                  additionalCost = additionalCost > 0
                    ? additionalCost - cost
                    : 0;

                } else {
                  countSelected = countSelected == featuresDataList.length
                    ? featuresDataList.length
                    : countSelected + 1;

                  additionalCost = additionalCost < maxCost
                    ? additionalCost + cost
                    : maxCost;
                }

                setState(() {
                  featuresDataList[index]['selected'] = !selected;
                });

                if (widget.onSelectionChanged != null) {
                  final allSelected = featuresDataList
                    .filter((feature) => feature['selected'])
                    .toList();

                  widget.onSelectionChanged(additionalCost, allSelected);
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
                              label,
                              style: TextStyle(
                                color: selected
                                  ? Colors.white
                                  : stateColors.foreground.withOpacity(0.6),
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
                                description,
                                style: TextStyle(
                                  color: selected
                                    ? Colors.white
                                    : stateColors.foreground,
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
                          color: selected
                            ? Colors.white
                            : stateColors.foreground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
