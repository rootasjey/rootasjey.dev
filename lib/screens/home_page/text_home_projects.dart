import 'package:flutter/material.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/types/cover.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:rootasjey/types/social_links.dart';
import 'package:url_launcher/url_launcher.dart';

class TextHomeProjects extends StatefulWidget {
  const TextHomeProjects({
    super.key,
    this.backgroundColor = Colors.transparent,
  });

  final Color backgroundColor;

  @override
  State<TextHomeProjects> createState() => _TextHomeProjectsState();
}

class _TextHomeProjectsState extends State<TextHomeProjects> {
  final List<Project> _projects = [
    Project(
      id: "kwotes",
      name: "kwotes",
      summary:
          "I created this project because first of all I love quotes, then I didn't find an app or service having the same proposition value of kwotes, including:"
          "a multiplatform app, a modern and elegant interface, source diversity (e.g. movies), open to contribution.",
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      projectCreatedAt: DateTime.parse("2024-05-03"),
      cover: const Cover(
        originalUrl:
            "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fkwotes-store-4-screens-bg-beige.jpg?alt=media&token=dea64a7d-ca9b-471a-8a78-2764e0c844d6",
      ),
      socialLinks: SocialLinks(
        website: "https://kwotes.fr",
        github: "https://github.com/rootasjey/kwotes",
      ),
    ),
    Project(
      id: "unsplasharp",
      name: "unsplasharp",
      summary:
          "Unofficial C# wrapper around Unsplash API targeting .NET Standard 1.4."
          "This lib is compatible with .NET Core, .NET Framework 4.6.1, Xamarin (iOS, Android), Universal Windows Platform.",
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      projectCreatedAt: DateTime.parse("2020-09-03"),
      cover: const Cover(
        originalUrl:
            "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Funsplasharp-cover.jpg?alt=media&token=4a3e3bb9-eecc-4e89-94b2-bc31912e7f60",
      ),
      socialLinks: SocialLinks(
        website: "https://github.com/rootasjey/unsplasharp",
        github: "https://github.com/rootasjey/unsplasharp",
      ),
    ),
    Project(
      id: "my-health-partner",
      name: "My Health Partner",
      summary:
          "I worked as a freelance for Servier (a pharmaceutical company headquartered in France that is governed by a non-profit foundation). "
          "We developed a new platform for \"My Health Partner\" service."
          "Create a design system with component and maquette integration, working closely with the design team"
          "Create and use Strapi backend.",
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      projectCreatedAt: DateTime.parse("2022-02-01"),
      // projectCreatedAt: DateTime.parse("2021-07-01"),
      cover: const Cover(
        originalUrl:
            "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fmy-health-partner-3.jpg?alt=media&token=b3c6e171-d1f5-473e-856d-7de8c159470f",
      ),
      socialLinks: SocialLinks(
        website: "https://myhealth-partner.com",
        github: "",
      ),
    ),
    Project(
      id: "comptoirs",
      name: "Backoffice monitoring for Comptoirs",
      summary:
          "In a small team of 3 developers, we created a back office to monitor connected devices."
          "We also created & used a design system, in collaboration with the design team."
          "Finally, we used REST APIs to communicate with the devices and designed a middleware to handle them.",
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      projectCreatedAt: DateTime.parse("2023-04-01"),
      cover: const Cover(
        originalUrl:
            "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2Fcomptoirs-backoffice-monitoring.jpg?alt=media&token=774d9abc-4766-475a-a871-c025d84a9c09",
      ),
      socialLinks: SocialLinks(
        website: "https://comptoirs.co",
        github: "",
      ),
    ),
    Project(
      id: "3ds",
      name: "3DDrive (3D Experience)",
      summary:
          "At Dassault Systèmes, I developed a cloud storage web application in a team of 7 developers."
          "We integrated Google Drive & Microsoft OneDrive APIs (among others) into a single web application."
          "I also wrote technical and design specifications in collaboration with the design and QA team.",
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      projectCreatedAt: DateTime.parse("2023-04-01"),
      cover: const Cover(
        originalUrl:
            "https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Ftemp%2F3ddrive-windowed.jpg?alt=media&token=5445f84e-b68d-473c-b201-79fae0a16d70",
      ),
      socialLinks: SocialLinks(
        website:
            "https://www.solidsolutions.co.uk/blog/2019/07/3d-experience-3ddrive/",
        github: "",
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final Color? foregroundColor =
        Theme.of(context).textTheme.bodyMedium?.color;

    return SliverList.builder(
      itemBuilder: (BuildContext context, int index) {
        final Project project = _projects[index];

        return Container(
          width: 624.0,
          padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 24.0),
          child: Column(children: [
            Card(
              elevation: 4.0,
              color: widget.backgroundColor,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: SizedBox(
                width: 600.0,
                height: 400.0,
                child: Ink.image(
                  image: NetworkImage(project.cover.originalUrl),
                  fit: BoxFit.cover,
                  child: InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(project.socialLinks.website));
                    },
                  ),
                ),
              ),
            ),
            Container(
              width: 600.0,
              padding: const EdgeInsets.only(top: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    project.name,
                    style: Utils.calligraphy.title(
                      textStyle: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.w600,
                        color: foregroundColor?.withOpacity(0.8),
                      ),
                    ),
                  ),
                  Text(
                    project.summary,
                    style: Utils.calligraphy.body(
                      textStyle: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                        color: foregroundColor?.withOpacity(0.4),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ]),
        );
      },
      itemCount: _projects.length,
    );
  }
}
