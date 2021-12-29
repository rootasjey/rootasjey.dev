import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/project_card/project_card.dart';
import 'package:rootasjey/router/locations/projects_location.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/hero_project_card_data.dart';
import 'package:rootasjey/types/position.dart';

class RightSide extends StatelessWidget {
  const RightSide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Globals.utils.size.isMobileSize(context)) {
      return Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Center(
          child: Wrap(
            spacing: 20.0,
            runSpacing: 20.0,
            alignment: WrapAlignment.start,
            children: getProjectsData().map((itemData) {
              return ProjectCard(
                backgroundUri: itemData.backgroundUri,
                titleValue: itemData.textValue,
                onTap: () => Beamer.of(context).beamToNamed(itemData.routePath),
              );
            }).toList(),
          ),
        ),
      );
    }

    int index = -1;

    return SizedBox(
      width: 320.0,
      height: 600.0,
      child: Stack(
        children: getProjectsData().map((itemData) {
          index++;

          return Positioned(
            top: getCardPositions().elementAt(index).top,
            left: getCardPositions().elementAt(index).left,
            child: ProjectCard(
              bottomTitle: true,
              height: getCardSizes().elementAt(index).height,
              width: getCardSizes().elementAt(index).width,
              backgroundUri: itemData.backgroundUri,
              titleValue: itemData.textValue,
              onTap: () => Beamer.of(context).beamToNamed(itemData.routePath),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<Position> getCardPositions() {
    return [
      Position(top: 0, left: 0),
      Position(top: 0, left: 160),
      Position(top: 160, left: 0),
      Position(top: 310, left: 160),
    ];
  }

  List<Size> getCardSizes() {
    return [
      Size(150.0, 150.0),
      Size(150.0, 300.0),
      Size(150.0, 300.0),
      Size(150.0, 150.0),
    ];
  }

  List<HeroProjectCardData> getProjectsData() {
    return [
      HeroProjectCardData(
        textValue: "fig.style",
        backgroundUri: "https://firebasestorage.googleapis.com/v0/b/"
            "rootasjey.appspot.com/o/images%2Ftemp%2Ffig-xs.jpg"
            "?alt=media&token=ca59ece7-4fd9-4997-b482-c2976549665f",
        routePath: "${ProjectsLocation.route}/iFbUM2GPOKmWG27Kc5gR",
      ),
      HeroProjectCardData(
        textValue: "artbooking",
        backgroundUri: "https://firebasestorage.googleapis.com/v0/b/"
            "rootasjey.appspot.com/o/images%2Ftemp%2Fartbooking-xs.png"
            "?alt=media&token=5f52d86e-7b22-448c-b9c6-c535671eee64",
        routePath: "${ProjectsLocation.route}/7xE6Cy7NTkJG5UXYJg31",
      ),
      HeroProjectCardData(
        textValue: "feels",
        backgroundUri: "https://firebasestorage.googleapis.com/v0/b/"
            "rootasjey.appspot.com/o/images%2Ftemp%2Fweather.jpg"
            "?alt=media&token=c2303046-c105-498b-a664-bc1c9d8dcdf8",
        routePath: "${ProjectsLocation.route}/7xE6Cy7NTkJG5UXYJg31",
      ),
      HeroProjectCardData(
        textValue: "conway",
        backgroundUri: "https://firebasestorage.googleapis.com/v0/b/"
            "rootasjey.appspot.com/o/images%2Ftemp%2Fconway.png?"
            "alt=media&token=3cb34b33-8926-4c77-bdbe-ed3c56859306",
        routePath: "${ProjectsLocation.route}/2xMulgUe19Xd7caBGoN1",
      ),
    ];
  }
}
