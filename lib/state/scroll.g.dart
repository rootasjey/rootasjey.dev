// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scroll.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$StateScroll on StateScrollBase, Store {
  final _$hasReachedEndAtom = Atom(name: 'StateScrollBase.hasReachedEnd');

  @override
  bool get hasReachedEnd {
    _$hasReachedEndAtom.reportRead();
    return super.hasReachedEnd;
  }

  @override
  set hasReachedEnd(bool value) {
    _$hasReachedEndAtom.reportWrite(value, super.hasReachedEnd, () {
      super.hasReachedEnd = value;
    });
  }

  final _$StateScrollBaseActionController =
      ActionController(name: 'StateScrollBase');

  @override
  void setHasReachedEnd(bool newValue) {
    final _$actionInfo = _$StateScrollBaseActionController.startAction(
        name: 'StateScrollBase.setHasReachedEnd');
    try {
      return super.setHasReachedEnd(newValue);
    } finally {
      _$StateScrollBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
hasReachedEnd: ${hasReachedEnd}
    ''';
  }
}
