import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/components/activity_row.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/rooter/router.dart';
import 'package:rootasjey/state/colors.dart';

class RecentActivities extends StatefulWidget {
  @override
  _RecentActivitiesState createState() => _RecentActivitiesState();
}

class _RecentActivitiesState extends State<RecentActivities> {
  List<Event> userActivities = [];

  @override
  initState() {
    super.initState();
    fetchActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 100.0,
        vertical: 20.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 12.0,
            ),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: TextButton.icon(
                    onPressed: () =>
                      FluroRouter.router.navigateTo(context, ActivitiesRoute),
                    icon: Icon(
                      Icons.watch_later,
                      color: stateColors.foreground,
                    ),
                    label: Text(
                      'RECENT ACTIVITY',
                      style: TextStyle(
                        fontSize: 20.0,
                        color: stateColors.foreground,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: userActivities.map((activity) {
              return ActivityRow(activity: activity);
            }).toList(),
          ),
        ],
      ),
    );
  }

  void fetchActivity() async {
    try {
      final github = GitHub();

      github.activity.listPublicEventsPerformedByUser('rootasjey')
        .take(3)
        .toList()
        .then((activities) {
          setState(() {
            userActivities = activities;
          });
        });

    } catch (error) {
      debugPrint(error.toString());
    }
  }
}
