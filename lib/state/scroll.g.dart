// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StateScroll on StateScrollBase, Store {
  final _$hasReachEndAtom = Atom(name: 'StateScrollBase.hasReachEnd');

  @override
  bool get hasReachEnd {
    _$hasReachEndAtom.reportRead();
    return super.hasReachEnd;
  }

  @override
  set hasReachEnd(bool value) {
    _$hasReachEndAtom.reportWrite(value, super.hasReachEnd, () {
      super.hasReachEnd = value;
    });
  }

  final _$StateScrollBaseActionController =
      ActionController(name: 'StateScrollBase');

  @override
  void setHasReachEnd(bool newValue) {
    final _$actionInfo = _$StateScrollBaseActionController.startAction(
        name: 'StateScrollBase.setHasReachEnd');
    try {
      return super.setHasReachEnd(newValue);
    } finally {
      _$StateScrollBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasReachEnd: ${hasReachEnd}
    ''';
  }
}
