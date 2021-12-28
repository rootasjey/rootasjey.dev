import 'package:beamer/beamer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/avatar/better_avatar.dart';
import 'package:rootasjey/components/footer/footer.dart';
import 'package:rootasjey/components/application_bar/main_app_bar.dart';
import 'package:rootasjey/types/globals/globals.dart';
import 'package:rootasjey/types/post.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutMePage extends StatefulWidget {
  @override
  _AboutMePageState createState() => _AboutMePageState();
}

class _AboutMePageState extends State<AboutMePage> {
  final postsList = <Post>[];
  final limit = 10;

  bool hasNext = true;
  bool isLoading = false;

  DocumentSnapshot? doc;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          MainAppBar(),
          SliverLayoutBuilder(
            builder: (context, constraints) {
              if (constraints.crossAxisExtent < 700.0) {
                return narrowView();
              }

              return largeView();
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Footer(),
            ]),
          ),
        ],
      ),
    );
  }

  Widget artistAvatar(
      {required String imageUrl, required String name, String? url}) {
    return Column(
      children: [
        BetterAvatar(
          elevation: 0,
          size: 130.0,
          image: NetworkImage(imageUrl),
          onTap: () => launch(url!),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: Opacity(
            opacity: 0.6,
            child: Text(
              name,
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget artistsList() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
      ),
      child: Wrap(
        spacing: 30.0,
        runSpacing: 30.0,
        children: [
          artistAvatar(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Fartists%2Fcoeur-de-pirate.jpg?alt=media&token=ef9e553a-b296-4a3a-aa08-922a0b6e93d6',
            name: 'Cœur de Pirate',
            url: 'https://youtu.be/VmsSvsvkDGE',
          ),
          artistAvatar(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Fartists%2Fgrimes.jpeg?alt=media&token=ef6497fc-0a86-4b35-8394-4ad39b09a0cb',
            name: 'Grimes',
            url: 'https://youtu.be/Fb_0LzBv894',
          ),
          artistAvatar(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Fartists%2Fhalsey.jpg?alt=media&token=83caffeb-ba63-4b61-a1b8-480b00940eb5',
            name: 'Halsey',
            url: 'https://youtu.be/yOwZRx5oFCs',
          ),
          artistAvatar(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Fartists%2Fjanelle-monae.jpg?alt=media&token=0c8bf941-bea0-45de-9299-e65f4d4377f2',
            name: 'Janelle Monaé',
            url: 'https://youtu.be/LPFgBCUBMYk',
          ),
          artistAvatar(
            imageUrl:
                'https://firebasestorage.googleapis.com/v0/b/rootasjey.appspot.com/o/images%2Fartists%2Fkimbra.jpg?alt=media&token=7c810c27-7ad2-455f-8e8a-5c60eab9970e',
            name: 'Kimbra',
            url: 'https://youtu.be/U98rZw78-iA',
          ),
        ],
      ),
    );
  }

  Widget avatarAndPresentation() {
    return Row(
      children: [
        profilePicture(
          padding: const EdgeInsets.only(
            right: 60.0,
          ),
        ),
        Expanded(
          child: profileSummary(),
        ),
      ],
    );
  }

  Widget formation() {
    return Container(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 120.0,
              bottom: 16.0,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: Icon(
                    Icons.school,
                    size: 40.0,
                  ),
                ),
                Text(
                  "formation".tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                    color: Globals.constants.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          textBlock(
            text: "formation_degree".tr(),
          ),
          textBlock(
            text: "formation_benefits".tr(),
          ),
        ],
      ),
    );
  }

  Widget header({required String title, Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 120.0,
        bottom: 16.0,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: 20.0,
            ),
            child: icon,
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 40.0,
              fontWeight: FontWeight.w300,
              color: Globals.constants.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget pageTitle({EdgeInsets padding = const EdgeInsets.all(90.0)}) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              onPressed: Beamer.of(context).beamBack,
              icon: Icon(UniconsLine.arrow_left),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'rootasjey',
                style: TextStyle(
                  fontSize: 70.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Opacity(
                opacity: 0.6,
                child: Text(
                  'alias Jeremie Corpinot',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget subHeader({required String title, Widget? icon}) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 30.0,
        bottom: 30.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                right: 20.0,
              ),
              child: icon,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget hobbies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header(
          icon: Icon(Icons.sports_baseball, size: 40.0),
          title: "hobbies".tr(),
        ),
        textBlock(
          text: "hobbies_description".tr(),
        ),
        Container(
          width: 600.0,
          padding: const EdgeInsets.only(
            bottom: 40.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subHeader(
                title: "hobbies_games".tr().toUpperCase(),
                icon: Icon(Icons.gamepad, size: 30.0),
              ),
              textBlock(
                text: "hobbies_games_1".tr(),
              ),
              textBlock(
                text: "hobbies_games_2".tr(),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                children: [
                  musicGenderButton(
                    name: 'Transistor',
                    url: 'https://www.supergiantgames.com/games/transistor/',
                  ),
                  musicGenderButton(
                    name: 'Octopath Travelers',
                    url:
                        'https://www.nintendo.com/games/detail/octopath-traveler-switch/',
                  ),
                  musicGenderButton(
                    name: 'Gris',
                    url: 'https://nomada.studio/',
                  ),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            subHeader(
              title: "music".tr().toUpperCase(),
              icon: Icon(Icons.music_note, size: 30.0),
            ),
            textBlock(
              text: "music_description".tr(),
            ),
            Wrap(
              spacing: 10.0,
              runSpacing: 10.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                musicGenderButton(
                  name: 'Alternative',
                  url: 'https://youtu.be/WDhEG0mDxcY',
                ),
                musicGenderButton(
                  name: 'Electro',
                  url: 'https://www.youtube.com/watch?v=SsyQuihiLmI',
                ),
                musicGenderButton(
                  name: 'R&B',
                  url: 'https://www.youtube.com/watch?v=Nr03OPoXNrw',
                ),
                musicGenderButton(
                  name: 'Rock',
                  url: 'https://youtu.be/Ur17pfjIRVo',
                ),
                musicGenderButton(
                  name: 'Jazz/Funk (Electro)',
                  url: 'https://youtu.be/wn5Q37qOiiA',
                ),
                musicGenderButton(
                  name: '???',
                  url: 'https://soundcloud.com/macross-82-99/82-99-x-uppr',
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 60.0,
              ),
              child: textBlock(
                text: "music_artists_love".tr(),
              ),
            ),
            artistsList(),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(
            top: 80.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              subHeader(
                title: "books".tr().toUpperCase(),
                icon: Icon(Icons.library_books, size: 30.0),
              ),
              textBlock(
                text: "books_description".tr(),
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 10.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  musicGenderButton(
                    name: "book_quebert".tr(),
                    url:
                        'https://books.google.fr/books/about/The_Truth_about_the_Harry_Quebert_Affair.html?id=IS9hBQAAQBAJ&printsec=frontcover&source=kp_read_button&redir_esc=y#v=onepage&q&f=false',
                  ),
                  musicGenderButton(
                    name: "Le Puits des Mémoires",
                    url:
                        'https://www.amazon.com/Puits-m%C3%A9moires-1-traque/dp/2266244515',
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget musicGenderButton({required String name, String? url}) {
    return OutlinedButton(
      onPressed: () => launch(url!),
      child: Opacity(
        opacity: 0.6,
        child: Text(name,
            style: TextStyle(
              fontSize: 16.0,
            )),
      ),
    );
  }

  Widget professionalExp() {
    return Container(
      width: 600.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 120.0,
              bottom: 16.0,
            ),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20.0,
                  ),
                  child: Icon(Icons.work_outline, size: 40.0),
                ),
                Text(
                  "pro_exp".tr().toUpperCase(),
                  style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.w300,
                    color: Globals.constants.colors.primary,
                  ),
                ),
              ],
            ),
          ),
          textBlock(text: "pro_exp_1".tr()),
          textBlock(text: "pro_exp_2".tr()),
          textBlock(text: "pro_exp_3".tr()),
          textBlock(text: "pro_exp_4".tr()),
        ],
      ),
    );
  }

  Widget textBlock({required String text}) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 40.0,
      ),
      child: Opacity(
        opacity: 0.6,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w300,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget largeView() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        bottom: 200.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          pageTitle(),
          Padding(
            padding: const EdgeInsets.only(left: 140.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 800.0,
                  child: avatarAndPresentation(),
                ),
                formation(),
                professionalExp(),
                hobbies(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget narrowView() {
    return SliverPadding(
      padding: const EdgeInsets.only(
        bottom: 200.0,
      ),
      sliver: SliverList(
        delegate: SliverChildListDelegate.fixed([
          pageTitle(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 80.0,
              bottom: 60.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    bottom: 80.0,
                  ),
                  child: Center(
                    child: profilePicture(),
                  ),
                ),
                profileSummary(),
                formation(),
                professionalExp(),
                hobbies(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  Widget profilePicture({EdgeInsets padding = EdgeInsets.zero}) {
    return Padding(
      padding: padding,
      child: Hero(
        tag: 'pp',
        child: BetterAvatar(
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
      ),
    );
  }

  Widget profileSummary() {
    return Opacity(
      opacity: 0.6,
      child: Text(
        "profile_summary".tr(),
        style: TextStyle(
          fontSize: 26.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }
}
