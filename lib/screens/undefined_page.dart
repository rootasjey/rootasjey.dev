import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/app_icon_header.dart';
import 'package:rootasjey/router/locations/home_location.dart';

class UndefinedPage extends StatefulWidget {
  UndefinedPage();

  @override
  _UndefinedPageState createState() => _UndefinedPageState();
}

class _UndefinedPageState extends State<UndefinedPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        AppIconHeader(),
        Text(
          '404',
          style: TextStyle(
            fontSize: 80.0,
          ),
        ),
        Opacity(
          opacity: .6,
          child: Text(
            "route_undefined".tr(
              args: [Beamer.of(context).currentPages.last.name],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: Image(
            image: AssetImage('assets/images/page-not-found-4.png'),
            width: 350.0,
            height: 350.0,
          ),
        ),
        Padding(padding: EdgeInsets.only(bottom: 100.0)),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            child: Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.all(60.0),
                  child: Column(
                    children: <Widget>[
                      Opacity(
                        opacity: .8,
                        child: Text(
                          "route_undefined_quote".tr(),
                          style: TextStyle(
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 100.0,
                        child: Divider(
                          height: 50.0,
                          thickness: 1.0,
                        ),
                      ),
                      Opacity(
                        opacity: .6,
                        child: Text('fig.style'),
                      ),
                    ],
                  ),
                )),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100.0),
          child: TextButton(
            onPressed: () {
              Beamer.of(context).beamToNamed(HomeLocation.route);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("back_home".tr()),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 300.0),
        ),
      ],
    );
  }
}
