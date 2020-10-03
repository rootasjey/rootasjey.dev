import 'package:flutter/material.dart';
import 'package:github/github.dart';
import 'package:rootasjey/components/activity_row.dart';
import 'package:rootasjey/components/footer.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/components/sliver_empty_view.dart';

class Activities extends StatefulWidget {
  @override
  _ActivitiesState createState() => _ActivitiesState();
}

class _ActivitiesState extends State<Activities> {
  bool isLoading  = false;

  final largeHorizPadding = 90.0;
  final narrowHorizPadding = 20.0;

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

          SliverLayoutBuilder(
            builder: (context, constraints) {
              final padding = constraints.crossAxisExtent < 700.0
                ? narrowHorizPadding
                : largeHorizPadding;

              return SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: padding,
                      vertical: 90.0,
                    ),
                    child: headerTitle(),
                  ),
                ]),
              );
            },
          ),

          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < 700.0
                ? narrowHorizPadding
                : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: padding,
                ),
                sliver: body(),
              );
            },
          ),

          SliverLayoutBuilder(
            builder: (_, constraints) {
              final padding = constraints.crossAxisExtent < 700.0
                ? narrowHorizPadding
                : largeHorizPadding;

              return SliverPadding(
                padding: EdgeInsets.only(
                  left: padding,
                  right: padding,
                  top: 50.0,
                  bottom: 200.0,
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
              );
            },
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
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.arrow_back),
          ),
        ),

        Expanded(
          child: Text(
            'Activities',
            style: TextStyle(
              fontSize: 70.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        if (isLoading)
          Padding(
            padding: const EdgeInsets.only(top: 12.0, left: 22.0),
            child: CircularProgressIndicator(),
          ),
      ],
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
