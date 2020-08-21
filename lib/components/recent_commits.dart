import 'package:flutter/material.dart';
import 'package:rootasjey/state/colors.dart';

class RecentCommits extends StatefulWidget {
  @override
  _RecentCommitsState createState() => _RecentCommitsState();
}

class _RecentCommitsState extends State<RecentCommits> {
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
            padding: const EdgeInsets.only(left: 12.0),
            child: Row(
              children: [
                Opacity(
                  opacity: 0.6,
                  child: Text(
                    'RECENT ACTIVITY',
                    // 'Recent activity',
                    style: TextStyle(
                      fontSize: 20.0,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.arrow_forward),
                )
              ],
            ),
          ),

          Row(
            children: [
              FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.code, color: stateColors.primary,),
                label: Text(
                  'Created a new repository: rootasjey.dev',
                ),
              ),

              Text(
                'TODAY',
                style: TextStyle(
                  color: stateColors.primary,
                ),
              ),
            ],
          ),

          Row(
            children: [

              FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.code, color: stateColors.primary,),
                label: Text(
                  'Committed "Fix issue on Out Of Context"',
                ),
              ),
              Text(
                'YESTERDAY',
                style: TextStyle(
                  color: stateColors.primary,
                ),
              ),
            ],
          ),

          Row(
            children: [
              FlatButton.icon(
                onPressed: () {},
                icon: Icon(Icons.code, color: stateColors.primary,),
                label: Text(
                  'Deployed a new web version',
                ),
              ),
              Text(
                '4 DAYS AGO',
                style: TextStyle(
                  color: stateColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
