import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:rootasjey/components/application_bar.dart';
import 'package:rootasjey/components/better_avatar.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/types/experience.dart';
import 'package:rootasjey/types/experience_date.dart';
import 'package:rootasjey/types/formation.dart';
import 'package:rootasjey/types/project/project.dart';
import 'package:rootasjey/types/skill.dart';
import 'package:rootasjey/types/social_links.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rootasjey/globals/utilities.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CVPage extends StatefulWidget {
  const CVPage({super.key});

  @override
  State<StatefulWidget> createState() => _CVPageState();
}

class _CVPageState extends State<CVPage> {
  final List<Experience> _exps = [
    Experience(
      job: "Développeur Web Fullstack",
      company: "Servier",
      url: "https://myhealth-partner.com/",
      date: const ExperienceDate(
        end: "Mars 2022",
        start: "Juillet 2021",
      ),
      objective: "Refonte du site web My Health Partner",
      tasks: [
        "• Unifier les développements des différents pays afin d'avoir une cohérence visuelle et fonctionnelle",
        "• Développement du front avec Next.JS et React.JS",
        "• Gestion de contenu avec Strapi",
        "• Intégration de maquettes UI/UX",
        "• Création d'un design system",
        "• Analyse et développement d'un module de recherche",
        "• Analyse de SEO",
        "• Intégration de plugin dans Strapi",
        "• Déploiement Vercel",
        "• Déploiement Microsoft Azure"
            "• DevOps, infrastructure et déploiement",
        "• Refactoring de code et architecture",
        "• Revue de code, pair programming"
      ],
    ),
    Experience(
      job: "Mentor Python & JS",
      company: "Openclassrooms",
      url: "https://openclassrooms.com",
      date: const ExperienceDate(
        end: "Février 2021",
        start: "Mai 2022",
      ),
      objective:
          "Accompagner des étudiants dans l'apprentissage de la programmation",
      tasks: [
        "• Dispensation de cours de JavaScript (front & back) et Python (front & back)",
        "• Cours sur les frameworks et technologies composant le domaine de programmation",
        "• Connaissance générale et contexte de développement (e.g. des faits sur la création d'un langage)"
            "• Établissement de planning avec l'élève",
        "• Assistance en dehors des sessions de travail pour répondre aux questions"
            "• Accompagnement hebdomadaire avec explications, exos, et projets",
        "• Pair programming/debugging avec les étudiants"
            "• Évaluation des étudiants sur leur projets",
        "• Perspectives professionnelles après la formation",
        "• Conseils et perspectives professionnelles",
        "• Revue de code, pair programming"
      ],
    ),
    Experience(
      job: "Entrepreneur",
      company: "Coding box",
      url: "https://rootasjey.dev",
      date: const ExperienceDate(
        end: "Aujourd'hui",
        start: "Octobre 2019",
      ),
      objective: "Développement d'une application de citations",
      tasks: [
        "- Développement d'applications multiplateforme (iOS, Android) avec Flutter",
        "- Gestion de base de données Firestore avec ses règles d'accès",
        "- Déploiement d'APIs à l'aide de fonctions cloud",
        "- Utilisation de CI/CD",
      ],
    ),
    Experience(
      job: "Architecte logiciel",
      company: "Fabernovel technologies",
      url: "https://www.fabernovel.com",
      date: const ExperienceDate(
        start: "Mai 2019",
        end: "Juin 2019",
      ),
      objective:
          "Développement d'une platforme pour le service client d'une grande banque",
      tasks: [
        "• Programmation fonctionnelle avec Kaiju, Abyssa, Spacelift",
        "• Développement de fonctionnalités (gestion de données d'utilisateur)",
        "• Création de tests unitaires",
        "• Participation aux réunions sur les dernières technologies",
        "• Monté en compétence sur la méthode agile, scrum",
        "• Revue de code, Pair programming",
      ],
    ),
    Experience(
      job: "Développeur frontend",
      company: "Dassault Systèmes",
      url: "https://3ds.com",
      date: const ExperienceDate(
        end: "2019",
        start: "2015",
      ),
      objective:
          "Développement d'une application de stockage de fichiers cloud. "
          "Dassault Système a construit son propre système de stockage cloud. "
          "Il était également question d'intégrer des services tiers tels que Dropbox, Google Drive OneDrive",
      tasks: [
        "• Intégration UI/UX",
        "• Développement frontend en JavaScript vanilla (Object pattern)",
        "• Définition et réalisation de tests utilisateur (en condition)",
        "• Gestion d'upload et téléchargement de données",
        "• Intégration d'API externes: OneDrive, GoogleDrive, Dropbox",
        "• Tests unitaires, d'intégration, end-to-end (Karma.js, Intern.js)",
        "• Rédaction de spécifications techniques",
        "• Ecriture de spécifications UX + Collaboration avec équipe UX",
        "• Collaboration avec Q/A",
        "• Création de tests unitaires, d'intégration end-to-end (jest, karma, jasmine, selenium, testharness)",
        "• Présentation des dernières avancées technologiques en réunion",
        "• Rythme: Cycle en V",
        "• Passation de connaissances",
        "• Revue de code, pair programming"
      ],
    ),
  ];

