// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimerController on TimerControllerBase, Store {
  late final _$isLongIntervalAtom =
      Atom(name: 'TimerControllerBase.isLongInterval', context: context);

  @override
  bool get isLongInterval {
    _$isLongIntervalAtom.reportRead();
    return super.isLongInterval;
  }

  @override
  set isLongInterval(bool value) {
    _$isLongIntervalAtom.reportWrite(value, super.isLongInterval, () {
      super.isLongInterval = value;
    });
  }

  late final _$isIntervalAtom =
      Atom(name: 'TimerControllerBase.isInterval', context: context);

  @override
  bool get isInterval {
    _$isIntervalAtom.reportRead();
    return super.isInterval;
  }

  @override
  set isInterval(bool value) {
    _$isIntervalAtom.reportWrite(value, super.isInterval, () {
      super.isInterval = value;
    });
  }

  late final _$durationAtom =
      Atom(name: 'TimerControllerBase.duration', context: context);

  @override
  Duration get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
    });
  }

  late final _$totalCyclesAtom =
      Atom(name: 'TimerControllerBase.totalCycles', context: context);

  @override
  int get totalCycles {
    _$totalCyclesAtom.reportRead();
    return super.totalCycles;
  }

  @override
  set totalCycles(int value) {
    _$totalCyclesAtom.reportWrite(value, super.totalCycles, () {
      super.totalCycles = value;
    });
  }

  late final _$TimerControllerBaseActionController =
      ActionController(name: 'TimerControllerBase', context: context);

  @override
  Duration initializeDuration(int? userDuration, bool isIntervalParam) {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.initializeDuration');
    try {
      return super.initializeDuration(userDuration, isIntervalParam);
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  Duration decrementSeconds(TimerModel timerModel) {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.decrementSeconds');
    try {
      return super.decrementSeconds(timerModel);
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  dynamic incrementCyle() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.incrementCyle');
    try {
      return super.incrementCyle();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLongInterval: ${isLongInterval},
isInterval: ${isInterval},
duration: ${duration},
totalCycles: ${totalCycles}
    ''';
  }
}
