import 'package:mobx/mobx.dart';

part 'scroll.g.dart';

class StateScroll = StateScrollBase with _$StateScroll;

abstract class StateScrollBase with Store {
  @observable
  bool hasReachedEnd = false;

  @action
  void setHasReachedEnd(bool newValue) {
    hasReachedEnd = newValue;
  }
}

final stateDraftProjectsScroll = StateScroll();
final stateDraftPostsScroll = StateScroll();
final statePubProjectsScroll = StateScroll();
final statePubPostsScroll = StateScroll();
