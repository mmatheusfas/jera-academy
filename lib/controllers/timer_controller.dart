import 'dart:async';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:mobx/mobx.dart';
part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  Timer? countDownTimer;
  Duration duration = const Duration();
  int cycles = 0;
  TimerModel timer = TimerModel();
  int auxiliar = 0;

  Duration initializeDuration(int? userDuration, bool isIntervalParam) {
    if (isIntervalParam) {
      return duration = const Duration(minutes: 5);
    } else {
      if (cycles != 0 && cycles % 4 == 0) {
        return duration = const Duration(minutes: 10);
      }
    }
    if (userDuration != null) {
      return duration = Duration(minutes: userDuration);
    }
    return duration = const Duration(minutes: 25);
  }

  String twoDigitsFormater(int time) {
    return time.toString().padLeft(2, '0');
  }

  startTimer(TimerModel timerModel, Timer? timer) {
    timerModel.timerStarted = !timerModel.timerStarted;
    initializeDuration(timerModel.timerGoal, false);
    countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
  }

  stopTimer(TimerModel timerModel) {
    if (timerModel.timerStarted) {
      timerModel.timerStarted = false;
      countDownTimer!.cancel();
    }
  }

  Duration decrementSeconds(TimerModel timerModel) {
    var reduceSecondsBy = 1;
    var seconds = duration.inSeconds - reduceSecondsBy;

    if (seconds == 0) {
      initializeDuration(null, auxiliar % 2 == 0 ? false : true);
      incrementCyle();
    } else {
      return duration = Duration(seconds: seconds);
    }
    throw Exception();
  }

  incrementCyle() {
    if (auxiliar == 0) {
      auxiliar++;
      return;
    }
    auxiliar++;
    if (auxiliar % 2 == 0) {
      cycles++;
    }
  }
}
