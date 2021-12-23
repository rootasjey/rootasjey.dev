import 'dart:typed_data';
import 'package:beamer/beamer.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rootasjey/components/avatar/better_avatar.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/exp.dart';
import 'package:rootasjey/types/exp_date.dart';
import 'package:rootasjey/types/formation.dart';
import 'package:rootasjey/types/project.dart';
import 'package:rootasjey/types/skill.dart';
import 'package:rootasjey/types/urls.dart';
import 'package:rootasjey/utils/fonts.dart';
import 'package:screenshot/screenshot.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class CVPage extends StatefulWidget {
  @override
  _CVPageState createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  final exps = [
    Exp(
      job: "Entrepreneur",
      company: "Jeremie Codes",
      url: "https://rootasjey.dev",
      date: ExpDate(
        end: "Aujourd'hui",
        start: "Octobre 2019",
      ),
      tasks: [
        "- Développement d'applications multiplateforme (iOS, Android) avec Flutter",
        "- Gestion de base de données Firestore avec ses règles d'accès",
        "- Déploiement d'APIs à l'aide de fonctions cloud",
        "- Utilisation de CI/CD",
      ],
    ),
    Exp(
      job: "Architecte logiciel",
      company: "Fabernovel technologies",
      url: "https://www.fabernovel.com",
      date: ExpDate(
        start: "Mai 2019",
        end: "Juin 2019",
      ),
      tasks: [
        "- Programmation fonctionnelle avec Kaiju, Abyssa, Spacelift",
        "- Méthode agile (scrum), Revue de code, Pair programming",
      ],
    ),
    Exp(
      job: "Développeur frontend",
      company: "Dassault Systèmes",
      url: "https://3ds.com",
      date: ExpDate(
        end: "2019",
        start: "2015",
      ),
      tasks: [
        "- Développement frontend en JavaScript vanilla (Object pattern)",
        "- Tests unitaires, d'intégration, end-to-end (Karma.js, Intern.js)",
        "- Ecriture de spécifications UX + Collaboration avec équipe UX",
      ],
    ),
  ];

  final formations = [
    Formation(
      degree: "Licence & Master d'informatique",
      school: "Université de Versailles",
      date: ExpDate(start: "2010", end: "2015"),
      tasks: [
        "- Design patterns (Observer, Composition, Factory)",
        "- Algorithmique (problème du voyageur, théorie des graphes)",
        "- Cryptographie et sécurité web",
        "- Développement backend J2EE (Spring) & Python (Flask)",
        "- Data mining & intégration de données (BDD musicale)",
      ],
      url: "https://uvsq.fr",
    ),
  ];

  Uint8List _imageFile;
  final screenshotController = ScreenshotController();

  final projects = [
    Project(
      id: "fig.style",
      title: "fig.style",
      summary: "App de citations open-source et communautaire."
          " Recevez une notification chaque jour sur votre téléphone."
          " Recherchez par mots-clés ou par catégories.",
      platforms: ["iOS", "Android", "Web", "API"],
      urls: Urls(
        github: "https://github.com/rootasjey/fig.style",
        image: "assets/images/figstyle.png",
      ),
    ),
    Project(
      id: "Relines",
      title: "Relines",
      summary: "Mini-jeu de citations où vous devez devinder l'auteur"
          " ou la référence d'une citation.",
      platforms: ['iOS', 'Android', 'Web'],
      urls: Urls(
        github: "https://github.com/rootasjey/relines",
        image: "assets/images/relines.png",
      ),
    ),
    Project(
      id: "Lumi",
      title: "Lumi",
      summary: "Contrôlez vos ampoules & capteurs Philips Hue.",
      platforms: [
        'macOS',
      ],
      urls: Urls(
        github: "https://github.com/rootasjey/lumi",
      ),
    ),
  ];

  final skills = [
    Skill(
      label: "Firebase",
      assetPath: "assets/images/firebase.png",
      url: "https://firebase.com",
    ),
    Skill(
      label: "Flutter",
      assetPath: "assets/images/flutter.png",
      url: "https://flutter.dev",
      blend: true,
    ),
    Skill(
      label: "JavaScript",
      iconData: FontAwesomeIcons.js,
      url: "https://javascript.com",
    ),
    Skill(
      label: "node.JS",
      iconData: FontAwesomeIcons.nodeJs,
      url: "https://nodejs.com",
    ),
    Skill(
      label: "Python",
      iconData: FontAwesomeIcons.python,
      url: "https://python.org",
    ),
    Skill(
      label: "Vue.JS",
      iconData: FontAwesomeIcons.vuejs,
      url: "https://vuejs.org",
    ),
    Skill(
      label: "React.JS",
      iconData: FontAwesomeIcons.react,
      url: "https://reactjs.com",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainAppBar(
            trailing: [
              Observer(builder: (_) {
                return IconButton(
                  onPressed: () async {
                    _imageFile = await screenshotController.capture();
                    await FileSaver.instance.saveFile("cv", _imageFile, "png");
                  },
                  icon: Icon(UniconsLine.camera, color: stateColors.foreground),
                );
              }),
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Screenshot(
                controller: screenshotController,
                child: body(),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Observer(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              aboutMeSummary(),
              skillsBlock(),
              allExperiences(),
            ],
          ),
        );
      },
    );
  }

  Widget allExperiences() {
    return Padding(
      padding: const EdgeInsets.only(top: 54.0),
      child: Wrap(
        spacing: 40.0,
        runSpacing: 40.0,
        children: [
          experiencesBlock(),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              formationBlock(),
              projectsBlock(),
            ],
          ),
        ],
      ),
    );
  }

  Widget header() {
    return Wrap(
      spacing: 60.0,
      children: [
        BetterAvatar(
          image: AssetImage(
            'assets/images/jeje.jpg',
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  children: [
                    InkWell(
                      onTap: Beamer.of(context).beamBack,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/images/jeje.jpg',
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Jérémie CORPINOT",
              style: FontsUtils.mainStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "alias rootasjey",
                style: FontsUtils.mainStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  "Développeur fullstack",
                  style: FontsUtils.mainStyle(
                    fontSize: 28.0,
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "Yvelines, France",
                style: FontsUtils.mainStyle(
                  fontSize: 20.0,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "jeremie@rootasjey.dev",
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
            Opacity(
              opacity: 0.6,
              child: Text(
                "https://rootasjey.dev",
                style: FontsUtils.mainStyle(
                  fontSize: 16.0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget aboutMeSummary() {
    return Container(
      width: 600.0,
      padding: const EdgeInsets.only(top: 54.0),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          "Passionné par le développement et les nouvelles technologies, "
          "j'attribue une place particulière à l'expérience utilisateur. "
          "Je sais m'adapter et je contribue régulièrement à des projets open-source. "
          "J'ai un tempérament curieux et un attrait pour l'art, "
          "la musique, et les jeux-vidéo. Entre autres.",
          style: FontsUtils.mainStyle(
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }

  Widget skillsBlock() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Wrap(
        spacing: 32.0,
        children: skills.map((skill) {
          return skillItem(
            label: skill.label,
            assetPath: skill.assetPath,
            iconData: skill.iconData,
            url: skill.url,
            blend: skill.blend,
          );
        }).toList(),
      ),
    );
  }

  Widget skillItem({
    @required String label,
    String url,
    String assetPath,
    IconData iconData,
    bool blend = false,
  }) {
    return InkWell(
      key: Key(label),
      onTap: () {
        if (url == null || url.isEmpty) {
          return;
        }

        launch(url);
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            if (assetPath != null && assetPath.isNotEmpty)
              Image.asset(
                assetPath,
                width: 30.0,
                height: 30.0,
                color: blend ? stateColors.foreground : null,
              ),
            if (iconData != null) Icon(iconData, size: 32.0),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Opacity(opacity: 0.8, child: Text(label)),
            ),
          ],
        ),
      ),
    );
  }

  Widget experiencesBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(UniconsLine.briefcase),
                ),
                Text(
                  "Expériences Professionnelles",
                  style: FontsUtils.mainStyle(
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
        ),
        expsListView(),
      ],
    );
  }

  Widget expsListView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: exps.map((exp) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exp.job,
                style: FontsUtils.mainStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: InkWell(
                  onTap: () {
                    if (exp.url == null || exp.url.isEmpty) {
                      return;
                    }

                    launch(exp.url);
                  },
                  child: Text(
                    exp.company,
                    style: FontsUtils.mainStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  "${exp.date.start} - ${exp.date.end}",
                  style: FontsUtils.mainStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Opacity(
                  opacity: 0.6,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: exp.tasks.map((task) => Text(task)).toList(),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget formationBlock() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Opacity(
          opacity: 0.8,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12.0),
                child: Icon(UniconsLine.university),
              ),
              Text(
                "Formation",
                style: FontsUtils.mainStyle(
                  fontSize: 24.0,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: formations.map((formation) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formation.degree,
                    style: FontsUtils.mainStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Opacity(opacity: 0.8, child: Text(formation.school)),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Opacity(
                      opacity: 0.5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:
                            formation.tasks.map((task) => Text(task)).toList(),
                      ),
                    ),
                  )
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget projectsBlock() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Opacity(
            opacity: 0.8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: Icon(UniconsLine.rocket),
                ),
                Text(
                  "Projects",
                  style: FontsUtils.mainStyle(
                    fontSize: 24.0,
                  ),
                ),
              ],
            ),
          ),
          projectsListView(),
        ],
      ),
    );
  }

  Widget projectsListView() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: projects.map((project) {
          return Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: () {
                        if (project.urls.github.isEmpty) {
                          return;
                        }

                        launch(project.urls.github);
                      },
                      child: Text(
                        project.title,
                        style: FontsUtils.mainStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Opacity(
                        opacity: 0.5,
                        child: Wrap(
                          spacing: 8.0,
                          children: project.platforms
                              .map((platform) => Text(platform))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400.0,
                      child: Opacity(
                        opacity: 0.8,
                        child: Text(project.summary),
                      ),
                    ),
                  ],
                ),
                if (project.urls.image.isNotEmpty)
                  Image.asset(
                    project.urls.image,
                    width: 60.0,
                    height: 60.0,
                  ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