  final List<Formation> _formations = [
    Formation(
      degree: "Licence & Master d'informatique",
      school: "Université de Versailles",
      date: const ExperienceDate(start: "2010", end: "2015"),
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

  // Uint8List? _imageFile;
  // final ScreenshotController _screenshotController = ScreenshotController();

  final List<Project> _projects = [
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "mhp",
      name: "my-health-partner",
      summary:
          "Une application web pour le groupe Servier permettant de trouver"
          " des informations sur une maladie. Codé en JavaScript à l'aide de"
          " Next.JS, React.JS. Déployé sur Vercel et Azure.",
      platforms: ["Web"],
      socialLinks: SocialLinks(
        github: "https://myhealth-partner.com/",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "notapokedex",
      name: "notapokedex",
      summary: "Un Pokédex codé avec React.JS, TypeScript, MobX, GraphQL.",
      platforms: ['Web'],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/notapokedex",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "artbooking",
      name: "artbooking",
      summary:
          "Une plateforme d'illustrations avec un espace artistique virtuel,"
          " bientôt des défis et des concours.",
      platforms: ['iOS', 'Android', 'Web'],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/artbooking",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "fig.style",
      name: "fig.style",
      summary: "App de citations open-source et communautaire."
          " Recevez une notification chaque jour sur votre téléphone."
          " Recherchez par mots-clés ou par catégories.",
      platforms: ["iOS", "Android", "Web", "API"],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/fig.style",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "conway",
      name: "conway",
      summary: "Le jeu de la vie codé avec électron en JavaScript.",
      platforms: [
        "macOS",
      ],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/conway_electron",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "unsplasharp",
      name: "unsplasharp",
      summary: "Un wrapper C# des APIs d'Unsplash.",
      platforms: ["C#", "Nuget", "UWA"],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/unsplasharp",
      ),
    ),
    Project(
      createdAt: DateTime.now(),
      releasedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      id: "metrix-fitbit",
      name: "metrix-fitbit",
      summary: "Une clock face pour les bracelets Fitbit.",
      platforms: [
        "Fitbit",
      ],
      socialLinks: SocialLinks(
        github: "https://github.com/rootasjey/metrix-fitbit",
      ),
    ),
  ];

  final List<Skill> _skills = [
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
      iconData: TablerIcons.brand_javascript,
      url: "https://javascript.com",
    ),
    Skill(
      label: "node.JS",
      iconData: TablerIcons.brand_nodejs,
      url: "https://nodejs.com",
    ),
    Skill(
      label: "Python",
      iconData: TablerIcons.brand_python,
      url: "https://python.org",
    ),
    Skill(
      label: "Vue.JS",
      iconData: TablerIcons.brand_vue,
      url: "https://vuejs.org",
    ),
    Skill(
      label: "React.JS",
      iconData: TablerIcons.brand_react,
      url: "https://reactjs.com",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: tryDownloadCV,
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        icon: const Icon(TablerIcons.download),
        label: const Text("Download"),
      ),
      body: CustomScrollView(
        slivers: [
          const ApplicationBar(),
          SliverToBoxAdapter(
            child: body(),
            // child: Screenshot(
            //   controller: _screenshotController,
            //   child: body(),
            // ),
          ),
        ],
      ),
    );
  }

  Widget body() {
    return Container(
      padding: const EdgeInsets.all(80.0),
      color: Theme.of(context).scaffoldBackgroundColor,
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
    final Color accentColor = Constants.colors.getRandomFromPalette();

    return Wrap(
      spacing: 60.0,
      children: [
        BetterAvatar(
          borderSide: BorderSide(
            color: accentColor,
            width: 3.0,
          ),
          colorFilter: const ColorFilter.mode(
            Colors.grey,
            BlendMode.saturation,
          ),
          image: const AssetImage(
            "assets/images/jeje.jpg",
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  children: [
                    InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          "assets/images/jeje.jpg",
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
            const Text(
              "Jérémie CORPINOT",
              style: TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
            ),
            const Opacity(
              opacity: 0.3,
              child: Text(
                "alias rootasjey",
                style: TextStyle(
                  fontSize: 14.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12.0, bottom: 18.0),
              child: Opacity(
                opacity: 0.8,
                child: Text(
                  "Dev web fullstack",
                  style: Utilities.fonts.body2(
                    textStyle: TextStyle(
                      backgroundColor: accentColor.withOpacity(0.3),
                      fontSize: 28.0,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse("https://goo.gl/maps/Kz8roDPe8brvLpDJ7"));
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(TablerIcons.location),
                      ),
                      Text(
                        "Yvelines, France",
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse("mailto:jerem.freelance@codingbox.fr"));
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(TablerIcons.mail),
                      ),
                      Text(
                        "jerem.freelance@codingbox.fr",
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse("https://rootasjey.dev"));
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(TablerIcons.globe),
                      ),
                      Text(
                        "https://rootasjey.dev",
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: InkWell(
                onTap: () {
                  launchUrl(Uri.parse("https://github.com/rootasjey"));
                },
                child: Opacity(
                  opacity: 0.6,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Icon(TablerIcons.brand_github),
                      ),
                      Text(
                        "https://github.com/rootasjey.dev",
                        style: Utilities.fonts.body(
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
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
          style: Utilities.fonts.body(
            textStyle: const TextStyle(
              fontSize: 16.0,
            ),
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
        children: _skills.map((skill) {
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
    required String label,
    String? url,
    String? assetPath,
    IconData? iconData,
    bool blend = false,
  }) {
    final Color? foregroundColor = Theme.of(context).textTheme.bodyLarge?.color;

    return InkWell(
      key: Key(label),
      onTap: () {
        if (url == null || url.isEmpty) {
          return;
        }

        launchUrlString(url);
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
                color: blend ? foregroundColor : null,
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
                const Padding(
                  padding: EdgeInsets.only(right: 12.0),
                  child: Icon(TablerIcons.briefcase, color: Colors.blue),
                ),
                Text(
                  "Expériences Professionnelles",
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontSize: 24.0,
                    ),
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
      children: _exps.map((exp) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exp.job,
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20.0,
                  ),
                ),
              ),
              Opacity(
                opacity: 0.8,
                child: InkWell(
                  onTap: () {
                    if (exp.url.isEmpty) {
                      return;
                    }

                    launchUrlString(exp.url);
                  },
                  child: Text(
                    exp.company,
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ),
              Opacity(
                opacity: 0.5,
                child: Text(
                  "${exp.date.start} - ${exp.date.end}",
                  style: Utilities.fonts.body(
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                    ),
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
              const Padding(
                padding: EdgeInsets.only(right: 12.0),
                child: Icon(TablerIcons.school, color: Colors.green),
              ),
              Text(
                "Formation",
                style: Utilities.fonts.body(
                  textStyle: const TextStyle(
                    fontSize: 24.0,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _formations.map((formation) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formation.degree,
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Opacity(
              opacity: 0.8,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 12.0),
                    child: Icon(TablerIcons.rocket, color: Colors.pink),
                  ),
                  Text(
                    "Projects",
                    style: Utilities.fonts.body(
                      textStyle: const TextStyle(
                        fontSize: 24.0,
                      ),
                    ),
                  ),
                ],
              ),
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
        children: _projects.map((final Project project) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InkWell(
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          project.name,
                          style: Utilities.fonts.body(
                            textStyle: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      onTap: () {
                        if (project.socialLinks.github.isEmpty) {
                          return;
                        }

                        launchUrlString(project.socialLinks.github);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 6.0, bottom: 3.0),
                      child: Opacity(
                        opacity: 0.4,
                        child: Wrap(
                          spacing: 8.0,
                          children: project.platforms
                              .map((String platform) => Text(
                                    platform,
                                    style: GoogleFonts.firaCode(),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 400.0,
                      child: Opacity(
                        opacity: 0.6,
                        child: Text(
                          project.summary,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // if (project.socialLinks.image.isNotEmpty)
                //   Image.asset(
                //     project.socialLinks.image,
                //     width: 60.0,
                //     height: 60.0,
                //   ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void tryDownloadCV() async {
    // final Uint8List? imageFile = await _screenshotController.capture();
    // if (imageFile == null) {
    //   return;
    // }

    // await FileSaver.instance.saveFile("cv", imageFile, "png");
  }
}
