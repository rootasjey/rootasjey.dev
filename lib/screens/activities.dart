import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/components/activity_row.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';
import 'package:rootasjey/router//router.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  bool isLoading  = false;
  int skipResults = 0;
  int limit       = 10;
  int skipIncr    = 0;

  List<Event> userActivities = [];
  final username = 'rootasjey';
  final github = GitHub();

  @override
  initState() {
    super.initState();

    skipIncr = limit;
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          HomeAppBar(),

          SliverList(
            delegate: SliverChildListDelegate([
              headerTitle(),
            ]),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(
              left: 90.0,
            ),
            sliver: body(),
          ),

          SliverPadding(
            padding: const EdgeInsets.only(
              left: 90.0,
              top: 50.0,
              bottom: 300.0,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                if (!isLoading)
                isLoading
                  ? CircularProgressIndicator()
                  : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () {
                          skipResults += skipIncr;
                          fetch(skip: skipResults);
                        },
                        icon: Icon(Icons.arrow_downward),
                        label: Text(
                          'Load more'
                        ),
                      ),
                    ],
                  ),
              ]),
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              Footer(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget activitiesListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final activity = userActivities.elementAt(index);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ActivityRow(activity: activity),
            ],
          );
        },
        childCount: userActivities.length,
      ),
    );
  }

  Widget body() {
    if (!isLoading && userActivities.isEmpty) {
      return SliverEmptyView(
        title: "There's on activity for this user right now.",
      );
    }

    return activitiesListView();
  }

  Widget headerTitle() {
    return Padding(
      padding: const EdgeInsets.all(
        90.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: () => FluroRouter.router.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),

          Text(
            'Activities',
            style: TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
            ),
          ),

          if (isLoading)
            Padding(
              padding: const EdgeInsets.only(top: 12.0, left: 22.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  void fetch({int skip = 0}) async {
    setState(() => isLoading = true);

    try {
      github.activity
        .listPublicEventsPerformedByUser(username)
        .skip(skip)
        .take(limit)
        .toList()
        .then((activities) {
          setState(() {
            userActivities.addAll(activities);
            isLoading = false;
          });
        });

    } catch (error) {
      debugPrint(error.toString());
      setState(() => isLoading = false);
    }
  }
}
