import 'package:mobx/mobx.dart';

part 'scroll.g.dart';

class StateScroll = StateScrollBase with _$StateScroll;

abstract class StateScrollBase with Store {
  @observable
  bool hasReachEnd = false;

  @action
  void setHasReachEnd(bool newValue) {
    hasReachEnd = newValue;
  }
}

final stateDraftProjectsScroll = StateScroll();
