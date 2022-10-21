import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/router/locations/home_location.dart';
import 'package:unicons/unicons.dart';

class UndefinedPage extends StatefulWidget {
  const UndefinedPage({super.key});

  @override
  State<StatefulWidget> createState() => _UndefinedPageState();
}

class _UndefinedPageState extends State<UndefinedPage> {
  @override
  Widget build(BuildContext context) {
    String location = '';
    final int length = context.beamingHistory.length;

    if (length > 1) {
      final beamLocation = context.beamingHistory.elementAt(length - 2);
      location = beamLocation.state.routeInformation.location ?? "";
    }

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Column(
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 60.0, bottom: 8.0),
                    child: Text(
                      '404',
                      style: TextStyle(
                        fontSize: 120.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: 0.6,
                    child: RichText(
                      text: TextSpan(
                        text: "undefined_page_route_prefix".tr(),
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700,
                          color: Theme.of(context).textTheme.bodyText1?.color,
                        ),
                        children: [
                          TextSpan(
                            text: location,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).secondaryHeaderColor,
                            ),
                          ),
                          TextSpan(
                            text: "undefined_page_route_suffix".tr(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20.0, bottom: 12.0),
                    child: Icon(
                      UniconsLine.car_sideview,
                      size: 40.0,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 24.0),
                    child: ElevatedButton(
                      onPressed: () => context.beamToNamed(HomeLocation.route),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text("undefined_page_get_back".tr()),
                      ),
                    ),
                  ),
                  Container(
                    width: 400.0,
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 8.0,
                      right: 8.0,
                      bottom: 300,
                    ),
                    child: Card(
                        elevation: 4.0,
                        color: Theme.of(context).backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: <Widget>[
                              Opacity(
                                opacity: 0.8,
                                child: Text(
                                  "undefined_page_quote".tr(),
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
