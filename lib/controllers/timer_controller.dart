import 'dart:async';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:mobx/mobx.dart';
part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  Timer? countDownTimer;
  TimerModel timer = TimerModel();
  int auxiliar = 0;
  @observable
  Duration duration = const Duration();
  @observable
  int cycles = 0;

  @action
  Duration initializeDuration(int? userDuration, bool isIntervalParam) {
    if (isIntervalParam) {
      return duration = const Duration(seconds: 20);
    } else {
      //LONG INTERVAL
      if (cycles != 0 && cycles % 4 == 0) {
        return duration = const Duration(seconds: 21);
      }
    }
    if (userDuration != null) {
      return duration = Duration(minutes: userDuration);
    }
    return duration = const Duration(seconds: 2);
  }

  String twoDigitsFormater(int time) {
    return time.toString().padLeft(2, '0');
  }

  startTimer(TimerModel timerModel) {
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

  @action
  Duration decrementSeconds(TimerModel timerModel) {
    var reduceSecondsBy = 1;
    var seconds = duration.inSeconds - reduceSecondsBy;

    if (seconds == 0) {
      initializeDuration(null, auxiliar % 2 == 0 && auxiliar != 0 ? false : true);
      incrementCyle();
      stopTimer(timerModel);

      return duration;
    } else {
      return duration = Duration(seconds: seconds);
    }
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
