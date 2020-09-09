import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rootasjey/components/home_app_bar.dart';
import 'package:rootasjey/rooter/route_names.dart';
import 'package:rootasjey/state/colors.dart';
import 'package:rootasjey/types/post_headline.dart';
import 'package:share/share.dart';
import 'package:supercharged/supercharged.dart';
import 'package:url_launcher/url_launcher.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  bool hasNext                = true;
  bool hasErrors              = false;
  bool isFabVisible           = false;
  bool isLoading              = false;
  bool isLoadingMore          = false;
  bool isSearchingPosts     = false;
  bool isSearchingQuotes      = false;
  bool isSearchingReferences  = false;

  int limit = 30;

  final pageRoute = SearchRoute;
  FocusNode searchFocusNode;
  ScrollController scrollController;

  String searchInputValue = '';

  TextEditingController searchInputController;

  Timer _searchTimer;

  var lastDoc;

  @override
  initState() {
    super.initState();
    searchFocusNode = FocusNode();
    searchInputController = TextEditingController();
    scrollController = ScrollController();
  }

  @override
  dispose() {
    searchFocusNode.dispose();
    scrollController.dispose();
    searchInputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: isFabVisible ?
        FloatingActionButton(
          onPressed: () {
            scrollController.animateTo(
              0.0,
              duration: Duration(seconds: 1),
              curve: Curves.easeOut,
            );
          },
          backgroundColor: stateColors.primary,
          foregroundColor: Colors.white,
          child: Icon(Icons.arrow_upward),
        ) : null,
      body: body(),
    );
  }

  Widget body() {
    return RefreshIndicator(
      onRefresh: () async {
        await search();
        return null;
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollNotif) {
          // FAB visibility
          if (scrollNotif.metrics.pixels < 50 && isFabVisible) {
            setState(() {
              isFabVisible = false;
            });
          } else if (scrollNotif.metrics.pixels > 50 && !isFabVisible) {
            setState(() {
              isFabVisible = true;
            });
          }

          // Load more scenario
          if (scrollNotif.metrics.pixels <
              scrollNotif.metrics.maxScrollExtent) {
            return false;
          }

          return false;
        },
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            HomeAppBar(
              title: Opacity(
                opacity: 0.6,
                child: Text(
                  'Search',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: stateColors.foreground,
                  ),
                ),
              ),
              automaticallyImplyLeading: true,
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(
                horizontal: 100.0,
              ),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  searchHeader(),

                  // quotesSection(),
                  // authorsSection(),
                  // referencesSection(),

                  Padding(padding: const EdgeInsets.only(bottom: 300.0)),
                ]),
              ),
            ),
          ],
        ),
      )
    );
  }

  Widget authorsSection() {
    return Padding(
      padding: EdgeInsets.zero,
    );
    // if (searchInputValue.isEmpty) {
    //   return Padding(
    //     padding: EdgeInsets.zero,
    //   );
    // }

    // final dataView = authorsResults.isEmpty
    //   ? emptyView('authors')
    //   : authorsResultsView();

    // return Padding(
    //   padding: const EdgeInsets.only(top: 40.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       titleSection(
    //         text: '${authorsResults.length} authors',
    //       ),

    //       dataView,
    //     ],
    //   ),
    // );
  }

  Widget quotesSection() {
    return Padding(
      padding: EdgeInsets.zero,
    );
    // if (searchInputValue.isEmpty) {
    //   return Padding(
    //     padding: EdgeInsets.zero,
    //   );
    // }

    // final dataView = quotesResults.isEmpty
    //   ? emptyView('quotes')
    //   : quotesResultsView();

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.start,
    //   children: [
    //     titleSection(
    //       text: '${quotesResults.length} quotes',
    //     ),

    //     dataView,
    //   ],
    // );
  }

  Widget referencesSection() {
    return Padding(
      padding: EdgeInsets.zero,
    );
    // if (searchInputValue.isEmpty) {
    //   return Padding(
    //     padding: EdgeInsets.zero,
    //   );
    // }

    // final dataView = quotesResults.isEmpty
    //   ? emptyView('quotes')
    //   : referencesResultsView();

    // return Padding(
    //   padding: const EdgeInsets.only(top: 40.0),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       titleSection(
    //         text: '${referencesResults.length} references',
    //       ),

    //       dataView,
    //     ],
    //   ),
    // );
  }

  Widget titleSection({String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 26.0,
          color: stateColors.primary,
        ),
      ),
    );
  }

  Widget emptyView(String subject) {
    return Opacity(
      opacity: 0.6,
      child: Text(
        'No $subject found for "$searchInputValue"',
        style: TextStyle(
          fontSize: 18.0,
        ),
      ),
    );
  }

  Widget errorView(String subject) {
    return SliverList(
      delegate: SliverChildListDelegate([
        Opacity(
          opacity: 0.6,
          child: Text(
            'There was an issue while searching $subject for "$searchInputValue". You can try again.',
            style: TextStyle(
              fontSize: 18.0,
            ),
          ),
        ),

        OutlineButton.icon(
          onPressed: () {
            switch (subject) {
              case 'quotes':
                searchQuotes();
                break;
              case 'authors':
                searchPosts();
                break;
              case 'references':
                searchReferences();
                break;
              default:
            }
          },
          icon: Icon(Icons.refresh),
          label: Text('Retry'),
        ),
      ]),
    );
  }

  Widget searchActions() {
    return Wrap(
      spacing: 20.0,
      runSpacing: 20.0,
      children: [
        RaisedButton.icon(
          onPressed: () {
            searchInputValue = '';
            searchInputController.clear();
            searchFocusNode.requestFocus();

            setState(() {});
          },
          icon: Opacity(opacity: 0.6, child: Icon(Icons.clear)),
          label: Opacity(
            opacity: 0.6,
            child: Text(
              'Clear content',
            ),
          )
        ),
      ]
    );
  }

  Widget searchHeader() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 100.0,
        bottom: 50.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          searchInput(),
          searchActions(),
          searchResultsData(),
        ],
      ),
    );
  }

  Widget searchInput() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0),
      child: TextField(
        maxLines: null,
        autofocus: true,
        focusNode: searchFocusNode,
        controller: searchInputController,
        keyboardType: TextInputType.multiline,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (newValue) {
          final refresh = searchInputValue != newValue && newValue.isEmpty;

          searchInputValue = newValue;

          if (newValue.isEmpty) {
            if (refresh) { setState(() {}); }
            return;
          }

          if (_searchTimer != null) {
            _searchTimer.cancel();
          }

          _searchTimer = Timer(
            500.milliseconds,
            () => search(),
          );
        },
        style: TextStyle(
          fontSize: 36.0,
        ),
        decoration: InputDecoration(
          icon: Icon(Icons.search),
          hintText: 'Search quote...',
          border: OutlineInputBorder(
            borderSide: BorderSide.none
          ),
        ),
      ),
    );
  }

  Widget searchResultsData() {
    if (searchInputValue.isEmpty) {
      return Padding(padding: EdgeInsets.zero);
    }

    return Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: Opacity(
        opacity: 0.6,
        child: Column(
          children: <Widget>[
            Text(
              '',
              // '${quotesResults.length + authorsResults.length + referencesResults.length} results in total',
              style: TextStyle(
                fontSize: 25.0,
              ),
            ),

            SizedBox(
              width: 200.0,
              child: Divider(thickness: 1.0,),
            ),
          ],
        ),
      ),
    );
  }

  Future search() async {
    searchPosts();
    searchQuotes();
    searchReferences();
  }

  void searchPosts() async {
    setState(() {
      isSearchingPosts = false;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('authors')
        .where('name', isGreaterThanOrEqualTo: searchInputValue)
        .limit(10)
        .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      snapshot.docs.forEach((element) {
        final data = element.data();
        data['id'] = element.id;
      });

      setState(() {
        isSearchingPosts = false;
      });

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void searchQuotes() async {
    setState(() {
      isSearchingQuotes = false;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('quotes')
        .where('name', isGreaterThanOrEqualTo: searchInputValue)
        .limit(10)
        .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      snapshot.docs.forEach((element) {
        final data = element.data();
        data['id'] = element.id;
      });

      setState(() {
        isSearchingQuotes = false;
      });

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void searchReferences() async {
    setState(() {
      isSearchingReferences = false;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('references')
        .where('name', isGreaterThanOrEqualTo: searchInputValue)
        .limit(10)
        .get();

      if (snapshot.docs.isEmpty) {
        return;
      }

      snapshot.docs.forEach((element) {
        final data = element.data();
        data['id'] = element.id;
      });

      setState(() {
        isSearchingReferences = false;
      });

    } catch (error) {
      debugPrint(error.toString());
    }
  }

  void sharePost(PostHeadline headline) {
    if (kIsWeb) {
      sharePostWeb(headline);
      return;
    }

    sharePostMobile(headline);
  }

  void sharePostWeb(PostHeadline headline) async {
    String sharingText = headline.title;
    final urlReference = 'https://outofcontext.app/#/reference/${headline.id}';

    final hashtags = '&hashtags=rootasjey';

    await launch(
      'https://twitter.com/intent/tweet?via=rootasjey&text=$sharingText$hashtags&url=$urlReference',
    );
  }

  void sharePostMobile(PostHeadline headline) {
    final RenderBox box = context.findRenderObject();
    String sharingText = headline.title;
    final urlReference = 'https://outofcontext.app/#/reference/${headline.id}';

    sharingText += ' - URL: $urlReference';

    Share.share(
      sharingText,
      subject: 'rootasjey',
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size,
    );
  }
}
