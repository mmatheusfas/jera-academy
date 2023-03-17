import 'dart:async';
import 'package:pomodoro_jera/model/timer_model.dart';
import 'package:mobx/mobx.dart';
part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  Timer? countDownTimer;
  int auxiliar = 0;
  bool isLongInterval = false;
  int cycles = 0;

  @observable
  bool isInterval = false;
  @observable
  Duration duration = const Duration();
  @observable
  int totalCycles = 0;

  @action
  Duration initializeDuration(int? userDuration, bool isIntervalParam) {
    if (isIntervalParam && auxiliar % 2 != 0) {
      isInterval = true;
      return duration = const Duration(seconds: 2);
    } else {
      //LONG INTERVAL
      if (cycles != 0 && cycles % 4 == 0) {
        isInterval = false;
        isLongInterval = true;
        return duration = const Duration(seconds: 4);
      }
    }
    if (userDuration != null) {
      isInterval = false;
      return duration = Duration(minutes: userDuration);
    }
    isInterval = false;
    return duration = const Duration(minutes: 1);
  }

  String twoDigitsFormater(int time) {
    return time.toString().padLeft(2, '0');
  }

  startTimer(TimerModel timerModel) {
    timerModel.timerStarted = !timerModel.timerStarted;

    if (timerModel.itsPaused) {
      timerModel.itsPaused = false;
      countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
    } else {
      initializeDuration(timerModel.timerGoal, isInterval ? true : false);
      countDownTimer = Timer.periodic(const Duration(seconds: 1), (_) => decrementSeconds(timerModel));
    }
  }

  stopTimer(TimerModel timerModel) {
    if (timerModel.timerStarted) {
      timerModel.timerStarted = false;
      timerModel.itsPaused = true;
      countDownTimer!.cancel();
    }
  }

  @action
  Duration decrementSeconds(TimerModel timerModel) {
    var seconds = duration.inSeconds;
    seconds--;

    if (seconds == 0) {
      incrementCyle();
      initializeDuration(timerModel.timerGoal, auxiliar % 2 == 0 && auxiliar != 0 ? false : true);
      stopTimer(timerModel);
      return duration;
    } else {
      duration = Duration(seconds: seconds);
      print("Duration ${duration.inMinutes.remainder(60)}:${duration.inSeconds.remainder(60)}");
      return duration;
    }
  }

  incrementCyle() {
    if (!isLongInterval) {
      if (auxiliar == 0) {
        auxiliar++;
        return;
      }
      auxiliar++;
      if (auxiliar % 2 == 0) {
        cycles++;
        totalCycles++;
      }
    } else {
      isLongInterval = false;
      auxiliar = 0;
      cycles = 0;
    }
  }
}
