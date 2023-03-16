import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:pomodoro_jera/controllers/timer_controller.dart';
import 'package:pomodoro_jera/model/timer_model.dart';

void main() {
  var controller = TimerController();
  var timerModel = TimerModel(timerGoal: 2);
  Timer? timer;

  test("Test if the function initializeDuration is working as expected", () {
    var result = controller.initializeDuration(timerModel.timerGoal, false);

    expect(result.inMinutes, 2);
  });

  test("Test if the function twoDigitsFormat is working as expected when the number is one digit", () {
    var result = controller.twoDigitsFormater(5);

    expect(result, '05');
  });

  test("Test if the function twoDigitsFormat is working as expected when the number is two digit", () {
    var result = controller.twoDigitsFormater(12);

    expect(result, '12');
  });

  test("Test if the function startTimer is working as expected, changing the timeStarted and activating the timer", () {
    controller.startTimer(timerModel);

    expect(timerModel.timerStarted, true);
  });

  test("Test if the function timerDecrement is working as expected decrementing one by one", () async {
    controller.startTimer(timerModel);
    var result = controller.decrementSeconds(timerModel);

    Future.delayed(const Duration(seconds: 5)).then((value) {
      expect(result.inSeconds, 115);
    });
  });

  test("Test if the function incrementCycle is working as expected", () async {
    controller.incrementCyle();

    expect(controller.auxiliar != 0, true);

    controller.incrementCyle();
    controller.incrementCyle();

    expect(controller.cycles != 0, true);
  });
}
