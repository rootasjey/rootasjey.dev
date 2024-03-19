import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:rootasjey/components/square_header.dart';
import 'package:rootasjey/globals/constants.dart';
import 'package:rootasjey/globals/utils.dart';
import 'package:rootasjey/screens/curriculum/bread_button_selector.dart';
import 'package:rootasjey/screens/curriculum/card_content_chooser.dart';
import 'package:rootasjey/types/enums/enum_curriculum_item.dart';
import 'package:rootasjey/types/experience.dart';
import 'package:rootasjey/types/experience_date.dart';
import 'package:rootasjey/types/formation.dart';
import 'package:rootasjey/types/skill.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class CurriculumPage extends StatefulWidget {
  const CurriculumPage({
    super.key,
    this.onGoBack,
    this.onGoHome,
  });

  /// Called when the user goes back.
  final void Function()? onGoBack;

  /// Called when the user goes back to the home page.
  final void Function()? onGoHome;

  @override
  State<StatefulWidget> createState() => _CurriculumPageState();
}

class _CurriculumPageState extends State<CurriculumPage> {
  /// Selected tab.
  EnumCurriculumItem _selectedTab = EnumCurriculumItem.identity;

  /// List of experiences.
  final List<Experience> _experiences = [
    "comptoirs",
    "servier",
    "openclassrooms",
    "coding_box",
    "fabernovel",
    "dassault_systems",
  ].map((String name) {
    final String prefix = "experience.map.$name";
    return Experience(
      company: "$prefix.company".tr(),
      job: "$prefix.job".tr(),
      url: "$prefix.website".tr(),
      date: ExperienceDate(
        end: "$prefix.end_date".tr(),
        start: "$prefix.start_date".tr(),
      ),
      objective: "$prefix.target".tr(),
      tasks: [
        "$prefix.tasks.0".tr(),
        "$prefix.tasks.1".tr(),
        "$prefix.tasks.2".tr(),
        "$prefix.tasks.3".tr(),
        "$prefix.tasks.4".tr(),
        "$prefix.tasks.5".tr(),
      ],
    );
  }).toList();

  /// List of formations.
  final List<Formation> _formations = ["master_versailles"].map((String name) {
    final String prefix = "formation.map.$name";
    return Formation(
      degree: "$prefix.degree".tr(),
      school: "$prefix.school".tr(),
      date: ExperienceDate(
        start: "$prefix.start_date",
        end: "$prefix.end_date",
      ),
      tasks: [
        "$prefix.tasks.0".tr(),
        "$prefix.tasks.1".tr(),
        "$prefix.tasks.2".tr(),
        "$prefix.tasks.3".tr(),
        "$prefix.tasks.4".tr(),
        "$prefix.tasks.5".tr(),
      ],
      url: "$prefix.website".tr(),
    );
  }).toList();

  /// List of skills.
  final List<Skill> _skills = [
    Skill(
      label: "Firebase",
      iconData: TablerIcons.brand_firebase,
      url: "https://firebase.com",
    ),
    Skill(
      label: "GCP",
      iconData: TablerIcons.brand_google_big_query,
      url: "https://firebase.com",
    ),
    Skill(
      label: "Flutter",
      iconData: TablerIcons.brand_flutter,
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

  /// Accent color used for the background.
  Color _accentColor = Constants.colors.getRandomBackground();

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final Size windowSize = MediaQuery.of(context).size;
    final bool isMobileSize = Utils.graphic.isMobileFromSize(windowSize);
    const Size externalSize = Size(530.0, 390.0);

    return Scaffold(
      backgroundColor: isDark
          ? Color.alphaBlend(Colors.black54, _accentColor)
          : _accentColor.withOpacity(0.4),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Tilt(
              borderRadius: BorderRadius.circular(16.0),
              shadowConfig: const ShadowConfig(
                offsetInitial: Offset(2.0, 2.0),
                spreadInitial: 4.0,
                minIntensity: 0.4,
              ),
              child: SizedBox(
                height: externalSize.height,
                width: externalSize.width,
                child: Center(
                  child: Card(
                    color: isDark ? null : _accentColor,
                    elevation: 6.0,
                    child: InkWell(
                      onTap: pickRandomColor,
                      borderRadius: BorderRadius.circular(12.0),
                      child: SizedBox(
                        height: externalSize.height - 40.0,
                        width: externalSize.width - 20.0,
                        child: Stack(
                          children: [
                            CardContentChooser(
                              isMobileSize: isMobileSize,
                              onTapAvatar: onTapAvatar,
                              selectedTab: _selectedTab,
                              skills: _skills,
                              experiences: _experiences,
                              cardSize: externalSize,
                              onTapCompany: onTapCompany,
                              formations: _formations,
                            ),
                            Positioned(
                              bottom: 12.0,
                              left: 24.0,
                              child: BreadButtonSelector(
                                selectedItem: _selectedTab,
                                onSelectionChanged: onSelectedTabChanged,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SquareHeader(
            onGoBack: widget.onGoBack,
            onGoHome: widget.onGoHome,
          ),
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
            ],
          ),
        ],
      ),
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
          style: Utils.calligraphy.body(
            textStyle: const TextStyle(
              fontSize: 16.0,
            ),
          ),
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
                  style: Utils.calligraphy.body(
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
      children: _experiences.map((exp) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                exp.job,
                style: Utils.calligraphy.body(
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
                    style: Utils.calligraphy.body(
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
                  style: Utils.calligraphy.body(
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
                style: Utils.calligraphy.body(
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
                    style: Utils.calligraphy.body(
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

  void onTapAvatar() {
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
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Callback to change the selected tab.
  void onSelectedTabChanged(EnumCurriculumItem newItem) {
    setState(() => _selectedTab = newItem);
  }

  /// Callback to pick a random color.
  void pickRandomColor() {
    setState(() {
      _accentColor = Constants.colors.getRandomBackground();
    });
  }

  /// Callback fired when the user taps on the company name.
  void onTapCompany(Experience experience) {
    if (experience.url.isEmpty) {
      return;
    }

    launchUrlString(experience.url);
  }
}
